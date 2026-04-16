import 'dart:math' as math;

import '../env/app_env.dart';
import 'tmdb_client.dart';

class TmdbService {
  TmdbService({
    required TmdbClient client,
    required String imageUrl,
  })  : _client = client,
        _imageUrl = imageUrl;

  factory TmdbService.fromEnv() {
    return TmdbService(
      client: TmdbClient(
        baseUrl: AppEnv.tmdbBaseUrl,
        apiKey: AppEnv.tmdbApiKey,
        token: AppEnv.tmdbToken,
        httpClient: TmdbClient.createDefaultHttpClient(
          connectionTimeout: const Duration(seconds: 20),
        ),
        timeout: const Duration(seconds: 20),
        maxRetries: 4,
      ),
      imageUrl: AppEnv.tmdbImageBase,
    );
  }

  final TmdbClient _client;
  final String _imageUrl;

  // ── Image URL helpers ──────────────────────────────────────
  String poster(String? path, {String size = 'w500'}) {
    if (path == null || path.isEmpty) {
      return 'https://images.unsplash.com/photo-1536440136628-849c177e76a1?w=500&h=750&fit=crop';
    }
    return '${_imageUrl.trim().replaceAll(RegExp(r'/+$'), '')}/$size$path';
  }

  String backdrop(String? path, {String size = 'w1280'}) {
    if (path == null || path.isEmpty) {
      return 'https://images.unsplash.com/photo-1514306191717-45224512c2d0?w=1920&h=1080&fit=crop';
    }
    return '${_imageUrl.trim().replaceAll(RegExp(r'/+$'), '')}/$size$path';
  }

  String? profile(String? path, {String size = 'w185'}) {
    if (path == null || path.isEmpty) return null;
    return '${_imageUrl.trim().replaceAll(RegExp(r'/+$'), '')}/$size$path';
  }

  // ── Base fetch with auth ───────────────────────────────────
  Future<Map<String, dynamic>> tmdbFetch(
    String endpoint, {
    Map<String, String> params = const {},
  }) async {
    // React version always passes api_key + language.
    return _client.getJson(endpoint, params: {
      ...params,
      'language': params['language'] ?? 'en-US',
    });
  }

  // ── TMDB genre ID → name map (common ones) ─────────────────
  String genreIdToName(int id) {
    const map = <int, String>{
      28: 'Action',
      12: 'Adventure',
      16: 'Animation',
      35: 'Comedy',
      80: 'Crime',
      99: 'Documentary',
      18: 'Drama',
      10751: 'Family',
      14: 'Fantasy',
      36: 'History',
      27: 'Horror',
      10402: 'Music',
      9648: 'Mystery',
      10749: 'Romance',
      878: 'Sci-Fi',
      53: 'Thriller',
      10752: 'War',
      37: 'Western',
      10759: 'Action & Adventure',
      10762: 'Kids',
      10763: 'News',
      10764: 'Reality',
      10765: 'Sci-Fi & Fantasy',
      10766: 'Soap',
      10767: 'Talk',
      10768: 'War & Politics',
    };
    return map[id] ?? 'Drama';
  }

