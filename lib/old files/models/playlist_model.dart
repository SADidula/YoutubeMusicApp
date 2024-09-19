import 'song_model.dart';

class Playlist {
  final String playlistId, title, description, thumbnail;
  final List<Song> songs;

  Playlist({
    required this.playlistId,
    required this.title,
    required this.description,
    required this.thumbnail,
    required this.songs,
  });
}
