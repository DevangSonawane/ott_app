# Flutter StreamFlix — Complete UI Overhaul + Real TMDB Data
## Codex Master Prompt (Paste Verbatim)

> You are an expert Flutter/Dart engineer. Below is the **complete current codebase** of a Flutter OTT streaming app. Your job is to:
> 1. **Fix every overflow, clipping, and layout bug** listed below
> 2. **Elevate every screen to premium, modern, production-grade UI** (think Netflix × Apple TV+ quality)
> 3. **Replace all picsum.photos placeholder images with real TMDB API data** (real movie posters, backdrops, titles, descriptions, ratings)
> 4. **Make every pixel intentional** — proper safe areas, proper padding, no clipping, no overflow

---

## PART 1 — CRITICAL BUG FIXES (Fix ALL of these)

### Bug 1: ContentCard overflow (top10 variant)
**File:** `lib/widgets/content_card.dart`
**Problem:** `_RankNumber` is positioned with `left: -34, bottom: -26` and `Stack(clipBehavior: Clip.none)` — the rank number is clipped by the parent `ListView` / `ContentRow` SizedBox boundary, making it invisible or partially cut off.
**Fix:**
- In `ContentRow`, for `top10` variant change the list height from `240` to `280` and add `padding: EdgeInsets.only(bottom: 30, left: 40)` to the ListView
- In `ContentCard` for `top10`, increase card width from `140` to `160` and add `clipBehavior: Clip.none` on the outermost SizedBox wrapper
- Wrap the entire `ContentRow` `SizedBox` in `OverflowBox(maxHeight: 290)` for top10 variant only to allow the rank overflow to render

### Bug 2: HeroSlider CTAs overflow on small screens
**File:** `lib/widgets/hero_slider.dart` — `_HeroSlideContent` `_ctaWhite`/`_ctaGhost` buttons
**Problem:** On phones < 375px wide, the 3 CTA buttons in a `Row` (Watch Now + Add to List + More Info) overflow horizontally. Each button has `padding: symmetric(horizontal: 14)` and the labels are "Watch Now", "Add to List", "More Info" — they don't fit on one row on small devices.
**Fix:**
- Replace the `Row` with `Wrap(spacing: 8, runSpacing: 8)` so buttons naturally wrap to the next line
- Make "More Info" an icon-only button (no text label) on screens < 360px using `LayoutBuilder`

### Bug 3: HomeScreen negative transform causes layout gap
**File:** `lib/screens/home_screen.dart`
**Problem:** `Transform.translate(offset: Offset(0, -128))` on the "Continue Watching" `SliverToBoxAdapter` pulls the widget up visually but does NOT reduce its layout height — this leaves a 128px empty gap between ContentRows.
**Fix:** Replace the Transform.translate approach entirely. Instead, use a `Stack` at the top of the `CustomScrollView` with:
```dart
SliverToBoxAdapter(
  child: Stack(
    children: [
      SizedBox(height: MediaQuery.of(context).size.height), // hero
      Positioned(
        bottom: 0,
        left: 0, right: 0,
        child: ContentRow(...continueWatching...),
      ),
    ],
  ),
),
```
This makes the Continue Watching row correctly overlap the bottom of the hero.

### Bug 4: ContentRow filter pills overflow
**File:** `lib/widgets/content_row.dart`
**Problem:** The `Row` containing title + filter pills (`_pill` widgets for "All", "Movies", "TV Shows") overflows on phones because the title is `Expanded` but the pills Row is not constrained. On narrow screens the pills wrap outside the available space.
**Fix:**
- Wrap the entire header in a `Column` (not Row) on screens < 400px — show pills below the title
- On wider screens keep the current Row layout
- Use `LayoutBuilder` inside the header padding to decide layout mode

### Bug 5: Bottom nav covers content
**File:** `lib/widgets/app_shell.dart` and all `CustomScrollView` screens
**Problem:** The `BottomNavBar` overlays the bottom of scrollable content — the last items in lists are hidden behind the nav bar. No `MediaQuery.padding.bottom` compensation.
**Fix:**
- Add `SliverPadding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 80))` as the LAST sliver in every `CustomScrollView` (HomeScreen, GenreScreen, SearchScreen)
- In `SearchScreen`, add `padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 80)` to the `GridView.builder`

### Bug 6: TopNavBar SafeArea double-counts on iOS
**File:** `lib/widgets/top_nav_bar.dart`
**Problem:** The `TopNavBar` uses `SafeArea(bottom: false)` which adds top padding. The `AppShell` renders it in a `Positioned(top:0)` Stack — on iOS with notch, the content inside the nav bar gets double-padded and the nav height of `70` doesn't account for the status bar.
**Fix:**
- Remove `SafeArea` from inside `TopNavBar`
- Change nav height to: `MediaQuery.of(context).padding.top + 70`
- Use `Padding(padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top))` inside the nav content

### Bug 7: MovieDetailModal Hero tag conflict
**File:** `lib/widgets/movie_detail_modal.dart` and `lib/widgets/content_card.dart`
**Problem:** Every `ContentCard` wraps its image in `Hero(tag: 'movie-${content.id}')`. The modal also uses the same `Hero` tag. When the modal is open AND the same movie appears in "Similar Movies" scroll, Flutter throws a Hero tag collision error.
**Fix:**
- In `_MovieDetailBody`, the thumbnail should use `Hero(tag: 'modal-${movie.id}')` (prefix with 'modal-')
- In `ContentCard`, keep `Hero(tag: 'movie-${content.id}')` 
- In the Similar Movies list inside modal, use a plain `CachedNetworkImage` with NO Hero wrapper

### Bug 8: SearchScreen top padding hides behind TopNavBar
**File:** `lib/screens/search_screen.dart`
**Problem:** The `SearchScreen` uses `padding: EdgeInsets.fromLTRB(16, 90, 16, 16)` hardcoded — on devices with tall notches (iPhone 14 Pro: 59px top safe area) the 90px isn't enough and content overlaps the nav bar. On Android it may add too much gap.
**Fix:** Replace `90` with `MediaQuery.of(context).padding.top + 70 + 16` (dynamic)

