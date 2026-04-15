import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/hero_slide.dart';
import '../models/genre.dart';
import '../models/movie.dart';
import '../services/web_content_repository.dart';

const fallbackHeroSlide = HeroSlide(
  id: 'fallback-1',
  title: 'Camcine Originals',
  meta: 'Trending now',
  description: 'Premium content, now streaming.',
  image: '',
);

final heroSlidesProvider = FutureProvider<List<HeroSlide>>((ref) async {
  final web = await WebContentRepository.load();
  return web.heroSlides.isEmpty ? const [fallbackHeroSlide] : web.heroSlides;
});

final continueWatchingProvider = FutureProvider<List<Movie>>((ref) async {
  return (await WebContentRepository.load()).continueWatching;
});

final bollywoodProvider = FutureProvider<List<Movie>>((ref) async {
  return (await WebContentRepository.load()).topBollywood;
});

final indianSeriesProvider = FutureProvider<List<Movie>>((ref) async {
  return (await WebContentRepository.load()).indianWebSeries;
});

final hollywoodProvider = FutureProvider<List<Movie>>((ref) async {
  return (await WebContentRepository.load()).topHollywood;
});

final trendingTvProvider = FutureProvider<List<Movie>>((ref) async {
  final web = await WebContentRepository.load();
  return web.trendingNow
      .where((m) => m.type == 'series')
      .toList(growable: false);
});

final top10Provider = FutureProvider<List<Movie>>((ref) async {
  return (await WebContentRepository.load()).top10;
});

final dramaProvider = FutureProvider<List<Movie>>((ref) async {
  final web = await WebContentRepository.load();
  return web.genreContent['drama'] ?? const <Movie>[];
});

final actionProvider = FutureProvider<List<Movie>>((ref) async {
  final web = await WebContentRepository.load();
  return web.genreContent['action'] ?? const <Movie>[];
});

final genreContentProvider =
    FutureProvider.family<List<Movie>, String>((ref, genreId) async {
  final web = await WebContentRepository.load();
  return web.genreContent[genreId] ?? web.trendingNow;
});

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider);

  if (query.trim().isEmpty) {
    return (await WebContentRepository.load()).trendingNow;
  }

  final web = await WebContentRepository.load();
  final q = query.trim().toLowerCase();
  return web.allMovies
      .where((m) =>
          m.title.toLowerCase().contains(q) ||
          m.genre.any((g) => g.toLowerCase().contains(q)))
      .toList(growable: false);
});

final allContentProvider = FutureProvider<List<Movie>>((ref) async {
  return (await WebContentRepository.load()).allMovies;
});

final genresProvider = FutureProvider<List<Genre>>((ref) async {
  final web = await WebContentRepository.load();
  return web.genres;
});

final contentByIdProvider =
    FutureProvider.family<Movie?, String>((ref, id) async {
  final all = await ref.watch(allContentProvider.future);
  for (final m in all) {
    if (m.id == id) return m;
  }
  return null;
});
