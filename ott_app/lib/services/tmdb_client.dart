import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class TmdbClient {
  TmdbClient({
    required this.baseUrl,
    required this.apiKey,
    required this.token,
    http.Client? httpClient,
    this.timeout = const Duration(seconds: 12),
    this.maxRetries = 2,
    this.maxConcurrent = 4,
  }) : _httpClient = httpClient ?? http.Client();

  final String baseUrl;
  final String apiKey;
  final String token;
  final Duration timeout;
  final int maxRetries;
  final int maxConcurrent;
  final http.Client _httpClient;

  int _inFlight = 0;
  final List<Completer<void>> _waiters = <Completer<void>>[];

  static http.Client createDefaultHttpClient({
    Duration connectionTimeout = const Duration(seconds: 12),
  }) {
    final io = HttpClient()
      ..connectionTimeout = connectionTimeout
      ..idleTimeout = const Duration(seconds: 15)
      ..maxConnectionsPerHost = 6;
    return IOClient(io);
  }

  void dispose() {
    _httpClient.close();
  }

  Future<T> _withPermit<T>(Future<T> Function() fn) async {
    if (maxConcurrent <= 0) return fn();
    if (_inFlight >= maxConcurrent) {
      final waiter = Completer<void>();
      _waiters.add(waiter);
      await waiter.future;
    }

    _inFlight++;
    try {
      return await fn();
    } finally {
      _inFlight--;
      if (_waiters.isNotEmpty) {
        _waiters.removeAt(0).complete();
      }
    }
  }

  Future<Map<String, dynamic>> getJson(
    String path, {
    Map<String, String> params = const {},
  }) async {
    final normalizedBase = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final normalizedPath = path.startsWith('/') ? path : '/$path';

    final qp = <String, String>{
      ...params,
      'language': params['language'] ?? 'en-US',
    };
    if (apiKey.trim().isNotEmpty) {
      qp['api_key'] = apiKey.trim();
    }

    final uri = Uri.parse('$normalizedBase$normalizedPath').replace(queryParameters: qp);
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      // Some networks/proxies behave better with an explicit UA.
      'User-Agent': 'CamcineFlutter/1.0 (dart:http)',
      if (token.trim().isNotEmpty) 'Authorization': 'Bearer ${token.trim()}',
    };

    Future<http.Response> attempt() {
      return _withPermit(
        () => _httpClient.get(uri, headers: headers).timeout(timeout),
      );
    }

    var attemptIndex = 0;
    while (true) {
      try {
        final res = await attempt();
        if (res.statusCode < 200 || res.statusCode >= 300) {
          final retryable = res.statusCode == 408 ||
              res.statusCode == 409 ||
              res.statusCode == 429 ||
              res.statusCode >= 500;
          // Retry transient server/rate limit errors.
          if (retryable && attemptIndex < maxRetries) {
            attemptIndex++;
            await Future<void>.delayed(_retryDelay(res, attemptIndex));
            continue;
          }
          throw Exception('TMDB ${res.statusCode}: ${res.body}');
        }
        final decoded = jsonDecode(res.body);
        if (decoded is Map<String, dynamic>) return decoded;
        throw Exception('TMDB: unexpected response shape.');
      } on TimeoutException catch (_) {
        if (attemptIndex >= maxRetries) rethrow;
      } on SocketException catch (_) {
        if (attemptIndex >= maxRetries) rethrow;
      } on http.ClientException catch (_) {
        if (attemptIndex >= maxRetries) rethrow;
      }

      attemptIndex++;
      await Future<void>.delayed(_retryDelay(null, attemptIndex));
    }
  }

  Duration _retryDelay(http.Response? res, int attempt) {
    if (res?.statusCode == 429) {
      final retryAfter = res?.headers['retry-after'];
      final seconds = retryAfter == null ? null : int.tryParse(retryAfter.trim());
      if (seconds != null && seconds > 0) {
        return Duration(seconds: seconds.clamp(1, 10));
      }
    }
    return _backoff(attempt);
  }

  Duration _backoff(int attempt) {
    // 250ms, 500ms, 1s (+small jitter)
    final base = 250 * (1 << (attempt - 1));
    final jitter = (attempt * 37) % 120;
    return Duration(milliseconds: base + jitter);
  }
}