### Bug 9: SideNavBar renders on mobile in AppShell
**File:** `lib/widgets/app_shell.dart`
**Problem:** `SideNavBar` uses `AnimatedContainer` width 0 when hidden but still takes up layout space with `Row` layout, pushing content on mobile.
**Fix:** Use `if (isTablet) const SideNavBar()` (already done) but ensure `isTablet` uses the actual `constraints.maxWidth`, not a cached value that might not update on orientation change. Use `OrientationBuilder` or pass constraints directly.

### Bug 10: ContentCard scale transform direction
**File:** `lib/widgets/content_card.dart`
**Problem:** `_pressed ? 1.05 : 1.0` scales UP on press — this is backwards from native mobile feel (should scale DOWN slightly, 0.96). The current scale-up on press makes it feel like the card is "jumping" rather than being pressed.
**Fix:** Change to `_pressed ? 0.96 : 1.0`

### Bug 11: ShimmerPlaceholder highlight color wrong
**File:** `lib/widgets/shimmer_placeholder.dart`
**Problem:** `highlightColor: AppColors.card.withOpacity(0.5)` produces a semi-transparent highlight on a dark card — it looks muddy/invisible. The shimmer effect is not visible.
**Fix:**
```dart
baseColor: const Color(0xFF1A1A1A),
highlightColor: const Color(0xFF2A2A2A),
```

### Bug 12: GradientButton inside GradientButton wraps with fadeIn animation on every rebuild
**File:** `lib/widgets/gradient_button.dart`
**Problem:** `GradientButton` always runs `.animate().fadeIn()` — if this button is inside a `setState` widget (like `SubscriptionScreen` plan selector), it re-animates on every selection change, causing a flicker.
**Fix:** Add `key: ValueKey(label)` to the `GradientButton` and remove the `.animate()` wrapper. Add a press-scale effect instead using `GestureDetector` + `AnimatedScale`.

---

## PART 2 — REAL TMDB DATA INTEGRATION

### Step 1: Add dependencies to pubspec.yaml
```yaml
dependencies:
  http: ^1.2.1
  flutter_dotenv: ^5.1.0
```

### Step 2: Create `.env` file in project root
```
TMDB_API_KEY=YOUR_KEY_HERE
TMDB_BASE_URL=https://api.themoviedb.org/3
TMDB_IMAGE_BASE=https://image.tmdb.org/t/p
```
In `main.dart` add: `await dotenv.load(fileName: '.env');`
In `pubspec.yaml` assets section add: `- .env`

### Step 3: Create `lib/services/tmdb_service.dart`

```dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/movie.dart';
import '../models/hero_slide.dart';

class TmdbService {
  static final _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';
  static const _base = 'https://api.themoviedb.org/3';
  static const _img = 'https://image.tmdb.org/t/p';

  // Image URL helpers
  static String poster(String? path, {String size = 'w500'}) {
    if (path == null || path.isEmpty) return 'https://picsum.photos/seed/fallback/600/900';
    return '$_img/$size$path';
  }

  static String backdrop(String? path, {String size = 'w1280'}) {
    if (path == null || path.isEmpty) return 'https://picsum.photos/seed/fallback/1280/720';
    return '$_img/$size$path';
  }

  static Map<String, String> get _headers => {
    'Authorization': 'Bearer $_apiKey',
    'Content-Type': 'application/json',
  };

  // Convert genre IDs to genre name strings
  static final _genreMap = <int, String>{
    28: 'Action', 12: 'Adventure', 16: 'Animation', 35: 'Comedy',
    80: 'Crime', 99: 'Documentary', 18: 'Drama', 10751: 'Family',
    14: 'Fantasy', 36: 'History', 27: 'Horror', 10402: 'Music',
    9648: 'Mystery', 10749: 'Romance', 878: 'Sci-Fi', 10770: 'TV Movie',
    53: 'Thriller', 10752: 'War', 37: 'Western',
    // TV genres
    10759: 'Action', 10762: 'Kids', 10763: 'News', 10764: 'Reality',
    10765: 'Sci-Fi', 10766: 'Soap', 10767: 'Talk', 10768: 'War',
  };

  static List<String> _genres(List<dynamic> ids) {
    return ids
        .cast<int>()
        .map((id) => _genreMap[id] ?? 'Drama')
        .take(3)
        .toList();
  }

  // Fetch and convert a TMDB movie result to our Movie model
  static Movie _movieFromJson(Map<String, dynamic> j) {
    final isMovie = j.containsKey('release_date');
    return Movie(
      id: j['id'].toString(),
      title: (j['title'] ?? j['name'] ?? 'Unknown') as String,
      year: int.tryParse(
              ((j['release_date'] ?? j['first_air_date'] ?? '2020') as String)
                  .split('-')
                  .first) ??
          2020,
      genre: _genres((j['genre_ids'] as List<dynamic>?) ?? []),
      type: isMovie ? 'movie' : 'series',
      description: (j['overview'] ?? '') as String,
      image: poster(j['poster_path'] as String?),
      rating: ((j['vote_average'] as num?) ?? 0) / 10,
      duration: isMovie ? '2h 0m' : null,
    );
  }

  // Fetch hero slides from trending/week (gets backdrop images)
  static Future<List<HeroSlide>> fetchHeroSlides() async {
    try {
      final uri = Uri.parse('$_base/trending/all/week?language=en-US&page=1');
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return _fallbackHeroSlides();
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      final results = (data['results'] as List<dynamic>).take(5).toList();
      return results.map<HeroSlide>((j) {
        final isMovie = j.containsKey('release_date');
        final genreNames = _genres((j['genre_ids'] as List<dynamic>?) ?? []);
        final year = ((j['release_date'] ?? j['first_air_date'] ?? '2020') as String).split('-').first;
        return HeroSlide(
          id: j['id'].toString(),
          title: (j['title'] ?? j['name'] ?? '') as String,
          meta: '$year | ${genreNames.join(' | ')}',
          description: (j['overview'] ?? '') as String,
          image: backdrop(j['backdrop_path'] as String?),
        );
      }).toList();
    } catch (_) {
      return _fallbackHeroSlides();
    }
  }

  // Trending movies for "Top Hollywood" and general trending
  static Future<List<Movie>> fetchTrending({String type = 'movie'}) async {
    try {
      final uri = Uri.parse('$_base/trending/$type/week?language=en-US');
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return [];
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(_movieFromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Top-rated movies for "Top 10" lists
  static Future<List<Movie>> fetchTopRated({String type = 'movie', String region = 'IN'}) async {
    try {
      final uri = Uri.parse(
          '$_base/$type/top_rated?language=en-US&region=$region&page=1');
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return [];
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(_movieFromJson)
          .take(10)
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Discover movies by genre
  static Future<List<Movie>> fetchByGenre(int genreId, {String type = 'movie'}) async {
    try {
      final uri = Uri.parse(
          '$_base/discover/$type?with_genres=$genreId&language=en-US&sort_by=popularity.desc&page=1');
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return [];
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(_movieFromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Bollywood movies (Hindi language movies from India)
  static Future<List<Movie>> fetchBollywood() async {
    try {
      final uri = Uri.parse(
          '$_base/discover/movie?with_original_language=hi&region=IN&sort_by=popularity.desc&page=1');
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return [];
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(_movieFromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Indian web series (Hindi TV shows)
  static Future<List<Movie>> fetchIndianSeries() async {
    try {
      final uri = Uri.parse(
          '$_base/discover/tv?with_original_language=hi&sort_by=popularity.desc&page=1');
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return [];
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(_movieFromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Now playing / currently airing (for Continue Watching)
  static Future<List<Movie>> fetchNowPlaying() async {
    try {
      final uri = Uri.parse('$_base/movie/now_playing?language=en-US&region=IN&page=1');
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return [];
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map((j) {
            final m = _movieFromJson(j);
            // Add fake progress for "continue watching"
            final progress = 20 + (m.id.hashCode.abs() % 70);
            return m.copyWith(progress: progress);
          })
          .take(8)
          .toList();
    } catch (_) {
      return [];
    }
  }

  // Search
  static Future<List<Movie>> search(String query) async {
    if (query.trim().isEmpty) return [];
    try {
      final uri = Uri.parse(
          '$_base/search/multi?query=${Uri.encodeComponent(query)}&language=en-US&page=1');
      final res = await http.get(uri, headers: _headers);
      if (res.statusCode != 200) return [];
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      return (data['results'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .where((j) => j['media_type'] == 'movie' || j['media_type'] == 'tv')
          .map(_movieFromJson)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static List<HeroSlide> _fallbackHeroSlides() => [
    const HeroSlide(
      id: 'fallback-1',
      title: 'StreamFlix Originals',
      meta: '2024 | Action | Drama',
      description: 'Premium content, now streaming.',
      image: 'https://picsum.photos/seed/hero1/1280/720',
    ),
  ];
}
```

