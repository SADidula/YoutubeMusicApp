import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempo_fy/main.dart';
import 'package:tempo_fy/models/channel.dart';
import 'package:tempo_fy/models/playlist.dart';
import 'package:tempo_fy/models/search.dart';
import 'package:tempo_fy/models/seek_bar.dart';
import 'package:tempo_fy/screens/add_playlist_screen.dart';
import 'package:tempo_fy/screens/home_screen.dart';
import 'package:tempo_fy/screens/more_option_screen.dart';
import 'package:tempo_fy/screens/playlist_items_screen.dart';
import 'package:tempo_fy/screens/playlist_screen.dart';
import 'package:tempo_fy/screens/search_result_screen.dart';
import 'package:tempo_fy/screens/search_screen.dart';
import 'package:tempo_fy/screens/video_screen.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

import '../models/video.dart';

final selectedVideoProvider = StateProvider<Video?>((ref) => null);
final selectedPlaylistProvider = StateProvider<Playlist?>((ref) => null);

final selectedSearchProvider = StateProvider<Search?>((ref) => null);
final searchProvider = StateProvider<List<Search?>>((ref) => List.empty());

final moreOptionProvider = StateProvider<Video?>((ref) => null);
final addPlaylistProvider = StateProvider<bool?>((ref) => false);

final miniplayerHeightProvider = StateProvider<bool?>((ref) => false);

bool _isVideoSelected = false,
    _streamOnce = false,
    _isPlaylistSelected = false,
    _isPlayerReady = false,
    hasEnded = false;

Video? prevVideo = null;

late StreamController<Duration> _positionStreamController;
late Stream<Duration> _positionStream;

late StreamController<Duration> _durationStreamController;
late Stream<Duration> _durationStream;

late StreamController<PlayerState> _playerStateStreamController;
late Stream<PlayerState> _playerStateStream;

late Stream<SeekBarData> broadcastStream;
late Stream<PlayerState> playerStateStreamBroadcast;

final miniPlayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
  (ref) => MiniplayerController(),
);

class NavScreen extends StatefulWidget {
  @override
  _NavScreenState createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  static const double _playerMinHeight = 60.0;
  int _selectedIndex = 0;

  final _screens = [
    HomeScreen(),
    SearchScreen(),
    // PlaylistScreen(),
    // const Scaffold(body: Center(child: Text('Explore'))),
    // const Scaffold(body: Center(child: Text('Add'))),
    // const Scaffold(body: Center(child: Text('Subscriptions'))),
    PlaylistScreen(),
  ];

  @override
  void initState() {
    super.initState();

    //dummy video id
    currentPlayinglist['GizyKd5i_sE'] = Video(
      id: '',
      title: '',
      description: '',
      thumbnail: '',
      duration: '',
      timestamp: DateTime.now(),
      channel: Channel(
        id: '',
        title: '',
        description: '',
        alias: '',
        thumbnail: '',
      )
    );
    //GizyKd5i_sE
    youtubePlayerController = setVideoController(0, false, true, true);
  }

  YoutubePlayerController setVideoController(
      int index, bool isMute, bool autoPlay, bool isHD,
      {String videoId = ''}) {
    return YoutubePlayerController(
      initialVideoId:
          videoId != '' ? videoId : currentPlayinglist.keys.toList()[index],
      flags: YoutubePlayerFlags(
        hideControls: true,
        autoPlay: autoPlay,
        mute: isMute,
        loop: false,
        isLive: false,
        forceHD: isHD,
        enableCaption: false,
      ),
    );
  }

  void setStreamingInfo() {
    //building stream
    _positionStreamController = StreamController<Duration>();
    _positionStream = _positionStreamController.stream;

    _durationStreamController = StreamController<Duration>();
    _durationStream = _durationStreamController.stream;

    _playerStateStreamController = StreamController<PlayerState>();
    _playerStateStream = _playerStateStreamController.stream;

    // Start emitting position and duration updates
    Timer.periodic(
      const Duration(seconds: 1),
      _emitPosition,
    );

    Timer.periodic(
      const Duration(seconds: 1),
      _emitDuration,
    );

    Timer.periodic(
      const Duration(seconds: 1),
      _emitPlayerState,
    );
    broadcastStream = _seekBarDataStream.asBroadcastStream();
    playerStateStreamBroadcast = _playerStateStream.asBroadcastStream();
  }

