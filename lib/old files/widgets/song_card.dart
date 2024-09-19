// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:tempo_fy/main.dart';
// import 'package:tempo_fy/screens/song_screen.dart';

// import '../models/song_model.dart';

// class SongCard extends StatelessWidget {
//   const SongCard({
//     super.key,
//     required this.song,
//   });

//   final Song song;

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => MyApp(
//                 // song: song,
//               ),
//             ));

//         // Navigator.push(
//         //   context,
//         //   MaterialPageRoute(
//         //     builder: (context) => SongScreen(
//         //       song: song,
//         //     ),
//         //   ),
//         // );
//         // Get.toNamed('/song', arguments: song);
//       },
//       child: Container(
//         margin: EdgeInsets.only(right: 10),
//         child: Stack(
//           alignment: Alignment.bottomCenter,
//           children: [
//             Container(
//               width: MediaQuery.of(context).size.width * 0.45,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(25),
//                 image: DecorationImage(
//                   image: NetworkImage(song.thumbnail),
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             ),
//             SingleChildScrollView(
//               child: Container(
//                 height: 50,
//                 margin: EdgeInsets.only(bottom: 10),
//                 width: MediaQuery.of(context).size.width * 0.37,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(15),
//                     color: Colors.white.withOpacity(.8)),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Container(
//                             padding: EdgeInsets.all(8),
//                             width: MediaQuery.of(context).size.width * .27,
//                             child: Text(
//                               song.title,
//                               style: Theme.of(context)
//                                   .textTheme
//                                   .labelSmall!
//                                   .copyWith(
//                                       color: Colors.deepPurple,
//                                       fontWeight: FontWeight.bold),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Icon(
//                       Icons.play_circle,
//                       color: Colors.deepPurple,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
