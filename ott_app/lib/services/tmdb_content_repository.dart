import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/genre.dart';
import '../models/hero_slide.dart';
import '../models/movie.dart';
import 'app_content_repository.dart';
import 'tmdb_client.dart';
import 'tmdb_service.dart';

class TmdbContentRepository implements AppContentRepository {
  TmdbContentRepository({
    required TmdbClient client,
    required String imageBase,
  }) : _service = TmdbService(client: client, imageUrl: imageBase);

  final TmdbService _service;

  List<Movie>? _trendingCache;
  List<Movie>? _popularCache;
  final Map<String, List<Movie>> _genreCache = {};
  final Map<String, Movie?> _detailsCache = {};
  List<Movie>? _popularMoviesCache;
  List<Movie>? _popularSeriesCache;
  List<Movie>? _nowPlayingCache;
  List<Movie>? _featuredCache;

  static const _genres = <Genre>[
    Genre(id: 'action', name: 'Action', icon: 'Sword', color: Color(0xFFA855F7)),
    Genre(id: 'adventure', name: 'Adventure', icon: 'Mountain', color: Color(0xFF44FF88)),
    Genre(id: 'animation', name: 'Animation', icon: 'Palette', color: Color(0xFFFFAA44)),
    Genre(id: 'comedy', name: 'Comedy', icon: 'Laugh', color: Color(0xFFFFDD44)),
    Genre(id: 'crime', name: 'Crime', icon: 'Fingerprint', color: Color(0xFFAA44FF)),
    Genre(id: 'documentary', name: 'Documentary', icon: 'Camera', color: Color(0xFF44AAFF)),
    Genre(id: 'drama', name: 'Drama', icon: 'Theater', color: Color(0xFFD946EF)),
    Genre(id: 'fantasy', name: 'Fantasy', icon: 'Sparkles', color: Color(0xFF44FFDD)),
    Genre(id: 'horror', name: 'Horror', icon: 'Ghost', color: Color(0xFF6D28D9)),
    Genre(id: 'mystery', name: 'Mystery', icon: 'Search', color: Color(0xFF4444FF)),
    Genre(id: 'romance', name: 'Romance', icon: 'Heart', color: Color(0xFFEC4899)),
    Genre(id: 'scifi', name: 'Sci-Fi', icon: 'Rocket', color: Color(0xFF00AAFF)),
    Genre(id: 'thriller', name: 'Thriller', icon: 'AlertTriangle', color: Color(0xFFF59E0B)),
  ];

  static const _genreToTmdbMovieId = <String, int>{
    'action': 28,
    'adventure': 12,
    'animation': 16,
    'comedy': 35,
    'crime': 80,
    'documentary': 99,
    'drama': 18,
    'fantasy': 14,
    'horror': 27,
    'mystery': 9648,
    'romance': 10749,
    'scifi': 878,
    'thriller': 53,
  };

