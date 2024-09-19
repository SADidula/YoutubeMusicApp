import 'package:dio/dio.dart' as Dio_c;
import 'package:tempo_fy/main.dart';
import '../models/video.dart' as video_m;
import '../models/playlist.dart' as playlist_m;
import '../models/channel.dart' as channel_m;
import 'package:intl/intl.dart';
import 'package:googleapis/youtube/v3.dart';

class SearchRepository {
  final dio = Dio_c.Dio();
  final youTubeApi = YouTubeApi(httpClient);

  Future<List<video_m.Video>> getPopularSongsOfTheMonth(
      String search_q, int maxResults) async {
    var date = DateTime.now();
    var prevMonth = DateTime(date.year, date.month - 2, 1);
    var formattedMonth = DateFormat("yyyy-MM-dd").format(prevMonth);

    var response = await youTubeApi.search.list(['snippet'],
        q: search_q,
        type: ['video'],
        videoCategoryId: '10',
        maxResults: maxResults,
        order: 'viewCount',
        publishedAfter: '${formattedMonth}T00:00:00Z');

    List<video_m.Video> list = List.empty(growable: true);
    for (var item in response.items!) {
      var video = await getVideoInfo(item.id!.videoId!);
      list.add(video);
    }

    return list;
  }

  Future<List<String>> getSearchResults(String search_q, int maxResults) async {
    var response = await youTubeApi.search.list(
      ['snippet'],
      q: search_q,
      type: ['video'],
      videoCategoryId: '10',
      maxResults: maxResults,
    );

    List<String> list = List.empty(growable: true);
    for (var item in response.items!) {
      list.add(item.id!.videoId!);
      // var video = await getVideoInfo(item.id!.videoId!);

      // //if no thumbnail dont add to the list
      // if (video[0].thumbnail == null || video[0].thumbnail == '') continue;
      // list.add(video[0]);
    }

    return list;
  }

  Future<List<playlist_m.Playlist>> getPlaylists(int maxResults) async {
    var response = await youTubeApi.playlists
        .list(['snippet', 'status'], mine: true, maxResults: maxResults);

    List<playlist_m.Playlist> list = List.empty(growable: true);

    for (var item in response.items!) {
      if (item.status != null && item.status?.privacyStatus != 'public')
        continue;

      list.add(
        playlist_m.Playlist(
          playlistId: item.id,
          title: item.snippet?.title,
          description: item.snippet?.description,
          thumbnail: item.snippet?.thumbnails?.high?.url,
          videos: await getPlaylistItems(item.id!, maxResults),
        ),
      );
    }

    return list;
  }

  Future<List<video_m.Video>> getPlaylistItems(
      String playlistId, int maxResults) async {
    var response = await youTubeApi.playlistItems.list(
        ['snippet', 'contentDetails'],
        playlistId: playlistId, maxResults: maxResults);

    List<video_m.Video> list = List.empty(growable: true);
    for (var item in response.items!) {
      var video = await getVideoInfo(item.snippet!.resourceId!.videoId!);
      video.setPlaylistItemId(item.id!);
      list.add(video);
    }

    return list;
  }

  Future<channel_m.Channel> getChannelInfo(String channelId) async {
    var response = await youTubeApi.channels.list(['snippet'], id: [channelId]);

    var channelInfo;
    for (var item in response.items!) {
      channelInfo = channel_m.Channel(
        id: item.id,
        title: item.snippet?.title,
        description: item.snippet?.description,
        alias: item.snippet?.customUrl,
        thumbnail: item.snippet?.thumbnails?.high?.url,
      );
    }

    return channelInfo;
  }

  Future<video_m.Video> getVideoInfo(String videoId) async {
    var response = await youTubeApi.videos
        .list(['snippet', 'contentDetails'], id: [videoId]);

    List<video_m.Video> list = List.empty(growable: true);

    for (var item in response.items!) {
      String unformattedDur = item.contentDetails!.duration!;
      var duration = unformattedDur
          .replaceAll("PT", "")
          .replaceAll("H", ":")
          .replaceAll("M", ":")
          .replaceAll("S", "");
      list.add(
        video_m.Video(
          id: item.id,
          title: item.snippet?.title,
          description: item.snippet?.description,
          thumbnail: item.snippet?.thumbnails?.maxres?.url ??
              item.snippet?.thumbnails?.high?.url ??
              item.snippet?.thumbnails?.medium?.url ??
              item.snippet?.thumbnails?.standard?.url,
          duration: duration,
          timestamp: item.snippet?.publishedAt,
          channel: await getChannelInfo(item.snippet!.channelId!),
        ),
      );
    }

    return list[0];
  }

  void insertPlaylistItems(playlist_m.Playlist playlist, video_m.Video video,
      {String kind = 'youtube#video'}) {
    var _requestBody = PlaylistItem(
        snippet: PlaylistItemSnippet(
      playlistId: playlist.playlistId,
      resourceId: ResourceId(
        videoId: video.id,
        kind: kind,
      ),
    ));

    // insert
    youTubeApi.playlistItems.insert(
      _requestBody,
      ['snippet'],
    );
  }

  void deletePlaylistItems(video_m.Video video) {
    // insert
    youTubeApi.playlistItems.delete(
      video.playlistItemId ?? '',
    );
  }

  void insertPlaylist(String playlistName) {
    var _requestBody = Playlist(
      snippet: PlaylistSnippet(
        title: playlistName,
        description: '',
      ),
      status: PlaylistStatus(
        privacyStatus: 'public',
      ),
    );

    var response = youTubeApi.playlists.insert(
      _requestBody,
      ['snippet', 'status'],
    );

    print(response);
  }
}
