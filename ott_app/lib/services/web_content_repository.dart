import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/genre.dart';
import '../models/hero_slide.dart';
import '../models/movie.dart';
import '../models/subscription_plan.dart';
import '../models/user_profile.dart';

class WebContent {
  const WebContent({
    required this.heroSlides,
    required this.continueWatching,
    required this.trendingNow,
    required this.top10,
    required this.topBollywood,
    required this.indianWebSeries,
    required this.topHollywood,
    required this.newReleases,
    required this.profiles,
    required this.subscriptionPlans,
    required this.genres,
    required this.genreContent,
  });

  final List<HeroSlide> heroSlides;
  final List<Movie> continueWatching;
  final List<Movie> trendingNow;
  final List<Movie> top10;
  final List<Movie> topBollywood;
  final List<Movie> indianWebSeries;
  final List<Movie> topHollywood;
  final List<Movie> newReleases;
  final List<UserProfile> profiles;
  final List<SubscriptionPlan> subscriptionPlans;
  final List<Genre> genres;
  final Map<String, List<Movie>> genreContent;

  List<Movie> get allMovies {
    final set = <String, Movie>{};
    for (final list in [
      continueWatching,
      trendingNow,
      top10,
      topBollywood,
      indianWebSeries,
      topHollywood,
      newReleases,
      ...genreContent.values,
    ]) {
      for (final m in list) {
        set[m.id] = m;
      }
    }
    return set.values.toList(growable: false);
  }
}

class WebContentRepository {
  static WebContent? _cache;

  static Future<WebContent> load() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await rootBundle.loadString('public/content.json');
    final data = jsonDecode(raw) as Map<String, dynamic>;

    final content = WebContent(
      heroSlides: _list(data['heroSlides'], _heroSlideFromJson),
      continueWatching: _list(data['continueWatching'], _movieFromJson),
      trendingNow: _list(data['trendingNow'], _movieFromJson),
      top10: _list(data['top10'], _movieFromJson),
      topBollywood: _list(data['topBollywood'], _movieFromJson),
      indianWebSeries: _list(data['indianWebSeries'], _movieFromJson),
      topHollywood: _list(data['topHollywood'], _movieFromJson),
      newReleases: _list(data['newReleases'], _movieFromJson),
      profiles: _list(data['profiles'], _profileFromJson),
      subscriptionPlans: _list(data['subscriptionPlans'], _planFromJson),
      genres: _list(data['genres'], _genreFromJson),
      genreContent: _genreContentFromJson(
        (data['genreContent'] as Map<String, dynamic>?) ?? const {},
      ),
    );

    _cache = content;
    return content;
  }

  static List<T> _list<T>(
    dynamic value,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    return ((value as List<dynamic>?) ?? const <dynamic>[])
        .cast<Map<String, dynamic>>()
        .map(fromJson)
        .toList(growable: false);
  }

  static String _assetPath(String webPath) {
    final trimmed = webPath.startsWith('/') ? webPath.substring(1) : webPath;
    return 'public/$trimmed';
  }

  static HeroSlide _heroSlideFromJson(Map<String, dynamic> j) {
    return HeroSlide(
      id: j['id'].toString(),
      title: (j['title'] ?? '') as String,
      meta: (j['meta'] ?? '') as String,
      description: (j['description'] ?? '') as String,
      image: _assetPath((j['image'] ?? '') as String),
    );
  }

  static Movie _movieFromJson(Map<String, dynamic> j) {
    final ratingRaw = j['rating'];
    final ratingNum = ratingRaw is num ? ratingRaw.toDouble() : null;
    final normalizedRating =
        ratingNum == null ? null : (ratingNum > 1 ? ratingNum / 10 : ratingNum);

    return Movie(
      id: (j['id'] ?? '').toString(),
      title: (j['title'] ?? '') as String,
      year: (j['year'] as num?)?.toInt() ?? 2020,
      genre: ((j['genre'] as List<dynamic>?) ?? const <dynamic>[])
          .cast<String>()
          .toList(growable: false),
      type: (j['type'] ?? 'movie') as String,
      description: (j['description'] ?? '') as String,
      image: _assetPath((j['image'] ?? '') as String),
      rating: normalizedRating,
      progress: (j['progress'] as num?)?.toInt(),
      episodeInfo: j['episodeInfo'] == null
          ? null
          : EpisodeInfo(
              season:
                  ((j['episodeInfo'] as Map<String, dynamic>)['season'] as num)
                      .toInt(),
              episode:
                  ((j['episodeInfo'] as Map<String, dynamic>)['episode'] as num)
                      .toInt(),
              episodeTitle: ((j['episodeInfo']
                      as Map<String, dynamic>)['episodeTitle'] as String?) ??
                  '',
            ),
    );
  }

  static UserProfile _profileFromJson(Map<String, dynamic> j) {
    return UserProfile(
      id: j['id'].toString(),
      name: (j['name'] ?? '') as String,
      avatar: (j['avatar'] ?? '') as String,
      isKids: (j['isKids'] as bool?) ?? false,
    );
  }

  static SubscriptionPlan _planFromJson(Map<String, dynamic> j) {
    return SubscriptionPlan(
      id: j['id'].toString(),
      name: (j['name'] ?? '') as String,
      price: (j['price'] as num?)?.toInt() ?? 0,
      period: (j['period'] ?? '') as String,
      features: ((j['features'] as List<dynamic>?) ?? const <dynamic>[])
          .cast<String>()
          .toList(growable: false),
      isPopular: (j['isPopular'] as bool?) ?? false,
    );
  }

  static Genre _genreFromJson(Map<String, dynamic> j) {
    return Genre(
      id: (j['id'] ?? '') as String,
      name: (j['name'] ?? '') as String,
      icon: (j['icon'] ?? '') as String,
      color: _parseHexColor((j['color'] ?? '#ffffff') as String),
    );
  }

  static Map<String, List<Movie>> _genreContentFromJson(
      Map<String, dynamic> j) {
    final out = <String, List<Movie>>{};
    for (final entry in j.entries) {
      out[entry.key] = _list(entry.value, _movieFromJson);
    }
    return out;
  }

  static Color _parseHexColor(String input) {
    var hex = input.trim();
    if (hex.startsWith('#')) hex = hex.substring(1);
    if (hex.length == 3) {
      hex = '${hex[0]}${hex[0]}${hex[1]}${hex[1]}${hex[2]}${hex[2]}';
    }
    if (hex.length == 6) hex = 'FF$hex';
    final value = int.tryParse(hex, radix: 16) ?? 0xFFFFFFFF;
    return Color(value);
  }
}
