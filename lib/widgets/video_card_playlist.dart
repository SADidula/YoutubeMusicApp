import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';
import 'package:tempo_fy/screens/nav_screen.dart';
import 'package:miniplayer/miniplayer.dart';

import '../models/video.dart';

class VideoCardPlaylist extends StatelessWidget {
  final Video video;
  final bool hasPadding;
  final VoidCallback? onTap;

  const VideoCardPlaylist({
    super.key,
    required this.video,
    this.hasPadding = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read(selectedVideoProvider).state = video;
        // context
        //     .read(miniPlayerControllerProvider)
        //     .state
        //     .animateToHeight(state: PanelState.MAX);
        if (onTap != null) onTap!();
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height / 7,
            width: MediaQuery.of(context).size.width - 50,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Transform.scale(
                    scale: 1.1,
                    child: Image.network(
                      video.thumbnail ?? '',
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width / 2.5,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Positioned(
                  left: MediaQuery.of(context).size.width / 2.2,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2.3,
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text(
                          video.title ?? 'loading',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 15,
                              foregroundImage: video.channel == null
                                  ? const NetworkImage(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRS6DCJp3WBa3SIRS1IK_Q6kbJ_Jg71DBeZWQ&s')
                                  : NetworkImage(video.channel!.thumbnail!),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: Text(
                                video.channel?.title ?? 'loading',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                      fontSize: 12.0,
                                    ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