  String? _formatDuration(dynamic rawSeconds) {
    if (rawSeconds == null) return null;
    final seconds = rawSeconds is num ? rawSeconds.toInt() : int.tryParse(rawSeconds.toString());
    if (seconds == null || seconds <= 0) return null;
    final totalMinutes = (seconds / 60).round();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours <= 0) return '${minutes}m';
    if (minutes == 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  Movie _contentToMovie(Map<String, dynamic> c) {
    final id = (c['id'] ?? '').toString();
    final title = (c['title'] ?? '').toString();
    final description = (c['description'] ?? '').toString();
    final type = (c['type'] ?? 'movie').toString();
    final year = (c['releaseYear'] as num?)?.toInt() ?? 2024;
    final poster = (c['poster'] ?? '').toString();
    final backdrop = (c['backdrop'] ?? '').toString();
    final genres = ((c['genres'] as List<dynamic>?) ?? const <dynamic>[])
        .map((e) => e.toString())
        .where((e) => e.trim().isNotEmpty)
        .toList(growable: false);

    final tmdbRatingRaw = c['tmdbRating'];
    final rating10 =
        tmdbRatingRaw == null ? null : double.tryParse(tmdbRatingRaw.toString());
    final normalizedRating =
        rating10 == null ? null : (rating10 / 10.0).clamp(0.0, 1.0);

    final castRaw = (c['cast'] as List<dynamic>?) ?? const <dynamic>[];
    final cast = castRaw
        .whereType<Map<String, dynamic>>()
        .map((m) => (m['name'] ?? '').toString().trim())
        .where((n) => n.isNotEmpty)
        .take(12)
        .toList(growable: false);

    final crewRaw = (c['crew'] as List<dynamic>?) ?? const <dynamic>[];
    final creators = crewRaw
        .whereType<Map<String, dynamic>>()
        .map((m) => (m['name'] ?? '').toString().trim())
        .where((n) => n.isNotEmpty)
        .take(6)
        .toList(growable: false);

    final totalEpisodes = (c['totalEpisodes'] as num?)?.toInt();
    final seasonsRaw = (c['seasons'] as List<dynamic>?) ?? const <dynamic>[];
    final episodes = <Episode>[];
    for (final s in seasonsRaw) {
      if (s is! Map<String, dynamic>) continue;
      final eps = (s['episodes'] as List<dynamic>?) ?? const <dynamic>[];
      for (final ep in eps) {
        if (ep is! Map<String, dynamic>) continue;
        episodes.add(Episode.fromJson(ep));
      }
      if (episodes.isNotEmpty) break; // first season only (best-effort)
    }

    return Movie(
      id: id,
      title: title.isEmpty ? 'Untitled' : title,
      year: year,
      genre: genres.isEmpty ? const ['Drama'] : genres,
      type: type,
      description: description,
      image: poster,
      bannerImage: backdrop.isNotEmpty ? backdrop : poster,
      rating: normalizedRating,
      duration: _formatDuration(c['duration']),
      videoUrl: (c['videoUrl'] ?? '').toString(),
      trailer: (c['trailer'] ?? '').toString(),
      cast: cast,
      creators: creators,
      totalEpisodes: totalEpisodes,
      episodes: episodes,
    );
  }

  @override
  Future<List<Genre>> genres() async {
    return _genres;
  }

  @override
  Future<List<Movie>> trending() async {
    return trendingNow();
  }

  @override
  Future<List<Movie>> featured() async {
    final cached = _featuredCache;
    if (cached != null) return cached;
    final items = await _service.getFeatured();
    final out = items.map(_contentToMovie).toList(growable: false);
    _featuredCache = out;
    return out;
  }

  @override
  Future<List<Movie>> popularMovies() async {
    final cached = _popularMoviesCache;
    if (cached != null) return cached;
    final items = await _service.getPopularMovies();
    final out = items.map(_contentToMovie).toList(growable: false);
    _popularMoviesCache = out;
    return out;
  }

  @override
  Future<List<Movie>> nowPlaying() async {
    final cached = _nowPlayingCache;
    if (cached != null) return cached;
    final items = await _service.getNowPlaying();
    final out = items.map(_contentToMovie).toList(growable: false);
    _nowPlayingCache = out;
    return out;
  }

  @override
  Future<List<Movie>> popularSeries() async {
    final cached = _popularSeriesCache;
    if (cached != null) return cached;
    final items = await _service.getPopularSeries();
    final out = items.map(_contentToMovie).toList(growable: false);
    _popularSeriesCache = out;
    return out;
  }

  @override
  Future<List<HeroSlide>> heroSlides() async {
    final featured = await _service.getFeatured();
    final trending = await _service.getTrending();
    final slides = featured.isNotEmpty ? featured : trending.take(5).toList(growable: false);

    return slides.take(6).map((c) {
      final year = (c['releaseYear'] as num?)?.toInt() ?? 2024;
      final genres = ((c['genres'] as List<dynamic>?) ?? const <dynamic>[])
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .take(2)
          .toList(growable: false);

      return HeroSlide(
        id: 'hero-${c['id']}',
        title: (c['title'] ?? '').toString(),
        meta: '$year | ${genres.join(' | ')}',
        description: (c['description'] ?? '').toString(),
        image: (c['backdrop'] ?? c['poster'] ?? '').toString(),
      );
    }).toList(growable: false);
  }

  @override
  Future<Movie?> contentById(String id) async {
    final cached = _detailsCache[id];
    if (_detailsCache.containsKey(id)) return cached;

    Movie? out;
    Object? failure;
    try {
      if (id.startsWith('movie-')) {
        final tmdbId = int.tryParse(id.substring('movie-'.length));
        if (tmdbId == null) {
          out = null;
        } else {
          final details = await _service.getMovieDetails(tmdbId);
          out = _contentToMovie(details);
        }
      } else if (id.startsWith('series-')) {
        final tmdbId = int.tryParse(id.substring('series-'.length));
        if (tmdbId == null) {
          out = null;
        } else {
          final details = await _service.getSeriesDetails(tmdbId);
          out = _contentToMovie(details);
        }
      } else {
        // Unknown ID format; best-effort search in cached lists.
        final all = await allContent();
        for (final m in all) {
          if (m.id == id) {
            out = m;
            break;
          }
        }
      }
    } catch (e) {
      failure = e;
      if (kDebugMode) {
        debugPrint('TMDB contentById failed for "$id" ($e).');
      }
      out = null;
    }

    // If the network call fails, prefer returning a best-effort object from
    // already loaded lists instead of caching null (so we can retry later).
    if (out == null && failure != null) {
      final fromTrending = _trendingCache?.where((m) => m.id == id).toList();
      if (fromTrending != null && fromTrending.isNotEmpty) return fromTrending.first;
      final fromPopular = _popularCache?.where((m) => m.id == id).toList();
      if (fromPopular != null && fromPopular.isNotEmpty) return fromPopular.first;
      final fromPopularMovies =
          _popularMoviesCache?.where((m) => m.id == id).toList();
      if (fromPopularMovies != null && fromPopularMovies.isNotEmpty) {
        return fromPopularMovies.first;
      }
      final fromPopularSeries =
          _popularSeriesCache?.where((m) => m.id == id).toList();
      if (fromPopularSeries != null && fromPopularSeries.isNotEmpty) {
        return fromPopularSeries.first;
      }
      return null;
    }

    _detailsCache[id] = out;
    return out;
  }

  @override
  Future<List<Movie>> continueWatching() async {
    // TMDB doesn't provide "continue watching" without user playback data.
    return const <Movie>[];
  }

  @override
  Future<List<Movie>> trendingNow() async {
    final cached = _trendingCache;
    if (cached != null) return cached;

    final items = await _service.getTrending();
    final out = items.map(_contentToMovie).toList(growable: false);
    _trendingCache = out;
    return out;
  }

  Future<List<Movie>> _popular() async {
    final cached = _popularCache;
    if (cached != null) return cached;

    final results = await Future.wait([
      _service.getPopularMovies(),
      _service.getPopularSeries(),
    ]);

    final out = [
      ...results[0].map(_contentToMovie),
      ...results[1].map(_contentToMovie),
    ].toList(growable: false);
    _popularCache = out;
    return out;
  }

  @override
  Future<List<Movie>> allContent() async {
    // Used by Browse "All".
    return _popular();
  }

  @override
  Future<List<Movie>> top10() async {
    final trending = await trendingNow();
    return trending.take(10).toList(growable: false);
  }

  @override
  Future<List<Movie>> topBollywood() async {
    // Best-effort "Bollywood-ish" list using Hindi language + India region.
    final data = await _service.tmdbFetch(
      '/discover/movie',
      params: const {
        'sort_by': 'popularity.desc',
        'with_original_language': 'hi',
        'region': 'IN',
        'page': '1',
      },
    );
    final list = ((data['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    return list
        .map(_service.transformMovie)
        .map(_contentToMovie)
        .take(20)
        .toList(growable: false);
  }

  @override
  Future<List<Movie>> indianWebSeries() async {
    final data = await _service.tmdbFetch(
      '/discover/tv',
      params: const {
        'sort_by': 'popularity.desc',
        'with_original_language': 'hi',
        'with_origin_country': 'IN',
        'page': '1',
      },
    );
    final list = ((data['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    return list
        .map(_service.transformSeries)
        .map(_contentToMovie)
        .take(20)
        .toList(growable: false);
  }

  @override
  Future<List<Movie>> topHollywood() async {
    final data = await _service.tmdbFetch(
      '/discover/movie',
      params: const {
        'sort_by': 'popularity.desc',
        'region': 'US',
        'page': '1',
      },
    );
    final list = ((data['results'] as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>();
    return list
        .map(_service.transformMovie)
        .map(_contentToMovie)
        .take(20)
        .toList(growable: false);
  }

  @override
  Future<List<Movie>> genreContent(String genreId) async {
    final cached = _genreCache[genreId];
    if (cached != null) return cached;

    final tmdbId = _genreToTmdbMovieId[genreId];
    if (tmdbId == null) {
      if (kDebugMode) {
        debugPrint('TMDB: unknown genre id "$genreId"; falling back to trending.');
      }
      return trendingNow();
    }

    final results = await Future.wait([
      _service.getByGenre(tmdbId, type: 'movie'),
      _service.getByGenre(tmdbId, type: 'tv'),
    ]);

    final out = [
      ...results[0].map(_contentToMovie).take(18),
      ...results[1].map(_contentToMovie).take(18),
    ].toList(growable: false);
    _genreCache[genreId] = out;
    return out;
  }
}
