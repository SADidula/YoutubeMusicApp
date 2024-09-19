import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:marquee/marquee.dart';
import 'package:tempo_fy/models/channel.dart';
import '../models/user.dart';
import '../models/video.dart';

class VideoInfo extends StatelessWidget {
  final Video video;

  const VideoInfo({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 15.0),
              CircleAvatar(
                foregroundImage: NetworkImage(video.channel!.thumbnail!),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Text(
                  maxLines: 2,
                  video.title!,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          // const SizedBox(height: 8.0),
          // const Divider(),
          // _AuthorInfo(channel: video.channel!),
          // const SizedBox(height: 8.0),
          // _ActionsRow(video: video),
          // const Divider(),
          // const Divider(),
        ],
      ),
    );
  }
}

class _AuthorInfo extends StatelessWidget {
  final Channel channel;

  const _AuthorInfo({
    Key? key,
    required this.channel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Navigate to profile'),
      child: Row(
        children: [
          const SizedBox(width: 15.0),
          CircleAvatar(
            foregroundImage: NetworkImage(channel.thumbnail!),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    channel.title!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 15.0),
                  ),
                ),
                Flexible(
                  child: Text(
                    channel.alias!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontSize: 14.0),
                  ),
                ),
              ],
            ),
          ),
          // TextButton(
          //   onPressed: () {},
          //   child: Text(
          //     'SUBSCRIBE',
          //     style: Theme.of(context)
          //         .textTheme
          //         .bodyText1!
          //         .copyWith(color: Colors.red),
          //   ),
          // )
        ],
      ),
    );
  }
}
