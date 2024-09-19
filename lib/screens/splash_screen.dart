import 'package:audio_session/audio_session.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tempo_fy/callbacks/local_storage.dart';
import 'package:tempo_fy/main.dart';
import 'package:tempo_fy/models/playlist.dart';
import 'package:tempo_fy/models/video.dart';
import 'package:tempo_fy/screens/nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    AudioSession.instance.then((audioSession) async {
      await audioSession.configure(const AudioSessionConfiguration.music());
      // await youtubePlayerController;
    });

    _controller = AnimationController(

        /// [AnimationController]s can be created with `vsync: this` because of
        /// [TickerProviderStateMixin].
        vsync: this,
        duration: const Duration(seconds: 2),
        animationBehavior: AnimationBehavior.preserve)
      ..addListener(() {
        setState(() {
          if (userPlaylists.isNotEmpty) {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => NavScreen(),
            ));
          }
        });
      });
    _controller.repeat();

    _colorTween = _controller.drive(ColorTween(
      begin: Colors.blue.shade900,
      end: Colors.deepOrange.shade900,
    ));

    retrieveSavedInfo();

    currentPlayinglist = Map();
    userPlaylists = List.empty(growable: true);

    popularHits = List.empty(growable: true);
    suggestSongs = List.empty(growable: true);

    asynLoadUserPlayList().then((value) => addToFavorites());

    asynLoadPopularSongs().then((value) => setState(() {}));

    super.initState();
  }

  Future<void> asynLoadUserPlayList() async {
    userPlaylists = await searchRepo.getPlaylists(1000);
  }

  Future<void> asynLoadPopularSongs() async {
    popularHits = await searchRepo.getPopularSongsOfTheMonth(
        'Official music video - no other videos | live videos', 8);
  }

  void addToFavorites() {
    //create empty favorite list
    List<Video> emptylist = [];
    favoritePlaylist = Playlist(
        playlistId: '',
        title: '',
        description: '',
        thumbnail: '',
        videos: emptylist);

    for (var playlist in userPlaylists) {

      for (var video in playlist.videos!) {
        if (!playlist.title!.toLowerCase().contains('favourite')) continue;
        favoriteMusic.add(video.id!);
      }
      favoritePlaylist = playlist;

      print('${favoritePlaylist.playlistId}, ${favoritePlaylist.title}');
    }
  }

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  void retrieveSavedInfo() async {
    savedSearchList = await LocalStorage.getSearchList('search') ??
        List.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset(
                  width: 150,
                  'assets/icon_light.png',
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Your Favorite Music from Youtube',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30, bottom: 30),
                child: Text(
                  'With the Tempofy music app you can get access to millions of songs, including your favorites',
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  valueColor: _colorTween,
                  strokeWidth: 10,
                  strokeCap: StrokeCap.round,
                  semanticsLabel: 'Circular progress indicator',
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
