import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempo_fy/models/playlist.dart';
import 'package:tempo_fy/screens/nav_screen.dart';

class PlaylistHomeCard extends StatelessWidget {
  final Playlist playlist;
  final bool hasPadding;
  final VoidCallback? onTap;

  const PlaylistHomeCard({
    Key? key,
    required this.playlist,
    this.hasPadding = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read(selectedPlaylistProvider).state = playlist;
        context.read(miniPlayerControllerProvider).state;
        if (onTap != null) onTap!();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: SizedBox(
              height: 90.0,
              width: MediaQuery.of(context).size.width - 50,
              child: DecoratedBox(
                decoration:
                    const BoxDecoration(color: Color.fromARGB(57, 0, 0, 0)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.network(
                        height: MediaQuery.of(context).size.height,
                        playlist.thumbnail!,
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Text(
                      playlist.title!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontSize: 15.0, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: const Icon(Icons.more_vert, size: 20.0),
                    // ),
                    // const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () {
  //       context.read(selectedPlaylistProvider).state = playlist;
  //       context
  //           .read(miniPlayerControllerProvider)
  //           .state
  //           .animateToHeight(state: PanelState.MAX);
  //       if (onTap != null) onTap!();
  //     },
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: hasPadding ? 12.0 : 0,
  //           ),
  //           child: Image.network(
  //             playlist.thumbnail!,
  //             height: 50.0,
  //             width: 50.0,
  //             fit: BoxFit.cover,
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(12.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // GestureDetector(
  //               //   onTap: () => print('Navigate to profile'),
  //               //   child: CircleAvatar(
  //               //     foregroundImage: NetworkImage(video.author.profileImageUrl),
  //               //   ),
  //               // ),
  //               const SizedBox(width: 8.0),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     Flexible(
  //                       child: Text(
  //                         playlist.title!,
  //                         maxLines: 2,
  //                         overflow: TextOverflow.ellipsis,
  //                         style: Theme.of(context)
  //                             .textTheme
  //                             .bodyText1!
  //                             .copyWith(fontSize: 15.0),
  //                       ),
  //                     ),
  //                     // Flexible(
  //                     //   child: Text(
  //                     //     '${video.author.username} • ${video.viewCount} views • ${timeago.format(video.timestamp)}',
  //                     //     maxLines: 2,
  //                     //     overflow: TextOverflow.ellipsis,
  //                     //     style: Theme.of(context)
  //                     //         .textTheme
  //                     //         .caption!
  //                     //         .copyWith(fontSize: 14.0),
  //                     //   ),
  //                     // ),
  //                   ],
  //                 ),
  //               ),
  //               GestureDetector(
  //                 onTap: () {},
  //                 child: const Icon(Icons.more_vert, size: 20.0),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }
}
