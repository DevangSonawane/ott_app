import '../models/genre.dart';
import '../models/hero_slide.dart';
import '../models/movie.dart';

abstract class AppContentRepository {
  Future<List<HeroSlide>> heroSlides();
  Future<Movie?> contentById(String id);

  // Home dashboard sections (React parity).
  Future<List<Movie>> trending();
  Future<List<Movie>> featured();
  Future<List<Movie>> popularMovies();
  Future<List<Movie>> nowPlaying();
  Future<List<Movie>> popularSeries();

  Future<List<Movie>> continueWatching();
  Future<List<Movie>> topBollywood();
  Future<List<Movie>> indianWebSeries();
  Future<List<Movie>> topHollywood();
  Future<List<Movie>> top10();
  Future<List<Movie>> trendingNow();
  Future<List<Movie>> allContent();
  Future<List<Genre>> genres();
  Future<List<Movie>> genreContent(String genreId);
}