### Step 4: Create `lib/providers/tmdb_provider.dart`

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/movie.dart';
import '../models/hero_slide.dart';
import '../services/tmdb_service.dart';

// TMDB genre IDs
const _kAction = 28;
const _kDrama = 18;
const _kRomance = 10749;
const _kScifi = 878;
const _kThriller = 53;
const _kHorror = 27;
const _kComedy = 35;

// Hero slides
final heroSlidesProvider = FutureProvider<List<HeroSlide>>((ref) async {
  return TmdbService.fetchHeroSlides();
});

// Continue watching (now playing + fake progress)
final continueWatchingProvider = FutureProvider<List<Movie>>((ref) async {
  return TmdbService.fetchNowPlaying();
});

// Top Bollywood
final bollywoodProvider = FutureProvider<List<Movie>>((ref) async {
  return TmdbService.fetchBollywood();
});

// Indian web series
final indianSeriesProvider = FutureProvider<List<Movie>>((ref) async {
  return TmdbService.fetchIndianSeries();
});

// Top Hollywood (trending movies)
final hollywoodProvider = FutureProvider<List<Movie>>((ref) async {
  return TmdbService.fetchTrending(type: 'movie');
});

// Top 10 in India (top rated, IN region)
final top10Provider = FutureProvider<List<Movie>>((ref) async {
  return TmdbService.fetchTopRated(type: 'movie', region: 'IN');
});

// Drama series
final dramaProvider = FutureProvider<List<Movie>>((ref) async {
  return TmdbService.fetchByGenre(_kDrama, type: 'tv');
});

// Action
final actionProvider = FutureProvider<List<Movie>>((ref) async {
  return TmdbService.fetchByGenre(_kAction);
});

// Genre content providers
final genreContentProvider = FutureProvider.family<List<Movie>, String>((ref, genreId) async {
  switch (genreId) {
    case 'action': return TmdbService.fetchByGenre(_kAction);
    case 'drama': return TmdbService.fetchByGenre(_kDrama, type: 'tv');
    case 'romance': return TmdbService.fetchByGenre(_kRomance);
    case 'scifi': return TmdbService.fetchByGenre(_kScifi);
    case 'thriller': return TmdbService.fetchByGenre(_kThriller);
    case 'horror': return TmdbService.fetchByGenre(_kHorror);
    case 'comedy': return TmdbService.fetchByGenre(_kComedy);
    default: return TmdbService.fetchTrending();
  }
});

// Search
final searchQueryProvider = StateProvider<String>((ref) => '');
final searchResultsProvider = FutureProvider<List<Movie>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return TmdbService.fetchTrending();
  return TmdbService.search(query);
});

