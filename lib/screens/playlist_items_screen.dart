import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:tempo_fy/main.dart';
import 'package:tempo_fy/models/playlist.dart';
import 'package:tempo_fy/models/video.dart';
import 'package:tempo_fy/screens/nav_screen.dart';
import 'package:tempo_fy/widgets/widgets.dart';

late Map<String, Video> playVideoList;

Map<String, Video> createPlaylist(Playlist playlist) {
  Map<String, Video> list = {};
  for (var video in playlist.videos!.reversed) {
    list[video.id!] = video;
  }
  return list;
}

class PlaylistItemsScreen extends StatefulWidget {
  @override
  State<PlaylistItemsScreen> createState() => _PlaylistItemsScreenState();
}

class _PlaylistItemsScreenState extends State<PlaylistItemsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomReturnAppBar(),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 60.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return const Column(
                    children: [
                      _HeaderSectionWidget(),
                    ],
                  );
                },
                childCount: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSectionWidget extends StatelessWidget {
  const _HeaderSectionWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final playlist = watch(selectedPlaylistProvider).state;
        return Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, bottom: 0),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      playlist?.title ?? '',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    GestureDetector(
                      child: const Icon(
                        Icons.play_circle,
                        size: 45,
                      ),
                      onTap: () {
                        if (playlist != null) {
                          playVideoList = createPlaylist(playlist);
                        }

                        currentPlayinglist.clear();
                        currentPlayinglist.addAll(playVideoList);
                        youtubePlayerController
                            .load(currentPlayinglist.keys.toList().first);

                        context.read(selectedVideoProvider).state =
                            playVideoList[
                                currentPlayinglist.keys.toList().first];
                      },
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      child: const Icon(
                        Icons.shuffle,
                        size: 35,
                      ),
                      onTap: () {
                        if (playlist != null) {
                          playVideoList = createPlaylist(playlist);
                        }

                        List<String> shuffleList = [];
                        shuffleList.addAll(playVideoList.keys);
                        shuffleList.shuffle();

                        currentPlayinglist.clear();
                        for (String videoId in shuffleList) {
                          currentPlayinglist[videoId] = playVideoList[videoId]!;
                        }

                        youtubePlayerController
                            .load(currentPlayinglist.keys.toList().first);

                        context.read(selectedVideoProvider).state =
                            playVideoList[
                                currentPlayinglist.keys.toList().first];
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: (playlist == null ? 0 : playlist.videos!.length * 80),
                child: playlist == null
                    ? Container()
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: playlist.videos?.length,
                        itemBuilder: (context, i) {
                          final videoList =
                              playlist.videos?[playlist.videos!.length - 1 - i];
                          return InkWell(
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    VideoCardPlaylist(video: videoList!),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height +
              //       (playlist!.videos!.length * 40),
              //   child: Consumer(builder: (context, watch, child) {
              //     final playlist = watch(selectedPlaylistProvider).state;

              //     if (playlist == null) return Container();

              //     return ListView.builder(
              //       physics: const NeverScrollableScrollPhysics(),
              //       scrollDirection: Axis.vertical,
              //       itemCount: playlist.videos?.length,
              //       itemBuilder: (context, i) {
              //         final videoList = playlist.videos?[i];
              //         return InkWell(
              //           onTap: () {},
              //           child: Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: SizedBox(
              //               width: 300,
              //               child: Column(
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   VideoCardPlaylist(video: videoList!),
              //                 ],
              //               ),
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   }),
              // ),
            ],
          ),
        );
      },
    );
  }
}
