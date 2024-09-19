// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';

// import '../models/playlist_model.dart';
// import '../models/song_model.dart';
// import '../widgets/playlist_card.dart';
// import '../widgets/section_header.dart';
// import '../widgets/song_card.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen(Song song, {super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late List<Song> trendingSongs, searchSongs;
//   late List<Playlist> playlists;

//   final dio = Dio();

//   @override
//   void initState() {
//     super.initState();

//     trendingSongs = List.empty(growable: true);
//     searchSongs = List.empty(growable: true);
//     playlists = List.empty(growable: true);

//     AsynLoadData().then((value) => setState(() {}));
//   }

//   Future<void> AsynLoadData() async {
//     trendingSongs =
//         await fetchSongs('global trending this week official music', '5');
//     playlists = await fetchPlaylists('50');
//   }

//   Future<List<Song>> fetchSongs(
//     String query,
//     String searchResultLimit,
//   ) async {
//     Response songs;
//     songs = await dio.get(
//       'https://www.googleapis.com/youtube/v3/search',
//       queryParameters: {
//         'key': 'AIzaSyCmrhoZR5guwQcHUStgy7IQmjcT-1Sop60',
//         'part': 'snippet',
//         'q': query,
//         'type': 'video',
//         'videoCategoryId': '10',
//         'maxResults': searchResultLimit,
//       },
//     );

//     List<Song> list = List.empty(growable: true);
//     for (var item in songs.data['items']) {
//       list.add(
//         Song(
//           videoId: item['id']['videoId'],
//           title: item['snippet']['title'],
//           // description: item['snippet']['description'],
//           thumbnail: item['snippet']['thumbnails']['high']['url'],
//         ),
//       );
//     }

//     return list;
//   }

//   Future<List<Playlist>> fetchPlaylists(
//     String searchResultLimit,
//   ) async {
//     Response playlists;
//     playlists = await dio.get(
//       'https://www.googleapis.com/youtube/v3/playlists',
//       queryParameters: {
//         'key': 'AIzaSyCmrhoZR5guwQcHUStgy7IQmjcT-1Sop60',
//         'part': 'snippet',
//         'channelId': 'UC0OqeggCMamAoH8iGSArW_Q',
//       },
//     );

//     List<Playlist> list = List.empty(growable: true);
//     for (var item in playlists.data['items']) {
//       list.add(
//         Playlist(
//           playlistId: item['id'],
//           title: item['snippet']['title'],
//           description: item['snippet']['description'],
//           thumbnail: item['snippet']['thumbnails']['high']['url'],
//           songs: await fetchPlaylistSongs(item['id'], searchResultLimit),
//         ),
//       );
//     }

//     return list;
//   }

//   Future<List<Song>> fetchPlaylistSongs(
//     String playlistId,
//     String searchResultLimit,
//   ) async {
//     Response playlistSongs;
//     playlistSongs = await dio.get(
//       'https://www.googleapis.com/youtube/v3/playlistItems',
//       queryParameters: {
//         'key': 'AIzaSyCmrhoZR5guwQcHUStgy7IQmjcT-1Sop60',
//         'part': 'snippet',
//         'playlistId': playlistId,
//         'maxResults': searchResultLimit,
//       },
//     );

//     List<Song> songList = List.empty(growable: true);
//     for (var item in playlistSongs.data['items']) {
//       songList.add(
//         Song(
//           videoId: item['id'],
//           title: item['snippet']['title'],
//           // description: item['snippet']['description'],
//           thumbnail: item['snippet']['thumbnails']['high']['url'],
//         ),
//       );
//     }
//     return songList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//               Colors.deepPurple.shade800.withOpacity(.8),
//               Colors.deepPurple.shade200.withOpacity(.8)
//             ])),
//         child: Scaffold(
//           backgroundColor: Colors.transparent,
//           appBar: const _CustomAppBar(),
//           // bottomNavigationBar: const _CustomNavBar(),
//           body: Column(
//             children: [
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       const _DiscoverMusic(),
//                       _TrendingMusic(songs: trendingSongs),
//                       _PlaylistMusic(playlists: playlists)
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//     );
//   }
// }

// class _PlaylistMusic extends StatelessWidget {
//   const _PlaylistMusic({
//     super.key,
//     required this.playlists,
//   });

//   final List<Playlist> playlists;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         children: [
//           const SectionHeader(title: 'Playlists'),
//           ListView.builder(
//               shrinkWrap: true,
//               padding: const EdgeInsets.only(top: 20),
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: playlists.length,
//               itemBuilder: (context, index) {
//                 return PlaylistCard(playlist: playlists[index]);
//               })
//         ],
//       ),
//     );
//   }
// }

// class _TrendingMusic extends StatelessWidget {
//   const _TrendingMusic({
//     super.key,
//     required this.songs,
//   });

//   final List<Song> songs;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
//       child: Column(
//         children: [
//           const Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: SectionHeader(title: 'Trending Music'),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.27,
//             child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: songs.length,
//                 itemBuilder: (context, index) {
//                   return SongCard(song: songs[index]);
//                 }),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _DiscoverMusic extends StatelessWidget {
//   const _DiscoverMusic({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     TextEditingController searchController = TextEditingController();

//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Welcome',
//             style: Theme.of(context)
//                 .textTheme
//                 .bodyLarge!
//                 .copyWith(color: Colors.white),
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           Text(
//             'Enjoy your favourite music',
//             style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           TextFormField(
//             controller: searchController,
//             textInputAction: TextInputAction.search,
//             decoration: InputDecoration(
//               isDense: true,
//               filled: true,
//               fillColor: Colors.white,
//               hintText: 'Search',
//               hintStyle: Theme.of(context)
//                   .textTheme
//                   .bodyMedium!
//                   .copyWith(color: Colors.black54),
//               prefixIcon: const Icon(
//                 Icons.search,
//                 color: Colors.black54,
//               ),
//               border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(25.0),
//                   borderSide: BorderSide.none),
//             ),
//             onFieldSubmitted: (value) {
//               if (value.isEmpty) {
//                 print('no input');
//               }
//               print(value);
//             },
//           )
//         ],
//       ),
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

// class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const _CustomAppBar({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       leading: const Icon(
//         Icons.grid_view_rounded,
//         color: Colors.white,
//       ),
//       actions: [
//         Container(
//           margin: const EdgeInsets.only(right: 20),
//           child: const CircleAvatar(),
//         )
//       ],
//     );
//   }

//   @override
//   // TODO: implement preferredSize
//   Size get preferredSize => const Size.fromHeight(56);
// }
