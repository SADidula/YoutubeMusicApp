import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempo_fy/screens/nav_screen.dart';

class CustomReturnAppBar extends StatelessWidget {
  const CustomReturnAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      // floating: true,
      pinned: true,
      leadingWidth: 10.0,
      flexibleSpace: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25.0, left: 12.0),
            child: Consumer(
              builder: (context, watch, child) {
                return IconButton(
                    iconSize: 35.0,
                    icon: const Icon(Icons.keyboard_arrow_left),
                    onPressed: () {
                      context.read(selectedPlaylistProvider).state = null;
                      context.read(searchProvider).state = List.empty();
                      context.read(selectedSearchProvider).state = null;
                    });
              },
            ),
          ),
        ],
      ),
      // leading:
    );
  }
}