// All content for similarity matching
final allTmdbContentProvider = FutureProvider<List<Movie>>((ref) async {
  final results = await Future.wait([
    TmdbService.fetchTrending(type: 'movie'),
    TmdbService.fetchTrending(type: 'tv'),
    TmdbService.fetchBollywood(),
  ]);
  final seen = <String>{};
  return results.expand((l) => l).where((m) => seen.add(m.id)).toList();
});
```

### Step 5: Update `lib/widgets/hero_slider.dart` to use TMDB

Replace the `const heroSlides` reference with the async provider:

```dart
// In _HeroSliderState, replace heroSlides with:
final asyncSlides = ref.watch(heroSlidesProvider);
final slides = asyncSlides.valueOrNull ?? [fallbackHeroSlide];
// Replace all heroSlides references with slides
// Replace heroSlides.length with slides.length
// Update timer to use slides.length
```

Also: add a `fallbackHeroSlide` constant in `tmdb_provider.dart`.

### Step 6: Update `lib/screens/home_screen.dart` to use TMDB providers

Replace all static `content_data.dart` references with async providers:

```dart
// For each ContentRow, use AsyncValue pattern:

// Continue Watching
ref.watch(continueWatchingProvider).when(
  data: (items) => ContentRow(title: 'Continue Watching', contents: items, ...),
  loading: () => ContentRow(title: 'Continue Watching', contents: const [], loadingSkeleton: true, ...),
  error: (_, __) => const SizedBox.shrink(),
),

// Top Bollywood
ref.watch(bollywoodProvider).when(
  data: (items) => ContentRow(title: 'Top 10 Bollywood', contents: items.take(10).toList(), ...),
  loading: () => ContentRow(title: 'Top 10 Bollywood', contents: const [], loadingSkeleton: true, ...),
  error: (_, __) => const SizedBox.shrink(),
),

// Indian Web Series
ref.watch(indianSeriesProvider).when(...),

// Top Hollywood  
ref.watch(hollywoodProvider).when(...),

// Drama
ref.watch(dramaProvider).when(...),

// Top 10 (variant: top10)
ref.watch(top10Provider).when(...),

// Action
ref.watch(actionProvider).when(...),
```

### Step 7: Update `lib/screens/genre_screen.dart` to use TMDB

```dart
// Replace genreContent map lookup with:
final content = ref.watch(genreContentProvider(genreId));
content.when(
  data: (items) => SliverToBoxAdapter(child: ContentRow(...items...)),
  loading: () => SliverToBoxAdapter(child: ContentRow(...loadingSkeleton: true...)),
  error: (_, __) => SliverToBoxAdapter(child: _emptyState()),
)
```

### Step 8: Update `lib/screens/search_screen.dart` to use TMDB

```dart
// Replace local _results() method with provider
// TextField onChange → ref.read(searchQueryProvider.notifier).state = value
// Results come from ref.watch(searchResultsProvider)
```

---

## PART 3 — PREMIUM UI OVERHAUL

### 3A. ContentCard — Complete Rewrite

**File:** `lib/widgets/content_card.dart`

Replace current implementation with this premium version:

```dart
// Key visual improvements:
// 1. Rounded corners: 12 (was 8) — more premium feel
// 2. Subtle shadow on cards: BoxShadow(color: black38, blurRadius: 8, offset: Offset(0,4))
// 3. On long-press: full blur overlay with action buttons (don't use bottom sheet — overlay right on card)
// 4. Genre tag chip shown at bottom of card (1 chip, small, semi-transparent)
// 5. Rating dot visible on defaultPoster cards (top-right corner)
// 6. ContinueWatching variant: show episode info text below card
// 7. Top10: rank number outline style improved (gradient stroke, not solid white)

class ContentCard extends StatefulWidget {
  // Keep same props
}

