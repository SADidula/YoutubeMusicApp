import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tempo_fy/models/player_handler.dart';
import 'package:tempo_fy/models/playlist.dart';
import 'package:tempo_fy/models/user.dart';
import 'package:tempo_fy/models/video.dart';
import 'package:tempo_fy/screens/login_screen.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'callbacks/get_youtube_apis.dart';

late AuthClient httpClient;
late GoogleSignInAccount currentUser;
late User userInfo;

late YoutubePlayerController youtubePlayerController;
late YoutubePlayer youtubePlayer;

late Map<String, Video> currentPlayinglist;
late List<String> savedSearchList;
late List<Playlist> userPlaylists;
late List<String> favoriteMusic = List.empty(growable: true);

late List<Video> popularHits, suggestSongs;
final searchRepo = SearchRepository();
late Playlist favoritePlaylist;

late AudioHandler audioHandler;

Future<void> main() async {
  audioHandler = await AudioService.init(
    builder: () => PlayerHandler(false, true, false, videoId: 'GizyKd5i_sE'),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.didulasa.tempofy.AUDIO',
      androidNotificationChannelName: 'TempoFy',
      androidNotificationOngoing: true,
    ),
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      title: 'TempoFy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // backgroundColor: Colors.white,
        brightness: Brightness.dark,
        bottomNavigationBarTheme:
            const BottomNavigationBarThemeData(selectedItemColor: Colors.white),
      ),
      home: LoginScreen(),
    );
  }
}
