import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tempo_fy/main.dart';
import 'package:tempo_fy/screens/nav_screen.dart';
import 'package:tempo_fy/main.dart';

var _playlistController = TextEditingController();
String playlistTitle = '';

class AddPlaylistScreen extends StatefulWidget {
  const AddPlaylistScreen({
    super.key,
    required this.playlistName,
  });

  final String playlistName;

  @override
  State<AddPlaylistScreen> createState() =>
      _AddPlaylistScreenState(playlistName);
}

class _AddPlaylistScreenState extends State<AddPlaylistScreen> {
  late String playlistName;

  _AddPlaylistScreenState(this.playlistName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(177, 0, 0, 0),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  height: MediaQuery.of(context).size.height / 2.9,
                  width: MediaQuery.of(context).size.width / 1.05,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 30.0, top: 30.0, right: 30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add playlist',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall!
                              .copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: _playlistController,
                            obscureText: false,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Title',
                            ),
                            onChanged: (value) =>
                                setState(() => playlistTitle = value),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {},
                              child: GestureDetector(
                                onTap: () {
                                  context.read(addPlaylistProvider).state =
                                      false;
                                  setState(() {});
                                },
                                child: const Text('Cancel'),
                              ),
                            ),
                            const SizedBox(width: 50),
                            InkWell(
                              onTap: () {},
                              child: GestureDetector(
                                onTap: () {
                                  if (playlistTitle == '') return;

                                  searchRepo.insertPlaylist(playlistTitle);

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text('Added a new playlist'),
                                  ));

                                  context.read(addPlaylistProvider).state =
                                      false;
                                  setState(() {});
                                },
                                child: Text(
                                  'Confirm',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(
                                        color: playlistTitle == ''
                                            ? Colors.grey
                                            : Colors.blue,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