class _ContentCardState extends State<ContentCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  bool _overlayVisible = false;
  late AnimationController _overlayController;
  late Animation<double> _overlayAnim;

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _overlayAnim = CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  (double w, double h) _sizeForVariant() {
    switch (widget.variant) {
      case ContentCardVariant.defaultPoster:
        return (150, 225);
      case ContentCardVariant.continueWatching:
        return (280, 158);
      case ContentCardVariant.top10:
        return (160, 240); // taller to accommodate rank
    }
  }

  @override
  Widget build(BuildContext context) {
    final (w, h) = _sizeForVariant();
    final br = BorderRadius.circular(12); // was 8

    return RepaintBoundary(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) {
              setState(() => _pressed = false);
              Haptics.light();
              widget.onSelect(widget.content);
            },
            onLongPress: () {
              Haptics.medium();
              setState(() => _overlayVisible = true);
              _overlayController.forward();
            },
            child: AnimatedScale(
              scale: _pressed ? 0.96 : 1.0,     // FIXED: scale DOWN on press
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              child: SizedBox(
                width: w,
                height: widget.variant == ContentCardVariant.top10 ? h - 30 : h,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Card image
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: br,
                        child: Hero(
                          tag: 'movie-${widget.content.id}',
                          child: CachedNetworkImage(
                            imageUrl: widget.content.image,
                            fit: BoxFit.cover,
                            placeholder: (context, _) =>
                                ShimmerPlaceholder(width: w, height: h, borderRadius: 12),
                            errorWidget: (context, _, __) => Container(
                              decoration: BoxDecoration(
                                borderRadius: br,
                                color: AppColors.card,
                              ),
                              child: const Icon(Icons.broken_image_rounded,
                                  color: AppColors.textMuted, size: 32),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Subtle bottom gradient always visible
                    Positioned(
                      left: 0, right: 0, bottom: 0,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.72),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Rating badge (top-right, defaultPoster only)
                    if (widget.variant == ContentCardVariant.defaultPoster &&
                        widget.content.rating != null)
                      Positioned(
                        top: 8, right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppColors.success.withOpacity(0.5),
                              width: 0.5,
                            ),
                          ),
                          child: Text(
                            '${(widget.content.rating! * 10).round()}%',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                            ),
                          ),
                        ),
                      ),

                    // Genre tag (bottom-left, defaultPoster only)
                    if (widget.variant == ContentCardVariant.defaultPoster &&
                        widget.content.genre.isNotEmpty)
                      Positioned(
                        left: 8, bottom: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.60),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.content.genre.first,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.85),
                            ),
                          ),
                        ),
                      ),

                    // Progress bar (continueWatching only)
                    if (widget.variant == ContentCardVariant.continueWatching &&
                        widget.content.progress != null)
                      Positioned(
                        left: 0, right: 0, bottom: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
                          child: Container(
                            height: 3,
                            color: Colors.white.withOpacity(0.15),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: widget.content.progress! / 100,
                              child: Container(
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [AppColors.accent, AppColors.accentHover],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                    // Top10 rank number (outside card bounds)
                    if (widget.variant == ContentCardVariant.top10 &&
                        widget.rank != null)
                      Positioned(
                        left: -28,
                        bottom: -20,
                        child: _RankNumber(rank: widget.rank!),
                      ),

                    // Long-press overlay
                    if (_overlayVisible)
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: _overlayAnim,
                          builder: (context, child) => Opacity(
                            opacity: _overlayAnim.value,
                            child: child,
                          ),
                          child: ClipRRect(
                            borderRadius: br,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                              child: Container(
                                color: Colors.black.withOpacity(0.72),
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Close tap target
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: () {
                                          _overlayController.reverse().then((_) {
                                            if (mounted) setState(() => _overlayVisible = false);
                                          });
                                        },
                                        child: const Icon(Icons.close_rounded,
                                            color: Colors.white54, size: 18),
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      widget.content.title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        _overlayBtn(Icons.play_arrow_rounded, filled: true,
                                            onTap: () {
                                          _overlayController.reverse().then((_) {
                                            if (mounted) {
                                              setState(() => _overlayVisible = false);
                                              widget.onSelect(widget.content);
                                            }
                                          });
                                        }),
                                        const SizedBox(width: 8),
                                        _overlayBtn(Icons.add_rounded, onTap: () {
                                          _overlayController.reverse().then((_) {
                                            if (mounted) setState(() => _overlayVisible = false);
                                          });
                                        }),
                                        const Spacer(),
                                        _overlayBtn(Icons.thumb_up_alt_outlined, onTap: () {
                                          _overlayController.reverse().then((_) {
                                            if (mounted) setState(() => _overlayVisible = false);
                                          });
                                        }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          // Episode info for continueWatching
          if (widget.variant == ContentCardVariant.continueWatching &&
              widget.content.episodeInfo != null) ...[
            const SizedBox(height: 6),
            SizedBox(
              width: w,
              child: Text(
                widget.content.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              width: w,
              child: Text(
                'S${widget.content.episodeInfo!.season}:E${widget.content.episodeInfo!.episode}',
                style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _overlayBtn(IconData icon, {required VoidCallback onTap, bool filled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? Colors.white : Colors.white.withOpacity(0.15),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Icon(icon, size: 16, color: filled ? Colors.black : Colors.white),
      ),
    );
  }
}

// Improved _RankNumber
class _RankNumber extends StatelessWidget {
  const _RankNumber({required this.rank});
  final int rank;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFF7C3AED), Color(0xFF4C1D95)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        rank.toString(),
        style: const TextStyle(
          fontSize: 100,
          fontWeight: FontWeight.w900,
          color: Colors.white, // shader mask overrides this
          height: 1.0,
        ),
      ),
    );
  }
}
```

### 3B. ContentRow — Overflow Fix + Visual Polish

**File:** `lib/widgets/content_row.dart`

```dart
// Key changes:
// 1. Fix heights: continueWatching: 210 (was 170, needs room for episode info)
//                defaultPoster: 250 (was 240, adds breathing room)  
//                top10: 290 (was 240, needs rank number overflow room)
// 2. Fix header: use LayoutBuilder to stack on small screens
// 3. Add horizontal padding compensation for top10 (left: 44 to show rank)
// 4. Wrap entire row column in Padding(bottom: 16) for spacing

// Height constants
double get _listHeight {
  switch (widget.variant) {
    case ContentRowVariant.continueWatching: return 210;
    case ContentRowVariant.top10: return 290;
    default: return 250;
  }
}

// For top10 variant, add extra left padding so rank numbers aren't clipped:
padding: EdgeInsets.only(
  left: widget.variant == ContentRowVariant.top10 ? 44 : 16,
  right: 16,
),

// Filter pills: use LayoutBuilder and conditionally show below title on narrow screens
Widget _buildHeader(BuildContext context) {
  return LayoutBuilder(builder: (context, constraints) {
    final isNarrow = constraints.maxWidth < 380;
    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _titleBlock(context),
          if (widget.showFilter) ...[
            const SizedBox(height: 8),
            _pillRow(),
          ],
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(child: _titleBlock(context)),
        if (widget.showFilter) _pillRow(),
      ],
    );
  });
}
```

### 3C. HeroSlider — Fix CTA overflow + use TMDB data

**File:** `lib/widgets/hero_slider.dart`

```dart
// 1. Replace Row CTAs with Wrap:
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    _ctaWhite(context, label: 'Watch Now', icon: Icons.play_arrow_rounded, onTap: () {}),
    _ctaGhost(context, label: 'Add to List', icon: Icons.add_rounded, onTap: () {}),
    _ctaGhost(context, label: 'More Info', icon: Icons.info_outline_rounded, onTap: () {}),
  ],
)

// 2. Hero slide content positioned with bottom safe area awareness:
Positioned(
  left: leftPadding,
  right: 16,
  bottom: MediaQuery.of(context).padding.bottom + 100, // was hardcoded 90
  child: ConstrainedBox(...),
)

// 3. Add loading state for TMDB data:
// Use ref.watch(heroSlidesProvider) and show shimmer while loading

// 4. The brand label above title should use the actual platform name, styled:
Row(
  children: [
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
      ),
      child: Text(
        'STREAMFLIX',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.5,
          color: AppColors.accent,
        ),
      ),
    ),
    const SizedBox(width: 8),
    Text(slide.meta, style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
  ],
),
```

### 3D. TopNavBar — Fix iOS safe area + premium polish

**File:** `lib/widgets/top_nav_bar.dart`

```dart
// 1. Fix preferredSize to be dynamic:
@override
Size get preferredSize {
  // This can't be dynamic since it's called before context is available
  // Instead, make the nav height account for status bar via padding in build
  return const Size.fromHeight(70);
}

