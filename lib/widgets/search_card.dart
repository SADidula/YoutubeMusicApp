import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:tempo_fy/models/search.dart';
import 'package:tempo_fy/screens/nav_screen.dart';
import 'package:miniplayer/miniplayer.dart';

import '../models/video.dart';

class SearchCard extends StatelessWidget {
  final String searchQuery;
  final bool hasPadding;
  final VoidCallback? onTap;

  const SearchCard({
    super.key,
    required this.searchQuery,
    this.hasPadding = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read(searchProvider).state = List.empty();
        context.read(selectedSearchProvider).state = Search(search_query: searchQuery, thumbnail: '');
        if (onTap != null) onTap!();
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(
              Icons.switch_access_shortcut,
            ),
            const SizedBox(width: 30),
            SizedBox(
              width: 260,
              child: Text(
                searchQuery,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge!,
              ),
            ),
            // const Spacer(),
            // Image.network(
            //   searchQuery.thumbnail!,
            // ),
            // const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }
}
