import 'package:flutter/material.dart';
import 'package:tempo_fy/main.dart';
import 'package:tempo_fy/widgets/playlist_section_library_card.dart';
import 'package:tempo_fy/widgets/widgets.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  @override
  void initState() {
    super.initState();

    // set the screen after a certain seconds
    Future.delayed(const Duration(milliseconds: 2), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppBarLibraryScreen(),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 60.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Column(
                    children: [
                      PlaylistSectionLibraryWidget(
                        sectionHeader: "Your Library",
                        userPlaylists: userPlaylists,
                      ),
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
