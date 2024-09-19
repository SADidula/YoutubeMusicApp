import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempo_fy/main.dart';
import 'package:tempo_fy/models/video.dart';
import 'package:tempo_fy/screens/nav_screen.dart';

class MoreOptionScreen extends StatefulWidget {
  const MoreOptionScreen({
    super.key,
    required this.video,
  });

  final Video video;

  @override
  State<MoreOptionScreen> createState() => _MoreOptionScreenState(video);
}

class _MoreOptionScreenState extends State<MoreOptionScreen> {
  late Video video;

  _MoreOptionScreenState(this.video);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(177, 0, 0, 0),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: MediaQuery.of(context).size.height / 2.9,
                  width: MediaQuery.of(context).size.width / 1.05,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onPanUpdate: (details) {
                            if (details.delta.dy > 0) {
                              context.read(moreOptionProvider).state = null;
                            }
                          },
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.horizontal_rule,
                                size: 50,
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            currentPlayinglist[widget.video.id!] = widget.video;

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Added to the queue'),
                            ));
                          },
                          child: const _ActionButtonWidget(
                            displayIcon: Icons.queue_music,
                            title: 'Add to queue',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (favoriteMusic.contains(widget.video.id!)) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text('Already in the favorites'),
                              ));
                              return;
                            }

                            //add to the temp favorite list
                            favoriteMusic.add(widget.video.id!);
                            //add to the favorite playlist
                            favoritePlaylist.videos!.add(widget.video);

                            searchRepo.insertPlaylistItems(
                                favoritePlaylist, widget.video);

                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Added to favorites'),
                            ));

                            setState(() {});
                          },
                          child: _ActionButtonWidget(
                            displayIcon:
                                favoriteMusic.contains(widget.video.id!)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                            title: 'Add to favorite',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Added to the playlist'),
                            ));
                          },
                          child: const _ActionButtonWidget(
                            displayIcon: Icons.playlist_add,
                            title: 'Save to playlist',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButtonWidget extends StatelessWidget {
  const _ActionButtonWidget({
    super.key,
    required this.displayIcon,
    required this.title,
  });

  final IconData displayIcon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 8, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            displayIcon,
            size: 25,
          ),
          const SizedBox(width: 40),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}
