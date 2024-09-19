import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
// import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:async';

import '../models/song_model.dart';
import '../widgets/player_buttons.dart';
import '../widgets/seek_bar.dart';

class SongScreen extends StatefulWidget {
  const SongScreen({
    super.key,
    required this.song,
  });

  final Song song;
  
  @override
  State<StatefulWidget> createState() => _SongScreenState(song);
}

class _SongScreenState extends State<SongScreen> {
  AudioPlayer audioPlayer = AudioPlayer();
  late Song song;
  late YoutubePlayerController youtubeController;
  late YoutubePlayer player;

  late StreamController<Duration> _positionStreamController;
  late Stream<Duration> _positionStream;

  late StreamController<Duration> _durationStreamController;
  late Stream<Duration> _durationStream;
  
  _SongScreenState(this.song);

  @override
  void initState() {
    super.initState();
    setupYoutubePlayer(song.videoId);
  }

  void setupYoutubePlayer(String videoId) {
    // youtubeController = YoutubePlayerController(
    //   initialVideoId: videoId,
    //   flags: const YoutubePlayerFlags(
    //     autoPlay: true,
    //     mute: false,
    //     loop: false,
    //     isLive: false,
    //     forceHD: false,
    //     enableCaption: false,
    //     hideControls: true,
    //   ),
    // );

    // youtubeController.load(videoId);

    _positionStreamController = StreamController<Duration>();
    _positionStream = _positionStreamController.stream;

    _durationStreamController = StreamController<Duration>();
    _durationStream = _durationStreamController.stream;

    // Start emitting position and duration updates
    Timer.periodic(
      const Duration(seconds: 1),
      _emitPosition,
    );
    Timer.periodic(
      const Duration(seconds: 1),
      _emitDuration,
    );
  }

  void _emitPosition(Timer timer) {
    // if (youtubeController.value.isPlaying) {
    //   _positionStreamController.add(youtubeController.value.position);
    // }
  }

  void _emitDuration(Timer timer) {
    // if (youtubeController.value.isPlaying) {
    //   _durationStreamController.add(youtubeController.metadata.duration);
    // }
  }

  // @override
  // void dispose() {
  //   youtubeController.dispose();
  //   audioPlayer.dispose();
  //   super.dispose();
  // }

  Stream<SeekBarData> get _seekBarDataStream =>
      rxdart.Rx.combineLatest2<Duration, Duration?, SeekBarData>(
          _positionStream, _durationStream, (
        Duration position,
        Duration? duration,
      ) {
        return SeekBarData(
          position,
          duration ?? Duration.zero,
        );
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Image.network(
          //   song.thumbnail,
          //   fit: BoxFit.cover,
          // ),
          const _BackgroundFilter(),
          _MusicPlayer(
            song: song,
            seekBarDataStream: _seekBarDataStream,
            audioPlayer: audioPlayer,
            youtubeController: youtubeController,
          ),
        ],
      ),
    );
  }
}

class _MusicPlayer extends StatelessWidget {
  const _MusicPlayer({
    super.key,
    required this.song,
    required Stream<SeekBarData> seekBarDataStream,
    required this.audioPlayer,
    required this.youtubeController,
  }) : _seekBarDataStream = seekBarDataStream;

  final Song song;
  final Stream<SeekBarData> _seekBarDataStream;
  final AudioPlayer audioPlayer;
  final YoutubePlayerController youtubeController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 30,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: YoutubePlayer(
              controller: youtubeController,
            ),
          ),
          Text(
            song.title,
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          // Text(song.description,
          //     maxLines: 2, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(
            height: 30,
          ),
          StreamBuilder<SeekBarData>(
            // stream: null,
            stream: _seekBarDataStream,
            builder: (context, snapshot) {
              // final positionData = snapshot.data;
              return SeekBar(
                position: snapshot.data?.position ?? Duration.zero,
                duration: snapshot.data?.duration ?? Duration.zero,
                // onChangeEnd: youtubeController.seekTo,
              );
            },
          ),
          PlayerButtons(audioPlayer: audioPlayer),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {},
                iconSize: 35,
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {},
                iconSize: 35,
                icon: const Icon(
                  Icons.cloud_download,
                  color: Colors.white,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _BackgroundFilter extends StatelessWidget {
  const _BackgroundFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(.5),
              Colors.white.withOpacity(0),
            ],
            stops: const [
              0,
              .4,
              .6
            ]).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade200, Colors.deepPurple.shade800],
          ),
        ),
      ),
    );
  }
}
