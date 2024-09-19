import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:tempo_fy/screens/nav_screen.dart';

class CustomSliverAppBarLibraryScreen extends StatelessWidget {
  const CustomSliverAppBarLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      leadingWidth: 100.0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Image.asset('assets/icon_light.png'),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          iconSize: 35,
          onPressed: () {
            context.read(addPlaylistProvider).state = true;
            // context.read(selectedSearchProvider).state = null;
          },
        ),
        // IconButton(
        //   iconSize: 40.0,
        //   icon: CircleAvatar(
        //     foregroundImage: NetworkImage(user.currentUser.profileImageUrl),
        //   ),
        //   onPressed: () {
        //     UserController.googleSignIn.disconnect();
        //   },
        // ),
      ],
    );
  }
}
