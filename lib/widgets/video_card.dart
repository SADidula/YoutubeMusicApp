import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempo_fy/screens/nav_screen.dart';
import 'package:miniplayer/miniplayer.dart';

import '../models/video.dart';

class VideoCard extends StatelessWidget {
  final Video video;
  final bool hasPadding;
  final VoidCallback? onTap;

  const VideoCard({
    Key? key,
    required this.video,
    this.hasPadding = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Uint8List blankBytes = const Base64Codec()
        .decode("R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7");

    return GestureDetector(
      onTap: () {
        context.read(selectedVideoProvider).state = video;
        context
            .read(miniPlayerControllerProvider)
            .state
            .animateToHeight(state: PanelState.MAX);
        if (onTap != null) onTap!();
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          color: const Color.fromARGB(50, 0, 0, 0),
          child: Column(
            children: [
              Stack(
                children: [
                  Transform.scale(
                    scale: 1.1,
                    child: Image.network(
                      video.thumbnail!,
                      height: MediaQuery.of(context).size.height / 3.8,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 8.0,
                    right: 8.0,
                    child: Container(
                      padding: const EdgeInsets.all(4.0),
                      color: Colors.black,
                      child: Text(
                        video.duration ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      foregroundImage: video.channel == null
                          ? const NetworkImage(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRS6DCJp3WBa3SIRS1IK_Q6kbJ_Jg71DBeZWQ&s')
                          : NetworkImage(video.channel!.thumbnail!),
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              video.title ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontSize: 15.0),
                            ),
                          ),
                          // Flexible(
                          //   child: Text(
                          //     '${video.channel!.title!} • ${video.viewCount} views • ${timeago.format(video.timestamp)}',
                          //     maxLines: 2,
                          //     overflow: TextOverflow.ellipsis,
                          //     style: Theme.of(context)
                          //         .textTheme
                          //         .caption!
                          //         .copyWith(fontSize: 14.0),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read(moreOptionProvider).state = video;
                      },
                      child: const Icon(Icons.more_vert, size: 20.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
