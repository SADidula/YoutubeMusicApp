import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:tempo_fy/callbacks/get_youtube_apis.dart';
import 'package:tempo_fy/widgets/playlist_widgets/playlist_home_card.dart';
import 'package:tempo_fy/widgets/widgets.dart';

import '../models/video.dart';
import '../models/playlist.dart';

class SearchResultScreen extends StatefulWidget {
  final String search_query;

  const SearchResultScreen({
    super.key,
    required this.search_query,
  });

  @override
  State<SearchResultScreen> createState() =>
      _SearchResultScreenState(search_query);
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late List<Video> searchResults;
  final searchRepo = SearchRepository();
  late String searchQuery;

  _SearchResultScreenState(this.searchQuery);

  @override
  void initState() {
    super.initState();
    searchResults = List.empty(growable: true);
    AsynLoadSearchReults();
  }

  Future<void> AsynLoadSearchReults() async {
    var videosInfo = await searchRepo.getSearchResults(searchQuery, 20);

    for (var id in videosInfo) {
      searchResults.add(await searchRepo.getVideoInfo(id));
      if (this.mounted) {
        setState(() {});
      }
    }
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
                  return Column(
                    children: [
                      _SearchResultsSectionWidget(
                          sectionHeader: "Search Results",
                          searchResults: searchResults),
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

class _SearchResultsSectionWidget extends StatelessWidget {
  const _SearchResultsSectionWidget({
    super.key,
    required this.sectionHeader,
    required this.searchResults,
  });

  final List<Video> searchResults;
  final String sectionHeader;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 0, right: 20),
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
            height: searchResults.length * 260,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: searchResults.length,
                itemBuilder: (context, i) {
                  final video = searchResults[i];
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
                      padding: const EdgeInsets.all(8.0),
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