// 2. In build method, add proper status bar padding:
@override
Widget build(BuildContext context, WidgetRef ref) {
  final topPad = MediaQuery.of(context).padding.top;
  final scrolled = ref.watch(navScrolledProvider);
  
  return AnimatedContainer(
    duration: 250.ms,
    height: topPad + 60, // dynamic height
    decoration: scrolled ? BoxDecoration(
      color: Colors.black.withOpacity(0.85),
      border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      // REMOVED: BackdropFilter causes performance issues on Android — use solid dark bg
    ) : const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black87, Colors.transparent],
      ),
    ),
    child: Padding(
      padding: EdgeInsets.only(top: topPad, left: 16, right: 16),
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            // Logo
            InkWell(
              onTap: () => context.go('/'),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontFamily: 'Inter Tight',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                  children: const [
                    TextSpan(text: 'Stream'),
                    TextSpan(text: 'Flix', style: TextStyle(color: AppColors.accent)),
                  ],
                ),
              ),
            ),
            const Spacer(),
            _iconButton(icon: Icons.search_rounded, onTap: _openSearch),
            const SizedBox(width: 4),
            _notificationBell(),
            const SizedBox(width: 4),
            CompositedTransformTarget(
              link: _layerLink,
              child: _profileAvatar(onTap: _toggleMenu),
            ),
          ],
        ),
      ),
    ),
  );
}

// 3. Profile avatar: show actual selected profile avatar from provider
// ref.watch(contentProvider).selectedProfile?.avatar
// Use CachedNetworkImage if avatar is a URL

// 4. Profile dropdown menu: use ClipRRect + BackdropFilter for true glass effect
// Make the dropdown wider: 240px (was 220px)
// Add user info at top of dropdown: avatar + name + email

// 5. Dropdown items: add icons to each menu item
Widget _menuItem(String title, IconData icon, VoidCallback onTap) {
  return InkWell(
    onTap: () { _toggleMenu(); onTap(); },
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textMuted),
          const SizedBox(width: 10),
          Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
          )),
        ],
      ),
    ),
  );
}
```

### 3E. BottomNavBar — Premium Pill Indicator

**File:** `lib/widgets/bottom_nav_bar.dart`

```dart
// Replace current flat BottomNavBar with a floating island style:
// 1. Rounded top with BorderRadius.vertical(top: Radius.circular(20))
// 2. Active tab: gradient pill background (not just opacity)
// 3. Active icon: slightly larger (size: 26 vs 22)
// 4. Slight elevation shadow above nav bar

return Container(
  decoration: BoxDecoration(
    color: const Color(0xFF0A0A0A), // slightly lighter than pure black
    border: Border(
      top: BorderSide(color: Colors.white.withOpacity(0.08), width: 0.5),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.4),
        blurRadius: 20,
        offset: const Offset(0, -4),
      ),
    ],
  ),
  child: SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        children: [...], // existing tiles
      ),
    ),
  ),
);

// Active tile design:
AnimatedContainer(
  duration: 200.ms,
  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(14),
    gradient: selected ? const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF7C3AED),
        Color(0xFF4C1D95),
      ],
    ) : null,
  ),
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      AnimatedScale(
        scale: selected ? 1.15 : 1.0,
        duration: 200.ms,
        child: Icon(item.icon, size: 22,
          color: selected ? Colors.white : AppColors.textMuted),
      ),
      const SizedBox(height: 2),
      Text(item.label, style: ...),
    ],
  ),
),
```

### 3F. MovieDetailModal — Premium Redesign

**File:** `lib/widgets/movie_detail_modal.dart`

```dart
// Key UI improvements:
// 1. Image at top uses full width with aspect 16:9, rounded ONLY top corners
// 2. Overlay gradient on the image so metadata reads clearly
// 3. Year, genre chips, rating, duration displayed in a metadata row
// 4. "Similar" section uses a horizontal row of poster cards (NOT the full ContentCard)
//    to avoid Hero tag conflicts
// 5. Fix Hero tag: use 'modal-${movie.id}' for the modal image

// Metadata row:
Row(
  children: [
    if (movie.rating != null)
      _metaChip('${(movie.rating! * 100).round()}% Match', color: AppColors.success),
    const SizedBox(width: 8),
    _metaChip(movie.year.toString()),
    const SizedBox(width: 8),
    if (movie.duration != null) _metaChip(movie.duration!),
    const SizedBox(width: 8),
    _metaChip(movie.type == 'series' ? 'Series' : 'Movie'),
  ],
),

// Genre chips row:
Wrap(
  spacing: 6,
  runSpacing: 6,
  children: movie.genre.map((g) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      color: AppColors.borderSubtle,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: AppColors.borderSubtle),
    ),
    child: Text(g, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
  )).toList(),
),

// Similar movies: plain image tiles (no Hero wrapper)
SizedBox(
  height: 130,
  child: ListView.separated(
    scrollDirection: Axis.horizontal,
    itemCount: similar.length,
    separatorBuilder: (_, __) => const SizedBox(width: 8),
    itemBuilder: (context, i) {
      final m = similar[i];
      return GestureDetector(
        onTap: () => onSelectSimilar(m),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            imageUrl: m.image,
            width: 87,
            height: 130,
            fit: BoxFit.cover,
          ),
        ),
      );
    },
  ),
),
```

### 3G. HomeScreen — Fix Layout + Polish

**File:** `lib/screens/home_screen.dart`

```dart
// 1. Fix the hero/continueWatching overlap using Stack inside first Sliver:
SliverToBoxAdapter(
  child: Stack(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const HeroSlider(),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        right: 0,
        child: ref.watch(continueWatchingProvider).when(
          data: (items) => ContentRow(
            title: 'Continue Watching',
            subtitle: 'Pick up where you left off',
            contents: items,
            variant: ContentRowVariant.continueWatching,
            onSelect: (m) => _open(context, ref, m),
          ),
          loading: () => ContentRow(
            title: 'Continue Watching',
            contents: const [],
            variant: ContentRowVariant.continueWatching,
            loadingSkeleton: true,
            onSelect: (_) {},
          ),
          error: (_, __) => const SizedBox.shrink(),
        ),
      ),
    ],
  ),
),

