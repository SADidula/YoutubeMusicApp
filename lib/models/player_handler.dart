import 'package:audio_service/audio_service.dart';
import 'package:tempo_fy/models/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerHandler extends BaseAudioHandler with SeekHandler {
  late YoutubePlayerController youtubePlayerController;

  static final _item = MediaItem(
    id: 'https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3',
    album: "Science Friday",
    title: "A Salute To Head-Scratching Science",
    artist: "Science Friday and WNYC Studios",
    duration: const Duration(milliseconds: 5739820),
    artUri: Uri.parse(
        'https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg'),
  );

  PlayerHandler(bool autoPlay, bool isMute, bool isHD, {String videoId = ''}) {
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        autoPlay: autoPlay,
        mute: isMute,
        loop: false,
        isLive: false,
        forceHD: isHD,
        enableCaption: false,
        hideControls: true,
      ),
    );

    // youtubePlayerController.playbackEventStream.map(transformEvent).pipe(playbackState);
  }

  @override
  Future<void> play() async {
    youtubePlayerController.play();
  }

  @override
  Future<void> pause() async {
    youtubePlayerController.pause();
  }

  @override
  Future<void> seek(Duration position) async {
    youtubePlayerController.seekTo(position);
  }

  @override
  Future<void> stop() async {
    youtubePlayerController.pause();
  }

  // PlaybackState transformEvent(PlaybackEvent event) {
  //   return PlaybackState(
  //     controls: [
  //       MediaControl.rewind,
  //       if (_player.playing) MediaControl.pause else MediaControl.play,
  //       MediaControl.stop,
  //       MediaControl.fastForward,
  //     ],
  //     systemActions: const {
  //       MediaAction.seek,
  //       MediaAction.seekForward,
  //       MediaAction.seekBackward,
  //     },
  //     androidCompactActionIndices: const [0, 1, 3],
  //     processingState: const {
  //       ProcessingState.idle: AudioProcessingState.idle,
  //       ProcessingState.loading: AudioProcessingState.loading,
  //       ProcessingState.buffering: AudioProcessingState.buffering,
  //       ProcessingState.ready: AudioProcessingState.ready,
  //       ProcessingState.completed: AudioProcessingState.completed,
  //     }[_player.processingState]!,
  //     playing: _player.playing,
  //     updatePosition: _player.position,
  //     bufferedPosition: _player.bufferedPosition,
  //     speed: _player.speed,
  //     queueIndex: event.currentIndex,
  //   );
  // }
}
