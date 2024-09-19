import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempo_fy/callbacks/local_storage.dart';
import 'package:tempo_fy/main.dart';
import 'package:tempo_fy/models/search.dart';
import 'package:tempo_fy/screens/nav_screen.dart';

class CustomSliverAppBarSearchScreen extends StatelessWidget {
  const CustomSliverAppBarSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      floating: true,
      leadingWidth: 10.0,
      flexibleSpace: Padding(
        padding: EdgeInsets.only(top: 30.0, left: 12.0, right: 12.0),
        child: Row(
          children: [
            // Consumer(
            //   builder: (context, watch, child) {
            //     return IconButton(
            //         iconSize: 45.0,
            //         icon: const Icon(Icons.keyboard_arrow_left),
            //         onPressed: () {
            //           context.read(selectedPlaylistProvider).state = null;
            //           context.read(searchProvider).state = List.empty();
            //         });
            //   },
            // ),
            _DiscoverMusic(),
          ],
        ),
      ),
      // leading:
    );
  }
}

class _DiscoverMusic extends StatelessWidget {
  const _DiscoverMusic({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController searchController = TextEditingController();

    return Expanded(
      child: TextFormField(
        controller: searchController,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          hintText: 'Search',
          hintStyle: Theme.of(context).textTheme.bodyMedium!,
          prefixIcon: const Icon(
            Icons.search,
            // color: Colors.black54,
          ),
          // contentPadding: const EdgeInsets.symmetric(vertical: 2),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.0),
              borderSide: BorderSide.none),
        ),
        onFieldSubmitted: (value) {
          var newSearch = Search(search_query: value, thumbnail: '');

          savedSearchList.add(value);
          //saving the searches to the shared preference
          LocalStorage.setSearchList('search', savedSearchList);

          context.read(selectedSearchProvider).state = newSearch;
          context.read(searchProvider).state = List.empty();
        },
      ),
    );
  }
}
