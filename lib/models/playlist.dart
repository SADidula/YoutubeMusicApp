import 'package:tempo_fy/models/video.dart';

class Playlist {
  final String? playlistId, title, description, thumbnail;
  final List<Video>? videos;

  Playlist({
    required this.playlistId,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.videos,
  });
}
