import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tempo_fy/main.dart';
import 'package:tempo_fy/widgets/playlist_section_home_card.dart';
import 'package:tempo_fy/widgets/widgets.dart';

import '../models/video.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    // set the screen after a certain seconds
    // Future.delayed(const Duration(milliseconds: 10), () {
    //   setState(() {});
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBarHomeScreen(),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 60.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
                    children: [
                      PlaylistSectionHomeWidget(
                          sectionHeader: "Your Playlists",
                          userPlaylists: userPlaylists),
                      _SongSectionWidget(
                        sectionHeader: "Popular Hits",
                        songList: popularHits,
                      ),
                      // _SongSectionWidget(
                      //   sectionHeader: "Suggested",
                      //   songList: suggestSongs,
                      // ),
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

class _SongSectionWidget extends StatelessWidget {
  const _SongSectionWidget(
      {Key? key, required this.sectionHeader, required this.songList});

  final String sectionHeader;
  final List<Video> songList;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  sectionHeader,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 265.0,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: songList.length,
                itemBuilder: (context, i) {
                  final video = songList[i];
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, right: 8.0, bottom: 8.0),
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            VideoCard(
                              video: video,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
