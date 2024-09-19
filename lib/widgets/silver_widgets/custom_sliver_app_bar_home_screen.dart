import 'package:flutter/material.dart';
import 'package:tempo_fy/callbacks/get_user.dart';

import '../../models/user.dart' as user;

class CustomSliverAppBarHomeScreen extends StatelessWidget {
  const CustomSliverAppBarHomeScreen({super.key});

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
        // IconButton(
        //   icon: const Icon(Icons.search),
        //   onPressed: () {
        //     context.read(searchProvider).state = recentSearch;
        //     context.read(selectedSearchProvider).state = null;
        //   },
        // ),
        IconButton(
          iconSize: 40.0,
          icon: CircleAvatar(
            foregroundImage: NetworkImage(user.currentUser.profileImageUrl),
          ),
          onPressed: () {
            UserController.googleSignIn.disconnect();
          },
        ),
      ],
    );
  }
}