  // ── Transform TMDB movie → Camcine Content shape ──────────
  Map<String, dynamic> transformMovie(Map<String, dynamic> movie) {
    final tmdbId = movie['id'];
    final release = (movie['release_date'] ?? '') as String;
    final releaseYear = int.tryParse(release.split('-').first) ?? 2024;

    final genres = ((movie['genres'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>()
        .map((g) => (g['name'] ?? '').toString())
        .where((n) => n.trim().isNotEmpty)
        .toList(growable: false);

    final genreIds = ((movie['genre_ids'] as List<dynamic>?) ?? const <dynamic>[])
        .whereType<num>()
        .map((n) => n.toInt())
        .toList(growable: false);

    final outGenres = genres.isNotEmpty
        ? genres
        : (genreIds.isNotEmpty
            ? genreIds.take(2).map(genreIdToName).toList(growable: false)
            : const ['Drama']);

    final originalLang = (movie['original_language'] ?? '') as String;

    final voteAverage = (movie['vote_average'] as num?)?.toDouble();
    final voteCount = (movie['vote_count'] as num?)?.toDouble() ?? 0;
    final popularity = (movie['popularity'] as num?)?.toDouble() ?? 0;

    final runtime = (movie['runtime'] as num?)?.toInt();

    String trailer = '';
    final videos = movie['videos'];
    if (videos is Map<String, dynamic>) {
      final results = (videos['results'] as List<dynamic>?) ?? const <dynamic>[];
      for (final v in results) {
        if (v is! Map<String, dynamic>) continue;
        if ((v['type'] ?? '') == 'Trailer') {
          final key = (v['key'] ?? '').toString();
          if (key.trim().isNotEmpty) {
            trailer = 'https://www.youtube.com/watch?v=$key';
          }
          break;
        }
      }
    }

    final credits = movie['credits'];
    final cast = <Map<String, dynamic>>[];
    final crew = <Map<String, dynamic>>[];
    if (credits is Map<String, dynamic>) {
      final castRaw = (credits['cast'] as List<dynamic>?) ?? const <dynamic>[];
      for (final c in castRaw) {
        if (c is! Map<String, dynamic>) continue;
        if (cast.length >= 6) break;
        cast.add({
          'id': 'cast-${c['id']}',
          'name': (c['name'] ?? '').toString(),
          'character': (c['character'] ?? '').toString(),
          'avatar': profile(c['profile_path'] as String?),
        });
      }

      final crewRaw = (credits['crew'] as List<dynamic>?) ?? const <dynamic>[];
      for (final c in crewRaw) {
        if (c is! Map<String, dynamic>) continue;
        if ((c['job'] ?? '') != 'Director') continue;
        crew.add({
          'id': 'crew-${c['id']}',
          'name': (c['name'] ?? '').toString(),
          'role': (c['job'] ?? '').toString(),
        });
        if (crew.length >= 2) break;
      }
    }

    final keywords = movie['keywords'];
    final tags = <String>[];
    if (keywords is Map<String, dynamic>) {
      final list = (keywords['keywords'] as List<dynamic>?) ?? const <dynamic>[];
      for (final k in list) {
        if (k is! Map<String, dynamic>) continue;
        final name = (k['name'] ?? '').toString().trim();
        if (name.isEmpty) continue;
        tags.add(name);
        if (tags.length >= 5) break;
      }
    }

    return {
      'id': 'movie-$tmdbId',
      'tmdbId': tmdbId,
      'title': (movie['title'] ?? movie['original_title'] ?? '').toString(),
      'description': (movie['overview'] ?? '').toString(),
      'type': 'movie',
      'status': 'premium',
      'poster': poster(movie['poster_path'] as String?),
      'backdrop': backdrop(movie['backdrop_path'] as String?),
      'releaseYear': releaseYear,
      'rating': (movie['adult'] == true) ? 'A' : 'U/A',
      'tmdbRating': voteAverage?.toStringAsFixed(1),
      'duration': runtime != null ? runtime * 60 : 7200,
      'genres': outGenres,
      'languages': originalLang.trim().isNotEmpty
          ? [originalLang.toUpperCase()]
          : ['EN'],
      'region': 'Hollywood',
      'mood': const <dynamic>[],
      'cast': cast,
      'crew': crew,
      'tags': tags,
      'isTrending': popularity > 100,
      'isFeatured': (voteAverage ?? 0) > 7.5,
      'viewCount': (popularity * 1000).round(),
      'likes': (voteCount * 10).round(),
      'videoUrl': '',
      'trailer': trailer,
    };
  }

  // ── Transform TMDB TV show → Camcine Content shape ────────
  Map<String, dynamic> transformSeries(Map<String, dynamic> show) {
    final tmdbId = show['id'];
    final firstAir = (show['first_air_date'] ?? '') as String;
    final releaseYear = int.tryParse(firstAir.split('-').first) ?? 2024;

    final genres = ((show['genres'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>()
        .map((g) => (g['name'] ?? '').toString())
        .where((n) => n.trim().isNotEmpty)
        .toList(growable: false);

    final genreIds = ((show['genre_ids'] as List<dynamic>?) ?? const <dynamic>[])
        .whereType<num>()
        .map((n) => n.toInt())
        .toList(growable: false);

    final outGenres = genres.isNotEmpty
        ? genres
        : (genreIds.isNotEmpty
            ? genreIds.take(2).map(genreIdToName).toList(growable: false)
            : const ['Drama']);

    final originalLang = (show['original_language'] ?? '') as String;
    final voteAverage = (show['vote_average'] as num?)?.toDouble();
    final voteCount = (show['vote_count'] as num?)?.toDouble() ?? 0;
    final popularity = (show['popularity'] as num?)?.toDouble() ?? 0;

    String trailer = '';
    final videos = show['videos'];
    if (videos is Map<String, dynamic>) {
      final results = (videos['results'] as List<dynamic>?) ?? const <dynamic>[];
      for (final v in results) {
        if (v is! Map<String, dynamic>) continue;
        if ((v['type'] ?? '') == 'Trailer') {
          final key = (v['key'] ?? '').toString();
          if (key.trim().isNotEmpty) {
            trailer = 'https://www.youtube.com/watch?v=$key';
          }
          break;
        }
      }
    }

    final credits = show['credits'];
    final cast = <Map<String, dynamic>>[];
    final crew = <Map<String, dynamic>>[];
    if (credits is Map<String, dynamic>) {
      final castRaw = (credits['cast'] as List<dynamic>?) ?? const <dynamic>[];
      for (final c in castRaw) {
        if (c is! Map<String, dynamic>) continue;
        if (cast.length >= 6) break;
        cast.add({
          'id': 'cast-${c['id']}',
          'name': (c['name'] ?? '').toString(),
          'character': (c['character'] ?? '').toString(),
          'avatar': profile(c['profile_path'] as String?),
        });
      }

      final crewRaw = (credits['crew'] as List<dynamic>?) ?? const <dynamic>[];
      for (final c in crewRaw) {
        if (c is! Map<String, dynamic>) continue;
        final job = (c['job'] ?? '').toString();
        if (job != 'Director' && job != 'Executive Producer') continue;
        crew.add({
          'id': 'crew-${c['id']}',
          'name': (c['name'] ?? '').toString(),
          'role': job,
        });
        if (crew.length >= 2) break;
      }
    }

    final keywords = show['keywords'];
    final tags = <String>[];
    if (keywords is Map<String, dynamic>) {
      final list = (keywords['results'] as List<dynamic>?) ?? const <dynamic>[];
      for (final k in list) {
        if (k is! Map<String, dynamic>) continue;
        final name = (k['name'] ?? '').toString().trim();
        if (name.isEmpty) continue;
        tags.add(name);
        if (tags.length >= 5) break;
      }
    }

    final seasonsRaw = (show['seasons'] as List<dynamic>?) ?? const <dynamic>[];
    final seasons = <Map<String, dynamic>>[];
    for (final s in seasonsRaw) {
      if (s is! Map<String, dynamic>) continue;
      seasons.add({
        'id': s['id'],
        'number': (s['season_number'] as num?)?.toInt() ?? 0,
        'title': (s['name'] ?? '').toString(),
        'episodeCount': (s['episode_count'] as num?)?.toInt() ?? 0,
        'poster': poster(s['poster_path'] as String?),
        'episodes': <dynamic>[],
      });
    }

    return {
      'id': 'series-$tmdbId',
      'tmdbId': tmdbId,
      'title': (show['name'] ?? show['original_name'] ?? '').toString(),
      'description': (show['overview'] ?? '').toString(),
      'type': 'series',
      'status': 'premium',
      'poster': poster(show['poster_path'] as String?),
      'backdrop': backdrop(show['backdrop_path'] as String?),
      'releaseYear': releaseYear,
      'rating': (show['adult'] == true) ? 'A' : 'U/A',
      'tmdbRating': voteAverage?.toStringAsFixed(1),
      'duration': 0,
      'genres': outGenres,
      'languages': originalLang.trim().isNotEmpty
          ? [originalLang.toUpperCase()]
          : ['EN'],
      'region': 'Hollywood',
      'mood': const <dynamic>[],
      'cast': cast,
      'crew': crew,
      'tags': tags,
      'isTrending': popularity > 100,
      'isFeatured': (voteAverage ?? 0) > 7.5,
      'viewCount': (popularity * 1000).round(),
      'likes': (voteCount * 10).round(),
      'seasons': seasons,
      'totalEpisodes': (show['number_of_episodes'] as num?)?.toInt(),
      'videoUrl': '',
      'trailer': trailer,
    };
  }

  // ═══════════════════════════════════════════════════════════
  // PUBLIC API — drop-in replacements for contentService
  // ═══════════════════════════════════════════════════════════

  // Trending movies + shows (replaces getTrendingContent)
  Future<List<Map<String, dynamic>>> getTrending() async {
    final results = await Future.wait([
      tmdbFetch('/trending/movie/week'),
      tmdbFetch('/trending/tv/week'),
    ]);
    final movies = results[0];
    final shows = results[1];

    final movieList = ((movies['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    final showList = ((shows['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();

    return [
      ...movieList.take(8).map(transformMovie),
      ...showList.take(4).map(transformSeries),
    ];
  }

  // Popular movies (replaces getMovies / getCuratedPicks for movies)
  Future<List<Map<String, dynamic>>> getPopularMovies() async {
    final data = await tmdbFetch('/movie/popular');
    final list = ((data['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    return list.take(12).map(transformMovie).toList(growable: false);
  }

  // Now playing in theatres
  Future<List<Map<String, dynamic>>> getNowPlaying() async {
    final data = await tmdbFetch('/movie/now_playing');
    final list = ((data['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    return list.take(10).map(transformMovie).toList(growable: false);
  }

  // Top rated movies
  Future<List<Map<String, dynamic>>> getTopRated() async {
    final data = await tmdbFetch('/movie/top_rated');
    final list = ((data['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    return list.take(12).map(transformMovie).toList(growable: false);
  }

  // Popular TV series (replaces getSeries)
  Future<List<Map<String, dynamic>>> getPopularSeries() async {
    final data = await tmdbFetch('/tv/popular');
    final list = ((data['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    return list.take(12).map(transformSeries).toList(growable: false);
  }

  // Featured content (replaces getFeaturedContent)
  Future<List<Map<String, dynamic>>> getFeatured() async {
    final data = await tmdbFetch('/movie/top_rated', params: const {'page': '1'});
    final list = ((data['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    final filtered = list.where((m) => (m['backdrop_path'] ?? '').toString().isNotEmpty);
    return filtered.take(5).map(transformMovie).toList(growable: false);
  }

  // Search movies + shows (replaces searchContent)
  Future<List<Map<String, dynamic>>> search(String query) async {
    if (query.trim().isEmpty) return const [];
    final data = await tmdbFetch('/search/multi', params: {
      'query': query,
      'include_adult': 'false',
    });
    final list = ((data['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();

    final out = <Map<String, dynamic>>[];
    for (final r in list) {
      final mediaType = (r['media_type'] ?? '').toString();
      if (mediaType != 'movie' && mediaType != 'tv') continue;
      out.add(mediaType == 'movie' ? transformMovie(r) : transformSeries(r));
      if (out.length >= 20) break;
    }
    return out;
  }

  // Get single movie details with credits + videos
  Future<Map<String, dynamic>> getMovieDetails(int tmdbId) async {
    final data = await tmdbFetch('/movie/$tmdbId', params: const {
      'append_to_response': 'credits,videos,keywords',
    });
    return transformMovie(data);
  }

  // Get similar movies
  Future<List<Map<String, dynamic>>> getSimilarMovies(int tmdbId) async {
    final data = await tmdbFetch('/movie/$tmdbId/similar');
    final list = ((data['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    return list.take(8).map(transformMovie).toList(growable: false);
  }

  // Get single TV show details
  Future<Map<String, dynamic>> getSeriesDetails(int tmdbId) async {
    final data = await tmdbFetch('/tv/$tmdbId', params: const {
      'append_to_response': 'credits,videos,keywords',
    });
    final show = transformSeries(data);

    final seasons = (show['seasons'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
        const <Map<String, dynamic>>[];
    final tmdbSeasons =
        (data['seasons'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ??
            const <Map<String, dynamic>>[];
    final firstSeasonNum = tmdbSeasons
            .firstWhere(
              (s) => ((s['season_number'] as num?)?.toInt() ?? 0) > 0,
              orElse: () => const <String, dynamic>{},
            )['season_number'] ??
        0;

    if (seasons.isNotEmpty) {
      final seasonNumber = (firstSeasonNum as num?)?.toInt() ?? 0;
      final seasonData = await getSeasonDetails(tmdbId, seasonNumber);
      final idx = seasons.indexWhere((s) => (s['number'] as int?) == seasonNumber);
      if (idx >= 0) {
        seasons[idx] = {
          ...seasons[idx],
          'episodes': seasonData,
        };
        show['seasons'] = seasons;
      }
    }

    return show;
  }

  // Get episodes for a specific season
  Future<List<Map<String, dynamic>>> getSeasonDetails(
    int tmdbId,
    int seasonNumber,
  ) async {
    final data = await tmdbFetch('/tv/$tmdbId/season/$seasonNumber');
    final list = ((data['episodes'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();

    return list.map((ep) {
      final runtime = (ep['runtime'] as num?)?.toInt();
      return {
        'id': 'episode-${ep['id']}',
        'tmdbId': ep['id'],
        'number': (ep['episode_number'] as num?)?.toInt() ?? 0,
        'title': (ep['name'] ?? '').toString(),
        'description': (ep['overview'] ?? '').toString(),
        'thumbnail': backdrop(ep['still_path'] as String?, size: 'w780'),
        'duration': runtime != null ? runtime * 60 : 3000,
        'airDate': (ep['air_date'] ?? '').toString(),
      };
    }).toList(growable: false);
  }

  // Get similar TV shows
  Future<List<Map<String, dynamic>>> getSimilarSeries(int tmdbId) async {
    final data = await tmdbFetch('/tv/$tmdbId/similar');
    final list = ((data['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    return list.take(8).map(transformSeries).toList(growable: false);
  }

  // Get movies by genre (for Browse page filter)
  Future<List<Map<String, dynamic>>> getByGenre(
    int genreId, {
    String type = 'movie', // 'movie'|'tv'
  }) async {
    final endpoint = type == 'movie' ? '/discover/movie' : '/discover/tv';
    final data = await tmdbFetch(endpoint, params: {
      'with_genres': genreId.toString(),
      'sort_by': 'popularity.desc',
    });
    final list = ((data['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();

    final mapper = type == 'movie' ? transformMovie : transformSeries;
    final out = <Map<String, dynamic>>[];
    for (final r in list.take(20)) {
      out.add(mapper(r));
    }
    return out;
  }

  // Genre IDs for Camcine filter tabs
  static const genreMap = <String, int>{
    'Action': 28,
    'Drama': 18,
    'Thriller': 53,
    'Comedy': 35,
    'Horror': 27,
    'Sci-Fi': 878,
    'Romance': 10749,
    'Animation': 16,
    'Documentary': 99,
  };

  // Utility for safe clamping sizes used in UI.
  int clampInt(int v, {int min = 0, int max = 999999999}) {
    return math.min(max, math.max(min, v));
  }
}
