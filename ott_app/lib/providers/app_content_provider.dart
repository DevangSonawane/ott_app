import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/hero_slide.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import '../env/app_env.dart';
import '../services/app_content_repository.dart';
import '../services/tmdb_client.dart';
import '../services/tmdb_content_repository.dart';
import '../services/web_asset_content_repository.dart';

const fallbackHeroSlide = HeroSlide(
  id: 'fallback-1',
  title: 'Camcine Originals',
  meta: 'Trending now',
  description: 'Premium content, now streaming.',
  image: '',
);

final appContentRepositoryProvider = Provider<AppContentRepository>((ref) {
  final web = WebAssetContentRepository();
  final apiKey = AppEnv.tmdbApiKey;
  final token = AppEnv.tmdbToken;
  final hasTmdb = apiKey.isNotEmpty || token.isNotEmpty;

  // Default behavior: use TMDB when configured.
  // Use `CONTENT_SOURCE=web` to force the bundled web asset dataset.
  final source = AppEnv.contentSource;
  if (source == ContentSource.web) return web;
  if (!hasTmdb) return web;

  return TmdbContentRepository(
    client: TmdbClient(
      baseUrl: AppEnv.tmdbBaseUrl,
      apiKey: apiKey,
      token: token,
      httpClient: TmdbClient.createDefaultHttpClient(
        connectionTimeout: const Duration(seconds: 20),
      ),
      timeout: const Duration(seconds: 20),
      maxRetries: 4,
    ),
    imageBase: AppEnv.tmdbImageBase,
  );
});

final heroSlidesProvider = FutureProvider<List<HeroSlide>>((ref) async {
  final repo = ref.watch(appContentRepositoryProvider);
  final slides = await repo.heroSlides();
  return slides.isEmpty ? const [fallbackHeroSlide] : slides;
});

final continueWatchingProvider = FutureProvider<List<Movie>>((ref) async {
  return (await ref.watch(appContentRepositoryProvider).continueWatching());
});

final bollywoodProvider = FutureProvider<List<Movie>>((ref) async {
  return (await ref.watch(appContentRepositoryProvider).topBollywood());
});

final indianSeriesProvider = FutureProvider<List<Movie>>((ref) async {
  return (await ref.watch(appContentRepositoryProvider).indianWebSeries());
});

final hollywoodProvider = FutureProvider<List<Movie>>((ref) async {
  return (await ref.watch(appContentRepositoryProvider).topHollywood());
});

final trendingTvProvider = FutureProvider<List<Movie>>((ref) async {
  final trending = await ref.watch(appContentRepositoryProvider).trendingNow();
  return trending
      .where((m) => m.type == 'series')
      .toList(growable: false);
});

final top10Provider = FutureProvider<List<Movie>>((ref) async {
  final trending = await ref.watch(appContentRepositoryProvider).trending();
  return trending.take(10).toList(growable: false);
});

final dramaProvider = FutureProvider<List<Movie>>((ref) async {
  return (await ref.watch(appContentRepositoryProvider).genreContent('drama'));
});

final actionProvider = FutureProvider<List<Movie>>((ref) async {
  return (await ref.watch(appContentRepositoryProvider).genreContent('action'));
});

final genreContentProvider =
    FutureProvider.family<List<Movie>, String>((ref, genreId) async {
  return (await ref.watch(appContentRepositoryProvider).genreContent(genreId));
});

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider);

  if (query.trim().isEmpty) {
    return (await ref.watch(appContentRepositoryProvider).trendingNow());
  }

  final q = query.trim().toLowerCase();
  final all = await ref.watch(appContentRepositoryProvider).allContent();
  return all
      .where((m) =>
          m.title.toLowerCase().contains(q) ||
          m.genre.any((g) => g.toLowerCase().contains(q)))
      .toList(growable: false);
});

final allContentProvider = FutureProvider<List<Movie>>((ref) async {
  return (await ref.watch(appContentRepositoryProvider).allContent());
});

// Home dashboard providers (React parity sections).
final trendingProvider = FutureProvider<List<Movie>>((ref) async {
  final items = await ref.watch(appContentRepositoryProvider).trending();
  return items.toList(growable: false);
});

final featuredProvider = FutureProvider<List<Movie>>((ref) async {
  final items = await ref.watch(appContentRepositoryProvider).featured();
  return items.take(8).toList(growable: false);
});

final popularMoviesProvider = FutureProvider<List<Movie>>((ref) async {
  final items = await ref.watch(appContentRepositoryProvider).popularMovies();
  return items.take(12).toList(growable: false);
});

final nowPlayingProvider = FutureProvider<List<Movie>>((ref) async {
  final items = await ref.watch(appContentRepositoryProvider).nowPlaying();
  return items.take(12).toList(growable: false);
});

final tvSeriesProvider = FutureProvider<List<Movie>>((ref) async {
  final items = await ref.watch(appContentRepositoryProvider).popularSeries();
  return items.take(12).toList(growable: false);
});

final spotlightPickProvider = FutureProvider<Movie?>((ref) async {
  final featured = await ref.watch(appContentRepositoryProvider).featured();
  if (featured.length >= 2) return featured[1];
  if (featured.isNotEmpty) return featured.first;

  final popular = await ref.watch(appContentRepositoryProvider).popularMovies();
  if (popular.isNotEmpty) return popular.first;

  final trending = await ref.watch(appContentRepositoryProvider).trending();
  if (trending.isNotEmpty) return trending.first;
  return null;
});

final genresProvider = FutureProvider<List<Genre>>((ref) async {
  return (await ref.watch(appContentRepositoryProvider).genres());
});

final contentByIdProvider =
    FutureProvider.family<Movie?, String>((ref, id) async {
  return (await ref.watch(appContentRepositoryProvider).contentById(id));
});
