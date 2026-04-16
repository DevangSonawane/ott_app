import '../models/genre.dart';
import '../models/hero_slide.dart';
import '../models/movie.dart';
import 'app_content_repository.dart';
import 'web_content_repository.dart';

class WebAssetContentRepository implements AppContentRepository {
  @override
  Future<List<HeroSlide>> heroSlides() async {
    final web = await WebContentRepository.load();
    return web.heroSlides;
  }

  @override
  Future<Movie?> contentById(String id) async {
    final all = (await WebContentRepository.load()).allMovies;
    for (final m in all) {
      if (m.id == id) return m;
    }
    return null;
  }

  @override
  Future<List<Movie>> trending() async {
    return (await WebContentRepository.load()).trendingNow;
  }

  @override
  Future<List<Movie>> featured() async {
    // Best-effort mapping for the asset-backed dataset.
    return (await WebContentRepository.load()).top10;
  }

  @override
  Future<List<Movie>> popularMovies() async {
    final web = await WebContentRepository.load();
    final movies = web.topHollywood.where((m) => m.type == 'movie');
    return movies.isEmpty
        ? web.trendingNow.where((m) => m.type == 'movie').toList(growable: false)
        : movies.toList(growable: false);
  }

  @override
  Future<List<Movie>> nowPlaying() async {
    // Closest match in the bundled dataset.
    return (await WebContentRepository.load()).newReleases;
  }

  @override
  Future<List<Movie>> popularSeries() async {
    final web = await WebContentRepository.load();
    final series = web.trendingNow.where((m) => m.type == 'series');
    return series.isEmpty
        ? web.indianWebSeries.where((m) => m.type == 'series').toList(growable: false)
        : series.toList(growable: false);
  }

  @override
  Future<List<Movie>> continueWatching() async {
    return (await WebContentRepository.load()).continueWatching;
  }

  @override
  Future<List<Movie>> topBollywood() async {
    return (await WebContentRepository.load()).topBollywood;
  }

  @override
  Future<List<Movie>> indianWebSeries() async {
    return (await WebContentRepository.load()).indianWebSeries;
  }

  @override
  Future<List<Movie>> topHollywood() async {
    return (await WebContentRepository.load()).topHollywood;
  }

  @override
  Future<List<Movie>> top10() async {
    return (await WebContentRepository.load()).top10;
  }

  @override
  Future<List<Movie>> trendingNow() async {
    return (await WebContentRepository.load()).trendingNow;
  }

  @override
  Future<List<Movie>> allContent() async {
    return (await WebContentRepository.load()).allMovies;
  }

  @override
  Future<List<Genre>> genres() async {
    return (await WebContentRepository.load()).genres;
  }

  @override
  Future<List<Movie>> genreContent(String genreId) async {
    final web = await WebContentRepository.load();
    return web.genreContent[genreId] ?? web.trendingNow;
  }
}
