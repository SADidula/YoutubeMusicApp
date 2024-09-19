// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tempo_fy/models/song_model.dart';
// import 'screens/home_screen.dart';
// import 'screens/login_screen.dart';
// import 'screens/song_screen.dart';
// import 'screens/play_list_screen.dart';
// import 'package:miniplayer/miniplayer.dart';

// void main() {
//   runApp(
//     MyApp(),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late Song song;
//   late HomeScreen homeScreen = HomeScreen(Song(videoId: '', title: 'test', thumbnail: 'thumbnail'));

//   @override
//   void initState() {
//     super.initState();
//     song = Song(videoId: 'r_0JjYUe5jo', title: 'Eminem - Godzilla ft. Juice WRLD (Directed by Cole Bennett)', thumbnail: 'https://i.ytimg.com/vi/r_0JjYUe5jo/maxresdefault.jpg');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       defaultTransition: Transition.fade,
//       title: 'TempoFy',
//       theme: ThemeData(
//         textTheme: Theme.of(context)
//             .textTheme
//             .apply(bodyColor: Colors.white, displayColor: Colors.white),
//       ),
//       home: Scaffold(
//         bottomNavigationBar: _CustomNavBar(),
//         body: Stack(
//           children: <Widget>[
//             homeScreen,
//             Miniplayer(
//               minHeight: song.videoId == '' ? 0 : 60,
//               maxHeight: MediaQuery.of(context).size.height,
//               builder: (height, percentage) {
//                 if (percentage > 0.2) {
//                   return SongScreen(
//                     song: song,
//                   );
//                 } else {
//                   // return Container();
//                   return Padding(
//                     padding: const EdgeInsets.only(left: 4, right: 4),
//                     child: Container(
//                       height: 75,
//                       margin: EdgeInsets.only(bottom: 5),
//                       padding: EdgeInsets.symmetric(horizontal: 20),
//                       decoration: BoxDecoration(
//                           color: Colors.deepPurple.shade800.withOpacity(.6),
//                           borderRadius: BorderRadius.circular(25)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         children: [
//                           const SizedBox(
//                             width: 10,
//                           ),
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(25.0),
//                             child: const Icon(
//                               Icons.music_off,
//                               size: 35,
//                               color: Colors.white,
//                             ),
//                             // Image.network(
//                             //   height: 50,
//                             //   width: 50,
//                             //   fit: BoxFit.cover,
//                             // ),
//                           ),
//                           const SizedBox(
//                             width: 20,
//                           ),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Nothing Playing",
//                                   maxLines: 2,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyLarge!
//                                       .copyWith(fontWeight: FontWeight.bold),
//                                 ),
//                                 // Text("playlist.description",
//                                 //     maxLines: 2,
//                                 //     style: Theme.of(context).textTheme.bodySmall),
//                               ],
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: () {},
//                             icon: const Icon(
//                               Icons.play_arrow,
//                               color: Colors.white,
//                               size: 40,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//       // builder: (context, child) {
//       //   return
//       // },
//       // getPages: [
//       //   // GetPage(name: '/', page: () => const LoginScreen()),
//       //   GetPage(name: '/', page: () => const HomeScreen()),
//       //   GetPage(name: '/song', page: () => const SongScreen()),
//       //   GetPage(name: '/playlist', page: () => const PlaylistScreen()),
//       // ],
//     );
//   }
// }

// class _CustomNavBar extends StatelessWidget {
//   const _CustomNavBar({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       backgroundColor: Colors.deepPurple.shade800,
//       unselectedItemColor: Colors.white,
//       selectedItemColor: Colors.white,
//       showUnselectedLabels: false,
//       showSelectedLabels: false,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.search_outlined),
//           label: 'Search',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.people_outline),
//           label: 'Profile',
//         ),
//       ],
//     );
//   }
// }
