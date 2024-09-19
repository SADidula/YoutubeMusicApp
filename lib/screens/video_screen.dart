import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempo_fy/main.dart';
import 'package:tempo_fy/models/seek_bar.dart';
import 'package:tempo_fy/screens/nav_screen.dart';
import 'package:tempo_fy/screens/playlist_items_screen.dart';
import 'package:tempo_fy/widgets/widgets.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/video.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({
    super.key,
    required this.videoThumbnail,
    required this.playerMinHeight,
    required this.playerCurrHeight,
  });

  final String videoThumbnail;
  final double playerMinHeight;
  final double playerCurrHeight;

  @override
  _VideoScreenState createState() =>
      _VideoScreenState(videoThumbnail, playerMinHeight, playerCurrHeight);
}

class _VideoScreenState extends State<VideoScreen> {
  ScrollController? _scrollController;
  late String videoThumbnail;
  late double playerMinHeight;
  late double playerCurrHeight;

  _VideoScreenState(
      this.videoThumbnail, this.playerMinHeight, this.playerCurrHeight);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context
          .read(miniPlayerControllerProvider)
          .state
          .animateToHeight(state: PanelState.MAX),
      child: Consumer(
        builder: (context, watch, _) {
          var selectedVideo = watch(selectedVideoProvider).state!;
          var isMiniplayer = watch(miniplayerHeightProvider).state!;

          return SingleChildScrollView(
            physics: isMiniplayer
                ? const NeverScrollableScrollPhysics()
                : const ClampingScrollPhysics(),
            child: Container(
              color: Colors.transparent,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                children: <Widget>[
                  Offstage(
                    offstage: isMiniplayer == true,
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.83,
                          child: SizedBox.expand(
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: youtubePlayer = YoutubePlayer(
                                  controller: youtubePlayerController,
                                  onReady: () {
                                    youtubePlayerController.pause();

                                    currentPlayinglist.clear();
                                    currentPlayinglist[selectedVideo.id!] =
                                        selectedVideo;

                                    var keylist =
                                        currentPlayinglist.keys.toList();

                                    youtubePlayerController.load(keylist.first);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color.fromARGB(255, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                        ),
                      ),
                      height: 120),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                      child: Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 80),
                            const Stack(
                              children: [
                                SizedBox(
                                  height: 200,
                                ),
                              ],
                            ),
                            const SizedBox(height: 70),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: VideoInfo(video: selectedVideo),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: StreamBuilder<SeekBarData>(
                                stream: broadcastStream,
                                builder: (context, snapshot) {
                                  return SeekBar(
                                    position: snapshot.data?.position ??
                                        Duration.zero,
                                    duration: snapshot.data?.duration ??
                                        Duration.zero,
                                    onChanged: youtubePlayerController.seekTo,
                                  );
                                },
                              ),
                            ),
                            _PlayButtonBar(
                              video: selectedVideo,
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: Divider(
                                thickness: 3,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            _ActionsRow(video: selectedVideo),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20.0,
                    left: 10.0,
                    child: IconButton(
                      iconSize: 40.0,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                      ),
                      onPressed: () => context
                          .read(miniPlayerControllerProvider)
                          .state
                          .animateToHeight(state: PanelState.MIN),
                    ),
                  ),
                  _MiniPlayerPopup(isMiniplayer, context, selectedVideo),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Offstage _MiniPlayerPopup(
      bool isMiniplayer, BuildContext context, Video selectedVideo) {
    return Offstage(
      offstage: isMiniplayer == false,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: Container(
            height: MediaQuery.of(context).size.height / 11,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).highlightColor,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: playerMinHeight - 4.0,
                      width: 120.0,
                      child: Transform.scale(
                        scale: 1.1,
                        child: Image.network(
                          selectedVideo.thumbnail!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: Text(
                                selectedVideo.title!,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                selectedVideo.channel!.alias ??
                                    selectedVideo.channel!.title!,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.read(selectedVideoProvider).state = null;
                      },
                      icon: const Icon(Icons.phone_iphone),
                    ),
                    StreamBuilder<PlayerState>(
                      stream: playerStateStreamBroadcast,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final playerState = snapshot.data;
                          final processingState = playerState!;

                          if (processingState == PlayerState.unStarted ||
                              processingState == PlayerState.buffering) {
                            hasEnded = false;

                            return Container(
                              width: 15,
                              height: 15,
                              margin: const EdgeInsets.all(10),
                              child: const CircularProgressIndicator(),
                            );
                          } else if (processingState != PlayerState.playing) {
                            if (processingState == PlayerState.ended &&
                                !hasEnded) {
                              hasEnded = true;

                              Future.delayed(Duration(milliseconds: 10), () {
                                var keylist = currentPlayinglist.keys.toList();
                                var index = keylist.indexOf(selectedVideo.id!);

                                if (keylist.indexOf(selectedVideo.id!) <=
                                    keylist.length - 1) {
                                  youtubePlayerController
                                      .load(keylist[index + 1]);
                                  context.read(selectedVideoProvider).state =
                                      playVideoList[keylist[index + 1]];
                                }
                              });
                            }

                            return IconButton(
                              onPressed: youtubePlayerController.play,
                              icon: const Icon(
                                Icons.play_arrow,
                              ),
                            );
                          } else if (processingState != PlayerState.ended) {
                            return IconButton(
                              onPressed: youtubePlayerController.pause,
                              icon: const Icon(
                                Icons.pause,
                              ),
                            );
                          } else {
                            return IconButton(
                              onPressed: () =>
                                  youtubePlayerController.seekTo(Duration.zero),
                              icon: const Icon(
                                Icons.replay,
                              ),
                            );
                          }
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ],
                ),
                StreamBuilder<SeekBarData>(
                  stream: broadcastStream,
                  builder: (context, snapshot) {
                    return SeekBarMin(
                      position: snapshot.data?.position ?? Duration.zero,
                      duration: snapshot.data?.duration ?? Duration.zero,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionsRow extends StatefulWidget {
  final Video video;

  const _ActionsRow({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  State<_ActionsRow> createState() => _ActionsRowState();
}

class _ActionsRowState extends State<_ActionsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // _buildAction(context, Icons.thumb_up_outlined, video.likes),
        // _buildAction(context, Icons.thumb_down_outlined, video.dislikes),
        // _buildAction(context, Icons.library_add_outlined, 'Save'),

        GestureDetector(
          onTap: () async {
            //if favorite then remove
            if (favoriteMusic.contains(widget.video.id) &&
                favoritePlaylist.videos!.contains(widget.video)) {
              //remove from the temp favorite list
              favoriteMusic.remove(widget.video.id);
              //remove from favorite playlist
              favoritePlaylist.videos!.remove(widget.video);

              searchRepo.deletePlaylistItems(widget.video);

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Removed from favorites'),
              ));
            } else {
              //add to the temp favorite list
              favoriteMusic.add(widget.video.id!);
              //add to the favorite playlist
              favoritePlaylist.videos!.add(widget.video);

              searchRepo.insertPlaylistItems(favoritePlaylist, widget.video);

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Added to favorites'),
              ));
            }

            setState(() {});
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                favoriteMusic.contains(widget.video.id!)
                    ? Icons.favorite
                    : Icons.favorite_border,
                size: 35.0,
              ),
              const SizedBox(height: 6.0),
              Text(
                'Add to Favorite',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {},
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.playlist_add,
                size: 35.0,
              ),
              const SizedBox(height: 6.0),
              Text(
                'Add to Playlist',
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PlayButtonBar extends StatefulWidget {
  const _PlayButtonBar({
    super.key,
    required this.video,
  });

  final Video video;

  @override
  State<_PlayButtonBar> createState() => _PlayButtonBarState();
}

class _PlayButtonBarState extends State<_PlayButtonBar> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          // onPressed: audioPlayer.hasPrevious
          //     ? audioPlayer.seekToPrevious
          //     : null,
          onPressed: () {
            var keylist = currentPlayinglist.keys.toList();
            var index = keylist.indexOf(widget.video.id!);
            if (keylist.indexOf(widget.video.id!) <= 0) return;

            // context.read(selectedVideoProvider).state =
            //     playVideoList[keylist.first];

            // widget.videoPlayerCtrl.load(keylist[index - 1]);
            youtubePlayerController.load(keylist[index - 1]);

            context.read(selectedVideoProvider).state =
                playVideoList[keylist[index - 1]];
          },
          iconSize: 45,
          icon: const Icon(
            Icons.skip_previous,
            color: Colors.white,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: playerStateStreamBroadcast,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final playerState = snapshot.data;
              final processingState = playerState!;

              if (processingState == PlayerState.unStarted ||
                  processingState == PlayerState.buffering) {
                hasEnded = false;

                return Container(
                  width: 70,
                  height: 70,
                  margin: const EdgeInsets.all(10),
                  child: const CircularProgressIndicator(),
                );
              } else if (processingState != PlayerState.playing) {
                if (processingState == PlayerState.ended && !hasEnded) {
                  hasEnded = true;

                  Future.delayed(Duration(milliseconds: 10), () {
                    setState(() {
                      var keylist = currentPlayinglist.keys.toList();
                      var index = keylist.indexOf(widget.video.id!);
                      if (keylist.indexOf(widget.video.id!) <=
                          keylist.length - 1) {
                        updatePlaylist(context, keylist[index + 1]);
                      }
                    });
                  });
                }

                return IconButton(
                  onPressed: () {
                    youtubePlayerController.play();
                  },
                  iconSize: 75,
                  icon: const Icon(
                    Icons.play_circle,
                    color: Colors.white,
                  ),
                );
              } else if (processingState != PlayerState.ended) {
                return IconButton(
                  onPressed: () {
                    youtubePlayerController.pause();
                  },
                  iconSize: 75,
                  icon: const Icon(
                    Icons.pause_circle,
                    color: Colors.white,
                  ),
                );
              } else {
                return IconButton(
                  onPressed: () {
                    youtubePlayerController.seekTo(Duration.zero);
                  },
                  iconSize: 75,
                  icon: const Icon(
                    Icons.replay_circle_filled_outlined,
                    color: Colors.white,
                  ),
                );
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
        IconButton(
          // onPressed: audioPlayer.hasNext
          //     ? audioPlayer.seekToNext
          //     : null,
          onPressed: () {
            setState(() {
              var keylist = currentPlayinglist.keys.toList();
              var index = keylist.indexOf(widget.video.id!);
              if (keylist.indexOf(widget.video.id!) <= keylist.length - 1) {
                updatePlaylist(context, keylist[index + 1]);

                // widget.videoPlayerCtrl.load(keylist[index + 1]);
                // youtubePlayerController.load(keylist[index + 1]);
                // context.read(selectedVideoProvider).state =
                //     playVideoList[keylist[index + 1]];
              }
            });
          },
          iconSize: 45,
          icon: const Icon(
            Icons.skip_next,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

void updatePlaylist(BuildContext context, String videoId) {
  youtubePlayerController.load(videoId);
  context.read(selectedVideoProvider).state = playVideoList[videoId];
}
