import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:tempo_fy/main.dart';
import 'package:tempo_fy/models/search.dart';
import 'package:tempo_fy/widgets/silver_widgets/custom_sliver_app_bar_search_screen.dart';
import 'package:tempo_fy/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverPadding(
            padding: EdgeInsets.only(top: 30.0, bottom: 20.0),
            sliver: CustomSliverAppBarSearchScreen(),
          ),
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
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 10, bottom: 0),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Search",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Consumer(builder: (context, watch, child) {
              if (savedSearchList.isEmpty) return Container();

              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: savedSearchList.length,
                itemBuilder: (context, i) {
                  final searchQuery = savedSearchList[savedSearchList.length - 1 - i];
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
                            SearchCard(searchQuery: searchQuery),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