// 2. Add bottom padding sliver to prevent content hidden behind BottomNavBar:
SliverPadding(
  padding: EdgeInsets.only(
    bottom: MediaQuery.of(context).padding.bottom + 80,
  ),
),

// 3. Each async ContentRow: use a helper method to reduce boilerplate:
Widget _asyncRow({
  required AsyncValue<List<Movie>> asyncValue,
  required String title,
  String? subtitle,
  ContentRowVariant variant = ContentRowVariant.defaultPoster,
  bool showFilter = false,
}) {
  return asyncValue.when(
    data: (items) => ContentRow(
      title: title,
      subtitle: subtitle,
      contents: items,
      variant: variant,
      showFilter: showFilter,
      onSelect: (m) => _open(context, ref, m),
    ),
    loading: () => ContentRow(
      title: title,
      subtitle: subtitle,
      contents: const [],
      variant: variant,
      loadingSkeleton: true,
      onSelect: (_) {},
    ),
    error: (_, __) => const SizedBox.shrink(),
  );
}
```

### 3H. SearchScreen — Full Overhaul

**File:** `lib/screens/search_screen.dart`

```dart
// Key improvements:
// 1. Fix top padding: use MediaQuery.of(context).padding.top + 70 + 16
// 2. Show trending when query is empty (with "Trending" header)
// 3. Real-time TMDB search via searchQueryProvider + debounce 400ms
// 4. Results grid: 2 columns on mobile, 3 on tablet
// 5. Show search result count: "Showing 24 results for 'inception'"
// 6. Empty state: nice "No results" illustration with suggestion text
// 7. Recent searches chip row (persisted via SharedPreferences)

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchQueryProvider.notifier).state = value;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final query = ref.watch(searchQueryProvider);
    final results = ref.watch(searchResultsProvider);

    return Column(
      children: [
        // Fixed search header
        Container(
          padding: EdgeInsets.fromLTRB(16, topPad + 70 + 8, 16, 12),
          color: AppColors.background,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Search', style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w900,
              )),
              const SizedBox(height: 12),
              TextField(
                controller: _controller,
                onChanged: _onChanged,
                // ... styled TextField
              ),
            ],
          ),
        ),
        // Results
        Expanded(
          child: results.when(
            data: (items) => items.isEmpty
                ? _emptyState(query)
                : GridView.builder(
                    padding: EdgeInsets.fromLTRB(16, 8, 16, bottomPad + 80),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2 / 3,
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) => ContentCard(
                      content: items[index],
                      variant: ContentCardVariant.defaultPoster,
                      onSelect: _open,
                    ),
                  ),
            loading: () => const Center(child: CircularProgressIndicator(
              color: AppColors.accent, strokeWidth: 2,
            )),
            error: (_, __) => _emptyState(query),
          ),
        ),
      ],
    );
  }

  Widget _emptyState(String query) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 64, color: AppColors.textFaint),
          const SizedBox(height: 16),
          Text(
            query.isEmpty ? 'Search for movies, shows...' : 'No results for "$query"',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
```

### 3I. GenreScreen — Fix and Polish

**File:** `lib/screens/genre_screen.dart`

```dart
// 1. Hero slider height: 420 is correct, keep it
// 2. Add shimmer loading for genre content
// 3. Genre header (SliverPersistentHeader) needs visual upgrade:
//    - Add glass blur background (BackdropFilter)
//    - Pills: use 12px vertical padding (was 10) for better touch targets
//    - Add icon to each genre pill (optional)
// 4. Empty state: center-aligned with nice icon
// 5. Add bottom padding sliver

// Replace static genreContent map with TMDB provider:
final content = ref.watch(genreContentProvider(_genreId));
```

### 3J. SubscriptionScreen — Layout Fix + Premium

**File:** `lib/screens/subscription_screen.dart`

Key fixes:
- Ensure the comparison table is scrollable on small phones (wrap in `SingleChildScrollView`)
- Add `MediaQuery.of(context).padding.top + 70 + 16` for top padding 
- Plan cards: use `Column` layout on phones (not `Row`) — 2 plan cards side by side on 375px is very cramped
- CTA button: use `GradientButton` widget directly (remove the `.animate()` flickering)
- Billing toggle selected state: add a subtle shadow/glow on selected pill

### 3K. LoginScreen & SignupScreen — Fix Safe Areas

**File:** `lib/screens/login_screen.dart`, `signup_screen.dart`

- Replace all hardcoded top padding with `MediaQuery.of(context).padding.top + 70 + 16`
- Card rounded corners: `BorderRadius.circular(24)` (more premium)
- Text fields: increase height to 52px with proper `contentPadding`
- OTP fields: use `SizedBox(width: 44, height: 52)` per field for consistent sizing
- Google sign-in button: properly sized with logo icon + text

### 3L. AccountSettingsScreen — Polish

**File:** `lib/screens/account_settings_screen.dart`

- Fix top padding: `MediaQuery.of(context).padding.top + 70 + 16`
- Section cards: increase internal padding from 16 to 20
- Each info cell: add a subtle `Container` with `AppColors.card` bg and `borderRadius: 10`
- Status pill ("Active"): green background container, not just text
- Bottom padding: `MediaQuery.of(context).padding.bottom + 80`

---

## PART 4 — GLOBAL PREMIUM POLISH (Apply Everywhere)

### P1. Typography Fix
In `app_theme.dart`, fix the `displayLarge` style — it's called as `Theme.of(context).textTheme.displayLarge` in HeroSlider for the title, but the fontSize `56` is too large on 375px phones and overflows.

```dart
// Add responsive text scaling in HeroSlider title:
Text(
  slide.title,
  style: Theme.of(context).textTheme.displayLarge?.copyWith(
    fontSize: MediaQuery.of(context).size.width < 400 ? 32 : 48,
  ),
)
```

### P2. Consistent Section Spacing
All `ContentRow` sections should have consistent `Padding(padding: EdgeInsets.only(bottom: 24))` wrapper — currently sections are spaced inconsistently.

### P3. Loading Shimmer Heights
Fix shimmer heights for each variant to exactly match card heights:
- `defaultPoster`: `height: 225, width: 150, borderRadius: 12`
- `continueWatching`: `height: 158, width: 280, borderRadius: 12`  
- `top10`: `height: 210, width: 160, borderRadius: 12`

### P4. Error Handling UI
When TMDB fails (no network), show a subtle error banner at top of HomeScreen:
```dart
Container(
  padding: const EdgeInsets.all(12),
  color: Colors.red.withOpacity(0.12),
  child: Row(
    children: [
      const Icon(Icons.wifi_off_rounded, color: Colors.redAccent, size: 16),
      const SizedBox(width: 8),
      Text('Showing cached content. Check your connection.',
           style: TextStyle(fontSize: 12, color: Colors.redAccent)),
    ],
  ),
),
```

### P5. Image Error Placeholders
Replace the plain `Container(color: AppColors.card)` error widget everywhere with a styled placeholder:
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.card,
    borderRadius: BorderRadius.circular(12),
  ),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.movie_outlined, color: AppColors.textFaint, size: 28),
      const SizedBox(height: 4),
      Text('No Image', style: TextStyle(fontSize: 10, color: AppColors.textFaint)),
    ],
  ),
),
```

### P6. Haptics Expansion
```dart
// All list pills: Haptics.selection()
// All CTA buttons: Haptics.light()
// Plan selection in SubscriptionScreen: Haptics.medium()
// Profile selection: Haptics.medium()
```

### P7. System UI
In `main.dart`, after `WidgetsFlutterBinding.ensureInitialized()` add:
```dart
SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  systemNavigationBarColor: Color(0xFF020202),
  systemNavigationBarIconBrightness: Brightness.light,
));
SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
```

---

## PART 5 — PUBSPEC.YAML ADDITIONS

Add these to your existing `pubspec.yaml`:

```yaml
dependencies:
  # Add these (keep all existing):
  http: ^1.2.1
  flutter_dotenv: ^5.1.0

# In flutter section, add:
flutter:
  assets:
    - .env
```

---

## PART 6 — HOW TO GET A TMDB API KEY (add this comment to README.md)

```markdown
## Setup

1. Go to https://www.themoviedb.org/settings/api
2. Create a free account and request an API key
3. Copy your "API Read Access Token" (the long Bearer token)
4. Create `.env` in the project root:
   ```
   TMDB_API_KEY=eyJhbGci...your_token_here
   ```
5. Run `flutter pub get && flutter run`

Note: The app works offline with shimmer skeletons if no API key is set.
```

---

## SUMMARY OF ALL CHANGES

| File | Changes |
|------|---------|
| `lib/services/tmdb_service.dart` | **NEW** — Full TMDB API service |
| `lib/providers/tmdb_provider.dart` | **NEW** — All content providers with TMDB |
| `lib/widgets/content_card.dart` | Full rewrite: fix scale direction, overlay on long-press, rank number, genre chip, rating badge, Hero tag fix |
| `lib/widgets/content_row.dart` | Fix heights, top10 padding, header layout on narrow screens |
| `lib/widgets/hero_slider.dart` | Fix CTA overflow (Wrap), TMDB data, bottom positioning |
| `lib/widgets/top_nav_bar.dart` | Fix iOS safe area, dynamic height, icons in dropdown |
| `lib/widgets/bottom_nav_bar.dart` | Gradient pill active state, shadow, better spacing |
| `lib/widgets/movie_detail_modal.dart` | Fix Hero tag conflict, metadata row, similar movies fix |
| `lib/widgets/shimmer_placeholder.dart` | Fix highlight color |
| `lib/widgets/gradient_button.dart` | Remove flicker animation, add press scale |
| `lib/screens/home_screen.dart` | Fix hero overlap, async TMDB data, bottom padding |
| `lib/screens/genre_screen.dart` | TMDB data, bottom padding, glass genre header |
| `lib/screens/search_screen.dart` | Fix top padding, TMDB search, debounce, empty state |
| `lib/screens/subscription_screen.dart` | Fix top padding, column layout on phone |
| `lib/screens/login_screen.dart` | Fix top padding, larger text fields |
| `lib/screens/signup_screen.dart` | Fix top padding, larger text fields |
| `lib/screens/account_settings_screen.dart` | Fix top/bottom padding, card cells |
| `lib/main.dart` | Edge-to-edge, dotenv, system UI |
| `pubspec.yaml` | Add http, flutter_dotenv |
| `.env` | New file with TMDB_API_KEY |

---

## CRITICAL: ORDER OF IMPLEMENTATION

1. `pubspec.yaml` — add http + flutter_dotenv, run `flutter pub get`
2. `.env` file — add TMDB key
3. `main.dart` — add dotenv.load + SystemChrome edgeToEdge
4. `lib/services/tmdb_service.dart` — create full service
5. `lib/providers/tmdb_provider.dart` — create all providers
6. `lib/widgets/shimmer_placeholder.dart` — fix highlight color (1 min fix)
7. `lib/widgets/gradient_button.dart` — remove flicker (1 min fix)
8. `lib/widgets/glass_container.dart` — no changes needed
9. `lib/widgets/content_card.dart` — full rewrite (biggest change)
10. `lib/widgets/content_row.dart` — height + header fixes
11. `lib/widgets/hero_slider.dart` — Wrap CTAs + TMDB
12. `lib/widgets/top_nav_bar.dart` — safe area fix
13. `lib/widgets/bottom_nav_bar.dart` — gradient pill
14. `lib/widgets/movie_detail_modal.dart` — Hero tag fix + metadata
15. `lib/screens/home_screen.dart` — TMDB async + layout fix
16. `lib/screens/search_screen.dart` — TMDB + padding fix
17. `lib/screens/genre_screen.dart` — TMDB + padding fix
18. All other screens — padding fixes

Implement ALL changes. No placeholder comments. The result should compile and run with `flutter run` showing real TMDB content, no layout overflows, and premium production-quality UI on both iOS and Android.