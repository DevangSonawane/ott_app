import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum ContentSource { auto, web, tmdb }

class AppEnv {
  static bool _loaded = false;

  static Future<void> load() async {
    if (_loaded) return;
    try {
      await dotenv.load(fileName: '.env');
    } catch (e) {
      if (kDebugMode) {
        debugPrint('AppEnv: .env not loaded ($e).');
      }
    }
    _loaded = true;
  }

  static ContentSource get contentSource {
    final raw = _read('CONTENT_SOURCE').toLowerCase();
    if (raw == 'tmdb') return ContentSource.tmdb;
    if (raw == 'web') return ContentSource.web;
    return ContentSource.auto;
  }

  static String get tmdbApiKey =>
      _readAny(const ['TMDB_API_KEY', 'VITE_TMDB_API_KEY']);
  static String get tmdbToken =>
      _readAny(const ['TMDB_TOKEN', 'VITE_TMDB_TOKEN']);

  static String get tmdbBaseUrl {
    final v = _readAny(const ['TMDB_BASE_URL', 'VITE_TMDB_BASE_URL']);
    return v.isEmpty ? 'https://api.themoviedb.org/3' : v;
  }

  static String get tmdbImageBase {
    final v = _readAny(const ['TMDB_IMAGE_BASE', 'VITE_TMDB_IMAGE_URL']);
    return v.isEmpty ? 'https://image.tmdb.org/t/p' : v;
  }

  static bool get hasTmdbConfig =>
      tmdbApiKey.isNotEmpty || tmdbToken.isNotEmpty;

  static String _readAny(List<String> keys) {
    for (final k in keys) {
      final v = _read(k);
      if (v.isNotEmpty) return v;
    }
    return '';
  }

  static String _read(String key) {
    // Prefer `--dart-define` so secrets don't need to be bundled as assets.
    final fromDefine = switch (key) {
      'CONTENT_SOURCE' =>
        const String.fromEnvironment('CONTENT_SOURCE', defaultValue: ''),
      'TMDB_API_KEY' =>
        const String.fromEnvironment('TMDB_API_KEY', defaultValue: ''),
      'VITE_TMDB_API_KEY' =>
        const String.fromEnvironment('VITE_TMDB_API_KEY', defaultValue: ''),
      'TMDB_TOKEN' => const String.fromEnvironment('TMDB_TOKEN', defaultValue: ''),
      'VITE_TMDB_TOKEN' =>
        const String.fromEnvironment('VITE_TMDB_TOKEN', defaultValue: ''),
      'TMDB_BASE_URL' =>
        const String.fromEnvironment('TMDB_BASE_URL', defaultValue: ''),
      'VITE_TMDB_BASE_URL' =>
        const String.fromEnvironment('VITE_TMDB_BASE_URL', defaultValue: ''),
      'TMDB_IMAGE_BASE' =>
        const String.fromEnvironment('TMDB_IMAGE_BASE', defaultValue: ''),
      'VITE_TMDB_IMAGE_URL' =>
        const String.fromEnvironment('VITE_TMDB_IMAGE_URL', defaultValue: ''),
      _ => '',
    };
    if (fromDefine.trim().isNotEmpty) return fromDefine.trim();
    return (dotenv.env[key] ?? '').trim();
  }
}
