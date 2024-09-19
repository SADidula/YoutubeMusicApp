import 'package:flutter/material.dart';
import 'package:tempo_fy/models/playlist.dart';
import 'package:tempo_fy/widgets/playlist_widgets/playlist_home_card.dart';

class PlaylistSectionHomeWidget extends StatelessWidget {
  const PlaylistSectionHomeWidget({
    super.key,
    required this.sectionHeader,
    required this.userPlaylists,
  });

  final List<Playlist> userPlaylists;
  final String sectionHeader;

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
            height: userPlaylists.length * 115,
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: userPlaylists.length,
                itemBuilder: (context, i) {
                  final playlist = userPlaylists[i];
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.only(left: 2.0, top: 8.0, right: 8.0, bottom: 8.0),
                      child: SizedBox(
                        width: 300,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PlaylistHomeCard(
                              playlist: playlist,
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