  void _emitPosition(Timer timer) {
    _positionStreamController.add(youtubePlayerController.value.position);
  }

  void _emitDuration(Timer timer) {
    _durationStreamController.add(youtubePlayerController.metadata.duration);
  }

  void _emitPlayerState(Timer timer) {
    _playerStateStreamController.add(youtubePlayerController.value.playerState);
  }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          _positionStream, _durationStream, (
        Duration position,
        Duration? duration,
      ) {
        return SeekBarData(
          position,
          duration ?? Duration.zero,
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, _) {
          final _selectedVideo = watch(selectedVideoProvider).state;
          final _selectedPlaylist = watch(selectedPlaylistProvider).state;
          final _miniPlayerController =
              watch(miniPlayerControllerProvider).state;

          final _selectedSearchProvider = watch(selectedSearchProvider).state;
          final _onStageSearch =
              _selectedSearchProvider?.search_query == '' ? false : true;
          final _searchProvider = watch(searchProvider).state;

          final _moreOptionSelectedVideoProvider =
              watch(moreOptionProvider).state;
          final _addPlaylistProvider = watch(addPlaylistProvider).state;

          // print(_selectedSearchProvider?.search_query ?? 'none');
          // print(savedSearchList?.length);

          // print('${_selectedVideo}, ${_selectedSearchProvider}');

          if (_selectedVideo != null) {
            _isVideoSelected = true;
            if (prevVideo != _selectedVideo || prevVideo == null) {
              _streamOnce = false;
              if (_isPlayerReady) {
                youtubePlayerController.load(_selectedVideo.id!);
              }
            }
            prevVideo = _selectedVideo;
          }

          if (_selectedPlaylist != null) {
            _isPlaylistSelected = true;
            _streamOnce = false;
          } else {
            _isPlaylistSelected = false;
          }

          return Stack(
            children: _screens
                .asMap()
                .map((i, screen) => MapEntry(
                      i,
                      Offstage(
                        offstage: _selectedIndex != i,
                        child: screen,
                      ),
                    ))
                .values
                .toList()
              ..add(
                Offstage(
                  offstage: _selectedVideo == null,
                  child: Consumer(
                    builder: (context, watch, child) {
                      try {
                        if (_isVideoSelected || _isPlaylistSelected) {
                          setStreamingInfo();
                          return Container(
                            height: 0,
                            width: 0,
                            child: YoutubePlayer(
                              controller: youtubePlayerController,
                              onReady: () {
                                _isPlayerReady = true;

                                currentPlayinglist.clear();
                                currentPlayinglist[_selectedVideo!.id!] =
                                    _selectedVideo;

                                var keylist = currentPlayinglist.keys.toList();

                                youtubePlayerController.load(keylist.first);
                              },
                              onEnded: (metaData) {
                                _isPlayerReady = false;
                              },
                            ),
                          );
                        }
                      } catch (e) {}

                      return Container();
                    },
                  ),
                ),
              )
              ..add(
                Offstage(
                  offstage: _selectedPlaylist == null,
                  child: PlaylistItemsScreen(),
                ),
              )
              ..add(
                Offstage(
                  offstage: _selectedSearchProvider == null,
                  child: Builder(
                    builder: (context) {
                      if (_selectedSearchProvider != null &&
                          _selectedSearchProvider.search_query! != '') {
                        return SearchResultScreen(
                          search_query: _selectedSearchProvider.search_query!,
                          // rebuild_screen: _onStageSearch,
                        );
                      }

                      return Container();
                    },
                  ),
                ),
              )
              ..add(
                Offstage(
                  offstage: _selectedVideo == null,
                  child: Miniplayer(
                    controller: _miniPlayerController,
                    minHeight: _playerMinHeight,
                    maxHeight: MediaQuery.of(context).size.height,
                    builder: (height, percentage) {
                      if (_selectedVideo == null) {
                        prevVideo = null;
                        _isVideoSelected = false;
                        _streamOnce = false;
                        return const SizedBox.shrink();
                      }

                      if (height <= _playerMinHeight + 50.0) {
                        Future.delayed(Duration(milliseconds: 10), () {
                          context.read(miniplayerHeightProvider).state = true;
                        });
                      } else {
                        Future.delayed(Duration(milliseconds: 10), () {
                          context.read(miniplayerHeightProvider).state = false;
                        });
                      }

                      return VideoScreen(
                        videoThumbnail: _selectedVideo.thumbnail!,
                        playerMinHeight: _playerMinHeight,
                        playerCurrHeight: height,
                      );
                    },
                  ),
                ),
              )
              ..add(
                Offstage(
                  offstage: _searchProvider.isEmpty,
                  child: SearchScreen(),
                ),
              )
              ..add(
                Offstage(
                  offstage: _moreOptionSelectedVideoProvider == null,
                  child: Builder(
                    builder: (context) {
                      if (_moreOptionSelectedVideoProvider == null) {
                        return Container();
                      }

                      return MoreOptionScreen(
                          video: _moreOptionSelectedVideoProvider);
                    },
                  ),
                ),
              )
              ..add(
                Offstage(
                  offstage: _addPlaylistProvider == false,
                  child: Builder(
                    builder: (context) {
                      if (_addPlaylistProvider == false) {
                        return Container();
                      }

                      return AddPlaylistScreen(playlistName: '');
                    },
                  ),
                ),
              ),
          );

          // return Stack(
          //   children: _screens
          //       .asMap()
          //       .map((i, screen) => MapEntry(
          //             i,
          //             Offstage(
          //               offstage: _selectedIndex != i,
          //               child: screen,
          //             ),
          //           ))
          //       .values
          //       .toList()
          //     ..add(
          //       Offstage(
          //         offstage: selectedVideo == null,
          //         child: Consumer(
          //           builder: (context, watch, child) {
          //             try {
          //               if (videoSelected) {
          //                 if (!streamOnce) {
          //                   streamOnce = true;
          //                   setStreamingInfo();
          //                   return Container(
          //                     height: 0,
          //                     width: 0,
          //                     child: youtubePlayer,
          //                   );
          //                 }
          //               }
          //             } catch (e) {}

          //             return Container();
          //           },
          //         ),
          //       ),
          //     )
          //     ..add(
          //       Offstage(
          //         offstage: selectedPlaylist == null,
          //         child: PlaylistScreen(),
          //       ),
          //     )
          //     ..add(
          //       Offstage(
          //         offstage: selectedVideo == null,
          //         child: Miniplayer(
          //           controller: miniPlayerController,
          //           minHeight: _playerMinHeight,
          //           maxHeight: MediaQuery.of(context).size.height,
          //           builder: (height, percentage) {
          //             if (selectedVideo == null) {
          //               prevVideo = null;
          //               videoSelected = false;
          //               streamOnce = false;
          //               return const SizedBox.shrink();
          //             }

          //             if (height <= _playerMinHeight + 50.0) {
          //               videoSelected = true;

          //               return Container(
          //                 color: Theme.of(context).scaffoldBackgroundColor,
          //                 child: Column(
          //                   children: [
          //                     Row(
          //                       children: [
          //                         SizedBox(
          //                           height: _playerMinHeight - 4.0,
          //                           width: 120.0,
          //                           child:
          //                               Image.network(selectedVideo.thumbnail!),
          //                           // child: youtubePlayer,
          //                         ),
          //                         Expanded(
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(8.0),
          //                             child: Column(
          //                               crossAxisAlignment:
          //                                   CrossAxisAlignment.start,
          //                               mainAxisSize: MainAxisSize.min,
          //                               children: [
          //                                 Flexible(
          //                                   child: Text(
          //                                     selectedVideo.title!,
          //                                     overflow: TextOverflow.ellipsis,
          //                                     style: Theme.of(context)
          //                                         .textTheme
          //                                         .caption!
          //                                         .copyWith(
          //                                           color: Colors.white,
          //                                           fontWeight: FontWeight.w500,
          //                                         ),
          //                                   ),
          //                                 ),
          //                                 Flexible(
          //                                   child: Text(
          //                                     selectedVideo.channel!.alias!,
          //                                     overflow: TextOverflow.ellipsis,
          //                                     style: Theme.of(context)
          //                                         .textTheme
          //                                         .caption!
          //                                         .copyWith(
          //                                             fontWeight:
          //                                                 FontWeight.w500),
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                         StreamBuilder<PlayerState>(
          //                           stream: playerStateStreamBroadcast,
          //                           builder: (context, snapshot) {
          //                             if (snapshot.hasData) {
          //                               final playerState = snapshot.data;
          //                               final processingState = playerState!;

          //                               if (processingState ==
          //                                       PlayerState.unStarted ||
          //                                   processingState ==
          //                                       PlayerState.buffering) {
          //                                 return Container(
          //                                   width: 15,
          //                                   height: 15,
          //                                   margin: const EdgeInsets.all(10),
          //                                   child:
          //                                       const CircularProgressIndicator(),
          //                                 );
          //                               } else if (processingState !=
          //                                   PlayerState.playing) {
          //                                 return IconButton(
          //                                   onPressed:
          //                                       youtubePlayerController.play,
          //                                   icon: const Icon(
          //                                     Icons.play_arrow,
          //                                   ),
          //                                 );
          //                               } else if (processingState !=
          //                                   PlayerState.ended) {
          //                                 return IconButton(
          //                                   onPressed:
          //                                       youtubePlayerController.pause,
          //                                   icon: const Icon(
          //                                     Icons.pause,
          //                                   ),
          //                                 );
          //                               } else {
          //                                 return IconButton(
          //                                   onPressed: () =>
          //                                       youtubePlayerController
          //                                           .seekTo(Duration.zero),
          //                                   icon: const Icon(
          //                                     Icons.replay,
          //                                   ),
          //                                 );
          //                               }
          //                             } else {
          //                               return const CircularProgressIndicator();
          //                             }
          //                           },
          //                         ),
          //                         // IconButton(
          //                         //   icon: const Icon(Icons.play_arrow),
          //                         //   onPressed: () {},
          //                         // ),
          //                         IconButton(
          //                           icon: const Icon(Icons.close),
          //                           onPressed: () {
          //                             context
          //                                 .read(selectedVideoProvider)
          //                                 .state = null;
          //                           },
          //                         ),
          //                       ],
          //                     ),
          //                     Expanded(
          //                       child: StreamBuilder<SeekBarData>(
          //                         stream: broadcastStream,
          //                         builder: (context, snapshot) {
          //                           // final positionData = snapshot.data;
          //                           return SeekBarMin(
          //                             position: snapshot.data?.position ??
          //                                 Duration.zero,
          //                             duration: snapshot.data?.duration ??
          //                                 Duration.zero,
          //                           );
          //                         },
          //                       ),
          //                     ),
          //                     // const LinearProgressIndicator(
          //                     //   value: 0.4,
          //                     //   valueColor: AlwaysStoppedAnimation<Color>(
          //                     //     Colors.red,
          //                     //   ),
          //                     // ),
          //                   ],
          //                 ),
          //               );
          //             }

          //             var videoPlayerController =
          //                 setVideoController(selectedVideo.id!, true, false);

          //             return VideoScreen(
          //               seekBarDataStream: broadcastStream,
          //               videoPlayerController: videoPlayerController,
          //               videoThumbnail: selectedVideo.thumbnail!,
          //             );
          //           },

          //           // return YoutubePlayerControllerProvider(
          //           //   controller: youtubePlayerController,
          //           //   child: Builder(
          //           //     builder: (context) {
          //           //       // Access the controller as:
          //           //       // `YoutubePlayerControllerProvider.of(context)`
          //           //       // or `controller.ytController`.

          //           //       if (!playerInit) {
          //           //         print("here");

          //           //         youtubePlayer = YoutubePlayer(
          //           //             controller: context.ytController);

          //           //         playerInit = true;
          //           //       }

          //           //       // print("Here" + youtubePlayer!.toString());

          //           //       if (selectedVideo == null) {
          //           //         return const SizedBox.shrink();
          //           //       }

          //           //       // return youtubePlayer;

          //           //       if (height <= _playerMinHeight + 50.0) {
          //           //         return Container(
          //           //           color:
          //           //               Theme.of(context).scaffoldBackgroundColor,
          //           //           child: Column(
          //           //             children: [
          //           //               Row(
          //           //                 children: [
          //           //                   SizedBox(
          //           //                       height: _playerMinHeight - 4.0,
          //           //                       width: 120.0,
          //           //                       child: youtubePlayer),
          //           //                   Expanded(
          //           //                     child: Padding(
          //           //                       padding: const EdgeInsets.all(8.0),
          //           //                       child: Column(
          //           //                         crossAxisAlignment:
          //           //                             CrossAxisAlignment.start,
          //           //                         mainAxisSize: MainAxisSize.min,
          //           //                         children: [
          //           //                           Flexible(
          //           //                             child: Text(
          //           //                               selectedVideo.title,
          //           //                               overflow:
          //           //                                   TextOverflow.ellipsis,
          //           //                               style: Theme.of(context)
          //           //                                   .textTheme
          //           //                                   .caption!
          //           //                                   .copyWith(
          //           //                                     color: Colors.white,
          //           //                                     fontWeight:
          //           //                                         FontWeight.w500,
          //           //                                   ),
          //           //                             ),
          //           //                           ),
          //           //                           Flexible(
          //           //                             child: Text(
          //           //                               selectedVideo.author,
          //           //                               overflow:
          //           //                                   TextOverflow.ellipsis,
          //           //                               style: Theme.of(context)
          //           //                                   .textTheme
          //           //                                   .caption!
          //           //                                   .copyWith(
          //           //                                       fontWeight:
          //           //                                           FontWeight
          //           //                                               .w500),
          //           //                             ),
          //           //                           ),
          //           //                         ],
          //           //                       ),
          //           //                     ),
          //           //                   ),
          //           //                   IconButton(
          //           //                     icon: const Icon(Icons.play_arrow),
          //           //                     onPressed: () {},
          //           //                   ),
          //           //                   IconButton(
          //           //                     icon: const Icon(Icons.close),
          //           //                     onPressed: () {
          //           //                       context
          //           //                           .read(selectedVideoProvider)
          //           //                           .state = null;
          //           //                     },
          //           //                   ),
          //           //                 ],
          //           //               ),
          //           //               const LinearProgressIndicator(
          //           //                 value: 0.4,
          //           //                 valueColor: AlwaysStoppedAnimation<Color>(
          //           //                   Colors.red,
          //           //                 ),
          //           //               ),
          //           //             ],
          //           //           ),
          //           //         );
          //           //       }

          //           //       return VideoScreen(
          //           //         youtubePlayer: youtubePlayer!,
          //           //         height: MediaQuery.of(context).size.height,
          //           //         playerMinHeight: _playerMinHeight,
          //           //         percentage: 1.0,
          //           //       );
          //           //     },
          //           //   ),
          //           // );
          //           // },
          //         ),
          //       ),
          //     ),
          // );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Search',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.add_circle_outline),
          //   activeIcon: Icon(Icons.add_circle),
          //   label: 'Add',
          // ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.subscriptions_outlined),
          //   activeIcon: Icon(Icons.subscriptions),
          //   label: 'Subscriptions',
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined),
            activeIcon: Icon(Icons.video_library),
            label: 'Library',
          ),
        ],
      ),
    );
  }
}
