# Camcine — Flutter App Documentation
### Full Parity with React Web App + Bottom Navigation Enhancement

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [App Architecture](#2-app-architecture)
3. [Design System & Tokens](#3-design-system--tokens)
4. [Navigation — Bottom Glassmorphic Pill](#4-navigation--bottom-glassmorphic-pill)
5. [Screens & Flow Map](#5-screens--flow-map)
6. [Screen-by-Screen Specification](#6-screen-by-screen-specification)
   - 6.1 Home Screen
   - 6.2 Browse Screen
   - 6.3 Content Detail Screen
   - 6.4 Player Screen
   - 6.5 Search Screen
   - 6.6 Songs Screen
   - 6.7 News Screen (from "More" popup)
   - 6.8 Pricing Screen
   - 6.9 Account Screen
   - 6.10 Login Screen
   - 6.11 Register Screen
7. ["More" Animated Popup Sheet](#7-more-animated-popup-sheet)
8. [Persistent Mini Player Bar](#8-persistent-mini-player-bar)
9. [Data Models](#9-data-models)
10. [State Management](#10-state-management)
11. [Services & API Integration](#11-services--api-integration)
12. [Animations Specification](#12-animations-specification)
13. [Component Library](#13-component-library)
14. [Flutter File Structure](#14-flutter-file-structure)
15. [Dependencies](#15-dependencies)

---

## 1. Project Overview

**App Name:** Camcine
**Platform:** Flutter (iOS + Android)
**Backend/Data Source:** TMDB API + mock content service (songs, news, live)
**Auth:** Email/password via local persistence (Zustand → Riverpod/Provider in Flutter)
**Design Language:** Dark cinematic, glassmorphism, Sora typeface, accent `#E8442C`

### Core Feature Set (React → Flutter parity)

| React Feature | Flutter Equivalent |
|---|---|
| Top glass header with nav pill | Transparent AppBar (no-background) + custom SliverAppBar |
| Bottom nav: Home · Movies · Series · Songs · **More** | Bottom Glassmorphic Pill Nav |
| "More" dropdown → Genres, Live News, Pricing | "More" → Animated bottom sheet popup |
| TMDB-powered hero slider (auto-advance 6s) | PageView hero with Timer |
| Genre filter tab row | Horizontal scrollable chip row |
| Horizontal content scroll rows | ListView.builder horizontal |
| Top 10 numbered cards | Custom Stack widget |
| Content detail with trailer autoplay | YouTube Player embed |
| Persistent mini player bar (bottom) | Persistent overlay above bottom nav |
| Songs page with category rows | GridView/ListView hybrid |
| Live news with ticker | Marquee widget + News grid |
| Authentication guard | GoRouter redirect |
| Subscription/Pricing tiers | Custom pricing cards |

---

## 2. App Architecture

```
lib/
├── main.dart
├── app.dart                        # MaterialApp + GoRouter
├── core/
│   ├── theme/
│   │   ├── app_theme.dart          # ThemeData, colors, text styles
│   │   └── app_colors.dart         # Design tokens
│   ├── router/
│   │   └── app_router.dart         # GoRouter configuration
│   └── utils/
│       ├── format_utils.dart       # Duration, date formatters
│       └── extensions.dart
├── data/
│   ├── models/                     # Data models (Content, User, etc.)
│   ├── services/
│   │   ├── tmdb_service.dart
│   │   ├── auth_service.dart
│   │   ├── content_service.dart
│   │   └── payment_service.dart
│   └── repositories/
├── features/
│   ├── home/
│   ├── browse/
│   ├── content_detail/
│   ├── player/
│   ├── search/
│   ├── songs/
│   ├── news/
│   ├── pricing/
│   ├── account/
│   └── auth/
├── shared/
│   ├── widgets/
│   │   ├── content_card.dart
│   │   ├── section_row.dart
│   │   ├── glass_container.dart
│   │   ├── skeleton_loader.dart
│   │   ├── genre_chip.dart
│   │   └── live_badge.dart
│   └── providers/
│       ├── auth_provider.dart
│       ├── player_provider.dart
│       └── ui_provider.dart
└── navigation/
    ├── bottom_nav_pill.dart        # Glassmorphic bottom pill
    └── more_popup_sheet.dart       # Animated "More" modal
```

**State Management:** Riverpod (equivalent to Zustand)
**Routing:** GoRouter (equivalent to React Router)
**HTTP:** Dio + retrofit
**Caching:** flutter_query or riverpod with AsyncNotifier

---

## 3. Design System & Tokens

### Color Palette

```dart
// lib/core/theme/app_colors.dart

class AppColors {
  // Backgrounds
  static const bgBase       = Color(0xFF06080A);     // --bg-base
  static const bgCard       = Color(0xFF0D1014);     // --bg-card
  static const bgElevated   = Color(0xFF111518);     // --bg-elevated
  static const bgOverlay    = Color(0xFF161B20);     // --bg-overlay

  // Accent
  static const accent       = Color(0xFFE8442C);     // --accent (primary red)
  static const accentHover  = Color(0xFFFF6B4A);     // --accent-hover

  // Text
  static const textPrimary  = Color(0xFFFFFFFF);
  static const textSecondary = Color(0x99FFFFFF);    // 60% white
  static const textMuted    = Color(0x4DFFFFFF);     // 30% white

  // Glass
  static const glassBg      = Color(0x0DFFFFFF);     // rgba(255,255,255,0.05)
  static const glassBorder  = Color(0x14FFFFFF);     // rgba(255,255,255,0.08)
  static const glassAccent  = Color(0x1AE8442C);     // rgba(accent,0.10)
}
```

### Typography

```dart
// Sora font family — add to pubspec.yaml
// google_fonts: ^6.x

import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle heroTitle = GoogleFonts.sora(
    fontSize: 48,
    fontWeight: FontWeight.w900,
    color: Colors.white,
    fontStyle: FontStyle.italic,
    letterSpacing: -1.5,
  );

  static TextStyle sectionTitle = GoogleFonts.sora(
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: Colors.white,
    letterSpacing: -0.5,
  );

  static TextStyle top10Number = GoogleFonts.sora(
    fontSize: 160,
    fontWeight: FontWeight.w900,
    fontStyle: FontStyle.italic,
    color: Colors.transparent,
  );

  static TextStyle label = GoogleFonts.sora(
    fontSize: 10,
    fontWeight: FontWeight.w900,
    color: AppColors.textSecondary,
    letterSpacing: 2.0,
  );

  static TextStyle navLabel = GoogleFonts.sora(
    fontSize: 10,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
  );
}
```

### Glass Morphism Recipe

```dart
// lib/shared/widgets/glass_container.dart

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color? borderColor;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;

  const GlassContainer({
    required this.child,
    this.blur = 24,
    this.borderColor,
    this.borderRadius,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? AppColors.glassBg,
            borderRadius: borderRadius ?? BorderRadius.circular(24),
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
```

---

## 4. Navigation — Bottom Glassmorphic Pill

This is the primary navigation pattern for Flutter, replacing the React header nav. The pill sits above the mini player bar (when active).

### Visual Specification

```
┌─────────────────────────────────────────────────────────┐
│                     [content area]                       │
│                                                          │
│  ┌──────────────────────────────────────────────────┐   │
│  │  [mini player bar — when playing]                │   │
│  └──────────────────────────────────────────────────┘   │
│                                                          │
│     ╭──────────────────────────────────────────╮        │
│     │  🏠 Home  🎬 Movies  📺 Series  🎵 Songs  ···  │  │
│     ╰──────────────────────────────────────────╯        │
└─────────────────────────────────────────────────────────┘
```

**Pill shape:** `BorderRadius.circular(40)`
**Background:** `rgba(8,10,14,0.85)` + `BackdropFilter(blur: 32)`
**Border:** `1px solid rgba(255,255,255,0.08)`
**Shadow:** `BoxShadow(color: Colors.black54, blurRadius: 40)`
**Bottom padding:** `max(16, MediaQuery.of(context).padding.bottom + 8)`

### Tabs

| Index | Label | Icon | Route |
|---|---|---|---|
| 0 | Home | `Icons.home_rounded` | `/` |
| 1 | Movies | `Icons.movie_rounded` | `/browse?type=movie` |
| 2 | Series | `Icons.tv_rounded` | `/browse?type=series` |
| 3 | Songs | `Icons.music_note_rounded` | `/songs` |
| 4 | More | `Icons.apps_rounded` | → opens popup |

### Active State

The active tab shows:
- Icon color: `AppColors.accent`
- Text color: white
- Background behind icon+label: pill within pill — `rgba(232,68,44,0.15)` with `rgba(232,68,44,0.35)` border, `borderRadius: 20`

Inactive tabs:
- Icon + text: `AppColors.textSecondary`

### Implementation

```dart
// lib/navigation/bottom_nav_pill.dart

class BottomNavPill extends ConsumerStatefulWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final VoidCallback onMoreTapped;

  const BottomNavPill({
    required this.currentIndex,
    required this.onTabTapped,
    required this.onMoreTapped,
  });

  @override
  ConsumerState<BottomNavPill> createState() => _BottomNavPillState();
}

class _BottomNavPillState extends ConsumerState<BottomNavPill>
    with SingleTickerProviderStateMixin {

  final tabs = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.movie_rounded, label: 'Movies'),
    _NavItem(icon: Icons.tv_rounded, label: 'Series'),
    _NavItem(icon: Icons.music_note_rounded, label: 'Songs'),
    _NavItem(icon: Icons.apps_rounded, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final isPlaying = ref.watch(playerProvider).currentContent != null;

    return Positioned(
      bottom: (isPlaying ? 80.0 : 0.0) + 12,
      left: 20,
      right: 20,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        offset: Offset.zero,
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: GlassContainer(
            blur: 32,
            backgroundColor: const Color(0xD908080A),
            borderRadius: BorderRadius.circular(40),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(tabs.length, (index) {
                  final isActive = widget.currentIndex == index;
                  final isMore = index == 4;
                  return GestureDetector(
                    onTap: () => isMore ? widget.onMoreTapped() : widget.onTabTapped(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOut,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: isActive ? BoxDecoration(
                        color: AppColors.glassAccent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.accent.withOpacity(0.35)),
                      ) : null,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tabs[index].icon,
                            size: 22,
                            color: isActive ? AppColors.accent : AppColors.textSecondary,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tabs[index].label,
                            style: AppTextStyles.navLabel.copyWith(
                              color: isActive ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## 5. Screens & Flow Map

```
App Launch
    │
    ├── checkAuth() → isAuthenticated?
    │       ├── NO  → /login
    │       └── YES → / (Home)
    │
    ├── /login ──────────── LoginScreen
    │     └── success → /
    │
    ├── /register ────────── RegisterScreen
    │     └── success → /
    │
    └── Authenticated Shell (BottomNavPill + MiniPlayer)
          ├── / ──────────────────── HomeScreen
          │     ├── ContentCard tap → /content/:id
          │     ├── Play Now → /player/:id
          │     └── View All → /browse
          │
          ├── /browse ─────────────── BrowseScreen
          │     └── ContentCard tap → /content/:id
          │
          ├── /content/:id ─────────── ContentDetailScreen
          │     ├── Play Now → /player/:id  (or opens MiniPlayer)
          │     └── Similar content → /content/:id
          │
          ├── /player/:id ──────────── PlayerScreen (full screen)
          │
          ├── /search ─────────────── SearchScreen
          │
          ├── /songs ──────────────── SongsScreen
          │     └── Song tap → opens MiniPlayer
          │
          ├── /pricing ────────────── PricingScreen
          │
          ├── /account ────────────── AccountScreen (protected)
          │
          └── "More" popup ────────── MorePopupSheet
                ├── Live News → /live-news
                ├── Genres → /browse
                └── Pricing → /pricing
```

---

## 6. Screen-by-Screen Specification

---

### 6.1 Home Screen

**Route:** `/`
**File:** `lib/features/home/home_screen.dart`

#### Layout Structure (top to bottom)

```
HomeScreen
├── CustomScrollView
│   ├── SliverAppBar (transparent, floating, snap) [pinned=false]
│   │   └── Logo + Search icon + Bell icon + Avatar
│   │
│   ├── HeroSection (height: 70vh)
│   │   ├── Stack
│   │   │   ├── BackdropImage (featured[0].backdrop, brightness 0.4)
│   │   │   ├── Gradient overlays (bottom + right side)
│   │   │   └── HeroContent (bottom-left)
│   │   │       ├── Rating badge (⭐ 8.6)
│   │   │       ├── Year + "Premium" badge
│   │   │       ├── Title (Sora, italic, 48px, uppercase)
│   │   │       ├── Description (2-3 line clamp)
│   │   │       ├── [Play Now] button (accent, rounded pill)
│   │   │       └── [+] button (glass circle)
│   │
│   ├── GenreFilterRow
│   │   └── SingleChildScrollView(horizontal)
│   │       └── genre chips: All, Action, Drama, Thriller, Comedy...
│   │           Active chip: accent bg + white text
│   │           Inactive: glass bg + muted text
│   │
│   ├── SectionRow — "Trending Now"
│   │   ├── Header: title + "View All →"
│   │   └── Horizontal ListView: ContentCards (140×210, 2:3 ratio)
│   │
│   ├── Top10Section — "TOP 10 Movies Today"
│   │   ├── Large number overlay (Sora, stroke only, 160px)
│   │   └── Poster shifted right on top of number
│   │
│   ├── EditorsChoiceSection (full-width 21:9 banner)
│   │   └── featured[0].backdrop + gradient overlay + text
│   │
│   ├── SectionRow — "Popular Movies"
│   ├── SectionRow — "Now Playing"
│   ├── SectionRow — "TV Series"
│   │
│   ├── FeaturePromoCard ("The Mummy" style)
│   │   ├── Background image (dimmed)
│   │   ├── Left: poster + director + title (vertical block)
│   │   └── Right: metadata + Play + Details buttons
│   │
│   └── CTABanner
│       └── Glassmorphic rounded card: "Stream Unlimited" + Subscribe Now
│
└── [space for bottom nav pill]
```

#### Hero Slider Auto-Advance

```dart
// Auto-cycles every 6 seconds through featured items (max 5)
Timer.periodic(const Duration(seconds: 6), (_) {
  setState(() {
    _currentSlide = (_currentSlide + 1) % min(_heroSlides.length, 5);
  });
});
```

#### Hero Entry Animation

Use `flutter_animate` or manual AnimationController:
- Backdrop: fade in + scale from 1.08→1.0, duration 1.4s, `Curves.easeOutCubic`
- Content (left side): slide from left (-40px→0) + fade, 1.0s, offset -0.4s
- Title: slide up 30px + fade, 0.8s
- CTA buttons: slide up 20px + stagger 0.12s each

#### Section Row Widget

```dart
class SectionRow extends StatelessWidget {
  final String title;
  final String viewAllRoute;
  final List<Content> items;
  final bool isLoading;

  // Renders:
  // Row: title + "View All →"
  // ListView.builder(scrollDirection: Axis.horizontal)
  //   itemWidth: 140 (mobile) / 180 (tablet)
  //   item: ContentCard
}
```

#### Top 10 Section — Numbered Cards

```dart
// Each numbered card is a Stack:
Stack(
  clipBehavior: Clip.none,
  children: [
    // Number (outlined stroke text, behind)
    Positioned(
      left: -5,
      bottom: -20,
      child: Text(
        '${index + 1}',
        style: AppTextStyles.top10Number.copyWith(
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = AppColors.accent,
        ),
      ),
    ),
    // Poster card (shifted right, in front)
    Positioned(
      left: 40,
      child: ContentCard(content: item),
    ),
  ],
)
```

---

### 6.2 Browse Screen

**Route:** `/browse`
**File:** `lib/features/browse/browse_screen.dart`

#### Layout

```
BrowseScreen
├── AppBar: title (Discover / Popular Movies / TV Shows)
├── TypeTabRow: [All] [Movies] [Series]
│   └── SortToggle: [Popular] [Top Rated]
├── GenreFilterRow (horizontal scroll chips)
│   └── Filter drawer button
└── ContentGrid
    └── GridView.builder(crossAxisCount: 3, mobile) / (4, tablet)
        └── ContentCard
```

#### State

- `activeType`: All / Movies / Series
- `selectedGenreId`: int? (TMDB genre ID)
- `sortBy`: popular / top_rated / trending
- Reads from URL params on mount (equivalent to `useSearchParams`)

---

### 6.3 Content Detail Screen

**Route:** `/content/:id`
**File:** `lib/features/content_detail/content_detail_screen.dart`

#### Layout

```
ContentDetailScreen
├── Stack
│   ├── FullWidthHero (85vh)
│   │   ├── [after 5s] YouTube trailer (autoplay, muted, looped)
│   │   ├── [before 5s] Backdrop image
│   │   ├── Gradient overlay (bottom + side)
│   │   ├── BackButton (top-left)
│   │   └── TrailerMuteButton (bottom-right)
│   │
│   └── ScrollableContent (positioned below hero with overlap)
│       ├── Title + metadata row (rating, year, duration)
│       ├── Genre badges
│       ├── Action buttons:
│       │   ├── [Play Now] → accent pill
│       │   ├── [+ Watchlist] → glass pill
│       │   ├── [♥ Like] → glass pill
│       │   └── [↑ Share] → glass pill
│       │
│       ├── Description text (expandable)
│       │
│       ├── TabBar: Overview | Episodes (series) | Cast | More
│       │
│       ├── [If Series] SeasonSelector + EpisodeList
│       │   ├── Season dropdown
│       │   └── Episode rows (thumbnail + title + duration + play)
│       │
│       ├── Cast horizontal scroll
│       │   └── CastCard: avatar + name + role
│       │
│       └── SimilarContent section row
│
└── [bottom nav pill space]
```

#### Trailer Autoplay Logic

```dart
@override
void initState() {
  super.initState();
  // After 5 seconds, show trailer if videoId exists
  Future.delayed(const Duration(seconds: 5), () {
    if (mounted && _videoId != null) {
      setState(() => _showTrailer = true);
    }
  });
}
```

#### Watchlist Guard

```dart
// Only allow watchlist toggle if authenticated
if (!isAuthenticated) {
  // Show LoginPromptSnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Sign in to add to watchlist')),
  );
  return;
}
```

---

### 6.4 Player Screen

**Route:** `/player/:id`
**File:** `lib/features/player/player_screen.dart`

Full-screen video player. Force landscape orientation. Uses `chewie` + `video_player` or `youtube_player_flutter` for trailers.

```
PlayerScreen (full screen, landscape forced)
├── VideoPlayer (full coverage)
├── Overlay controls (tap to toggle):
│   ├── Top: [←Back] [Title] [Cast icon]
│   ├── Center: [⏮] [⏯ Play/Pause] [⏭]
│   └── Bottom:
│       ├── Progress bar (seekable)
│       ├── Time: 0:00 / 2:14:00
│       └── [🔊] [⛶ Fullscreen] [⚙️ Settings]
```

---

### 6.5 Search Screen

**Route:** `/search`
**File:** `lib/features/search/search_screen.dart`

```
SearchScreen
├── SearchBar (full-width, glass, top)
│   └── Search icon + clear button
├── [empty state] → "Trending Searches" pill grid
├── [typing] → Live results grid (ContentCard 3-col)
└── [results] → Filtered grid with type + genre filters
```

---

### 6.6 Songs Screen

**Route:** `/songs`
**File:** `lib/features/songs/songs_screen.dart`

```
SongsScreen
├── Header: "Music" title + "My Songs" button
├── SearchBar
├── CategoryRows (vertical scroll):
│   ├── "New Music"
│   │   └── Horizontal scroll: SongCards
│   ├── "Pop"
│   │   └── Horizontal scroll: SongCards
│   └── "Hip Hop"
│       └── Horizontal scroll: SongCards
└── [bottom nav space]
```

#### SongCard Widget

```dart
// Square artwork card (140×140 mobile / 180×180 tablet)
// Tap → opens MiniPlayer
Stack(
  children: [
    CachedNetworkImage(imageUrl: song.poster, fit: BoxFit.cover),
    // Bottom gradient
    // Explicit "E" badge (top-left)
    // Play overlay button (center, on hover — use GestureDetector onTap)
  ],
)
Column(
  children: [
    // Song title (bold, truncate)
    // Genre (muted, uppercase, tracking wide)
    // Duration (mm:ss format)
  ],
)
```

---

### 6.7 News Screen

**Route:** `/live-news`
**File:** `lib/features/news/news_screen.dart`
**Access:** Via "More" popup

```
NewsScreen
├── BreakingNewsTicker (marquee, red badge)
│   └── Scrolling headlines
├── FeaturedNewsCard (21:9, full width)
│   └── backdrop image + "LIVE" badge + title + description
└── NewsGrid (2-col mobile / 3-col tablet)
    └── NewsCard: thumbnail + LIVE badge + title + time-ago
```

#### Ticker Marquee

Use `marquee` pub package or `AnimatedBuilder` with a scrolling `Transform.translate`.

---

### 6.8 Pricing Screen

**Route:** `/pricing`
**File:** `lib/features/pricing/pricing_screen.dart`

```
PricingScreen
├── Header: "Choose Your Plan"
├── BillingToggle: [Monthly] [Yearly — Save 20%]
└── PricingCardsRow (horizontal / vertical on mobile)
    ├── Free Card
    ├── Premium Card (highlighted, accent border + glow)
    └── Family Card
        └── Each has: price, feature list, [Subscribe] button
```

#### Plans

| Plan | Monthly | Yearly | Features |
|---|---|---|---|
| Free | ₹0 | ₹0 | Limited movies, ads, 480p |
| Premium | ₹199 | ₹1,999 | All content, no ads, 1080p, 1 screen |
| Family | ₹399 | ₹3,999 | Everything, 4K, 4 screens, downloads |

---

### 6.9 Account Screen

**Route:** `/account`
**Guard:** Redirect to `/login` if not authenticated
**File:** `lib/features/account/account_screen.dart`

```
AccountScreen
├── ProfileHeader: avatar + name + email + subscription badge
├── TabBar: Profile | Watchlist | Settings | Billing
├── Profile Tab:
│   ├── Edit name, email, avatar
│   └── Language/region preferences
├── Watchlist Tab:
│   └── Grid of saved ContentCards
├── Settings Tab:
│   ├── Quality toggle
│   ├── Subtitle toggle
│   └── Autoplay toggle
└── Billing Tab:
    ├── Current plan badge
    └── Upgrade/Downgrade buttons
```

---

### 6.10 Login Screen

**Route:** `/login`

```
LoginScreen (no nav bar)
├── Logo (centered)
├── Glass card:
│   ├── Email field
│   ├── Password field (toggle visibility)
│   ├── [Sign In] button (full width, accent)
│   ├── Divider "or"
│   └── [Continue with Google] (ghost button)
└── Footer: "Don't have an account? Register"
```

---

### 6.11 Register Screen

**Route:** `/register`

```
RegisterScreen (no nav bar)
├── Logo
├── Glass card:
│   ├── Name field
│   ├── Email field
│   ├── Password field
│   ├── Confirm Password field
│   └── [Create Account] button
└── Footer: "Already have an account? Login"
```

---

## 7. "More" Animated Popup Sheet

This replaces the React header's "More" dropdown. In Flutter, it opens as a **bottom sheet** with animated entry — triggered by tapping the "···" or "More" pill tab in the bottom nav.

### Visual Design

```
╭─────────────────────────────────────────────────────────╮
│                ───── drag handle ─────                   │
│                                                          │
│    🎵  Songs           📰  Live News                    │
│    🏷️  Genres          💰  Pricing                     │
│    🔍  Search          ⚙️  Settings                    │
│                                                          │
╰─────────────────────────────────────────────────────────╯
```

### Specification

- **Background:** `rgba(13,16,20,0.97)` + `BackdropFilter(blur: 40)`
- **Border top:** `1px rgba(255,255,255,0.08)` (via decoration)
- **Border radius:** `BorderRadius.vertical(top: Radius.circular(32))`
- **Entry animation:** Slide up from bottom + fade in (250ms, `Curves.easeOutCubic`)
- **Drag handle:** `Container(width:40, height:4, color: white12, borderRadius: 2)`
- **Items:** 2-column grid of icon + label tiles

### Items in "More" Sheet

| Icon | Label | Action |
|---|---|---|
| 🎵 music_note | Songs | Navigate to `/songs` |
| 📰 newspaper | Live News | Navigate to `/live-news` |
| 🏷️ label | Genres | Navigate to `/browse` |
| 💰 monetization_on | Pricing | Navigate to `/pricing` |
| 🔍 search | Search | Navigate to `/search` |
| ⚙️ settings | Settings | Navigate to `/account?tab=settings` |

### Implementation

```dart
// lib/navigation/more_popup_sheet.dart

void showMoreSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
    ),
    builder: (context) => const MorePopupSheet(),
  );
}

class MorePopupSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      backgroundColor: const Color(0xF80D1014),
      blur: 40,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              // Title
              Text('Explore', style: AppTextStyles.sectionTitle),
              const SizedBox(height: 20),
              // 2-col grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: _moreItems.map((item) => _MoreTile(item: item)).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final _MoreItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context); // close sheet
        context.go(item.route);
      },
      child: GlassContainer(
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(item.icon, color: AppColors.accent, size: 20),
              const SizedBox(width: 10),
              Text(item.label, style: AppTextStyles.label.copyWith(
                color: Colors.white,
                letterSpacing: 0.5,
                fontSize: 13,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## 8. Persistent Mini Player Bar

Always rendered above the bottom nav pill. Appears when `playerProvider.currentContent != null`.

### Visual

```
╭────────────────────────────────────────────────────────╮
│  [poster 52×52] Title               [⏮] [⏯] [⏭]  [✕] │
│                 Genre • Type                            │
│  ████████████████░░░░░░░░░░░░░░  progress              │
╰────────────────────────────────────────────────────────╯
```

### Specification

- **Height:** 72px + progress bar (4px) = 76px total
- **Background:** `rgba(8,10,14,0.95)` + blur(32)
- **Border top:** `1px rgba(255,255,255,0.08)`
- **Progress bar:** 4px accent fill, white/10 track
- **Animation:** Slide up from bottom when content starts (AnimatedSlide, 300ms)

### Implementation Note

The MiniPlayer is a `Positioned` widget in the root `Stack` of `AppShell`, always above `BottomNavPill`. When MiniPlayer is visible, `BottomNavPill` gets an additional `bottom` offset of `76px`.

```dart
// lib/shared/providers/player_provider.dart
class PlayerState {
  final Content? currentContent;
  final bool isPlaying;
  final double currentTime;
  final double duration;
  final double volume;
  final bool isMuted;
  final List<Content> queue;
}
```

---

## 9. Data Models

### Content Model

```dart
// lib/data/models/content.dart

enum ContentType { movie, series, shortfilm, song, news }
enum ContentStatus { free, premium, rental, purchase, locked }

class Content {
  final String id;
  final String title;
  final String description;
  final ContentType type;
  final ContentStatus status;
  final double? price;
  final String poster;
  final String backdrop;
  final String? trailer;
  final String? videoUrl;
  final int? duration;         // seconds
  final int releaseYear;
  final String rating;         // "U/A", "A", etc.
  final List<String> languages;
  final List<String> genres;
  final String region;
  final bool isTrending;
  final bool isFeatured;
  final double? tmdbRating;
  final int viewCount;
  // ... cast, crew, tags

  factory Content.fromJson(Map<String, dynamic> json) { ... }
}

class Series extends Content {
  final List<Season> seasons;
  final int totalEpisodes;
}

class Season {
  final String id;
  final int number;
  final String title;
  final List<Episode> episodes;
}

class Episode {
  final String id;
  final int number;
  final String title;
  final String description;
  final int duration;
  final String thumbnail;
  final String videoUrl;
  final ContentStatus status;
  final DateTime airDate;
}

class Song extends Content {
  final String? album;
  final String artist;
  final String? lyrics;
}
```

### User Model

```dart
class User {
  final String id;
  final String email;
  final String name;
  final String? avatar;
  final UserRole role;
  final SubscriptionType subscription;
  final DateTime? subscriptionExpiry;
  final UserPreferences preferences;
}

enum UserRole { viewer, actor, manager, admin }
enum SubscriptionType { free, premium, family }

class UserPreferences {
  final List<String> languages;
  final List<String> genres;
  final List<String> regions;
  final bool autoplay;
  final bool subtitles;
  final VideoQuality quality;
}
```

---

## 10. State Management

Using **Riverpod** (StateNotifierProvider / AsyncNotifierProvider).

### Auth Provider

```dart
// lib/shared/providers/auth_provider.dart

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() => const AuthState(user: null, isAuthenticated: false);

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await ref.read(authServiceProvider).login(email, password);
      state = state.copyWith(user: user, isAuthenticated: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> logout() async {
    await ref.read(authServiceProvider).logout();
    state = const AuthState(user: null, isAuthenticated: false);
  }

  Future<void> checkAuth() async {
    final user = await ref.read(authServiceProvider).getCurrentUser();
    if (user != null) state = state.copyWith(user: user, isAuthenticated: true);
  }
}
```

### Player Provider

```dart
@riverpod
class PlayerNotifier extends _$PlayerNotifier {
  @override
  PlayerState build() => const PlayerState();

  void openPlayer(Content content) {
    state = state.copyWith(
      currentContent: content,
      isPlaying: true,
      currentTime: 0,
    );
  }

  void closePlayer() {
    state = const PlayerState();
  }

  void play() => state = state.copyWith(isPlaying: true);
  void pause() => state = state.copyWith(isPlaying: false);
  void seek(double seconds) => state = state.copyWith(currentTime: seconds);
  void setVolume(double v) => state = state.copyWith(volume: v);
  void toggleMute() => state = state.copyWith(isMuted: !state.isMuted);
}
```

### TMDB Query Providers

```dart
@riverpod
Future<List<Content>> trending(TrendingRef ref) {
  return ref.read(tmdbServiceProvider).getTrending();
}

@riverpod
Future<List<Content>> popularMovies(PopularMoviesRef ref) {
  return ref.read(tmdbServiceProvider).getPopularMovies();
}
// ... etc.
```

---

## 11. Services & API Integration

### TMDB Service

```dart
// lib/data/services/tmdb_service.dart

class TmdbService {
  static const _baseUrl = 'https://api.themoviedb.org/3';
  static const _imageBase = 'https://image.tmdb.org/t/p';
  // API key from .env

  Future<List<Content>> getTrending() async { ... }
  Future<List<Content>> getPopularMovies() async { ... }
  Future<List<Content>> getPopularSeries() async { ... }
  Future<List<Content>> getFeatured() async { ... }
  Future<List<Content>> getNowPlaying() async { ... }
  Future<List<Content>> getTopRated() async { ... }
  Future<Content> getMovieDetails(int id) async { ... }
  Future<Series> getSeriesDetails(int id) async { ... }
  Future<List<Episode>> getSeasonDetails(int seriesId, int season) async { ... }
  Future<List<Content>> getSimilarMovies(int id) async { ... }
  Future<List<Content>> getSimilarSeries(int id) async { ... }

  // Image URL helpers
  String posterUrl(String path, {String size = 'w342'}) =>
      '$_imageBase/$size$path';
  String backdropUrl(String path, {String size = 'w1280'}) =>
      '$_imageBase/$size$path';
}
```

### Auth Service

```dart
// lib/data/services/auth_service.dart
// Uses shared_preferences for token persistence

class AuthService {
  Future<User> login(String email, String password) async { ... }
  Future<User> register(String email, String password, String name) async { ... }
  Future<void> logout() async { ... }
  Future<User?> getCurrentUser() async { ... }
}
```

---

## 12. Animations Specification

### Hero Section Entry (Home Screen)

| Element | From | To | Duration | Delay | Curve |
|---|---|---|---|---|---|
| Backdrop | opacity 0, scale 1.08 | opacity 1, scale 1 | 1400ms | 0 | easeOutCubic |
| Glow overlay | opacity 0, scale 0.8 | opacity 1, scale 1 | 1000ms | 600ms | easeOut |
| Left content | x -40px, opacity 0 | x 0, opacity 1 | 1000ms | 1000ms | easeOutCubic |
| Title | y 30px, opacity 0 | y 0, opacity 1 | 800ms | 900ms | easeOut |
| CTA buttons | y 20px, opacity 0 | stagger +120ms each | 600ms | 1100ms | easeOut |

```dart
// Use flutter_animate for clean chained animations:
Image(...)
  .animate()
  .fadeIn(duration: 1400.ms, curve: Curves.easeOutCubic)
  .scaleXY(begin: 1.08, end: 1.0, duration: 1400.ms);

heroContent
  .animate()
  .slideX(begin: -0.1, duration: 1000.ms, delay: 600.ms, curve: Curves.easeOutCubic)
  .fadeIn(delay: 600.ms);
```

### Scroll Section Reveal

```dart
// Use visibility_detector + animate
VisibilityDetector(
  key: Key('section-$title'),
  onVisibilityChanged: (info) {
    if (info.visibleFraction > 0.1) {
      setState(() => _visible = true);
    }
  },
  child: AnimatedOpacity(
    duration: 800.ms,
    opacity: _visible ? 1.0 : 0.0,
    child: AnimatedSlide(
      duration: 800.ms,
      offset: _visible ? Offset.zero : const Offset(0, 0.1),
      child: sectionWidget,
    ),
  ),
);
```

### ContentCard Hover (press simulation on mobile)

```dart
GestureDetector(
  onTapDown: (_) => setState(() => _pressed = true),
  onTapUp: (_) => setState(() => _pressed = false),
  onTapCancel: () => setState(() => _pressed = false),
  child: AnimatedScale(
    scale: _pressed ? 0.95 : 1.0,
    duration: 150.ms,
    child: ContentCard(...),
  ),
)
```

### Bottom Sheet "More" Entry

```dart
// showModalBottomSheet already handles the slide-up
// Additional internal animation via flutter_animate:
Column(children: items)
  .animate()
  .fadeIn(duration: 250.ms, curve: Curves.easeOutCubic)
  .slideY(begin: 0.1, end: 0, duration: 250.ms);
```

### Top 10 Number Hover Effect

```dart
// On content card press:
AnimatedScale(scale: _pressed ? 1.0 : 0.95, ...)
AnimatedOpacity(opacity: _pressed ? 1.0 : 0.6, ...)
// The number goes from opacity 0.6 to 1.0 on press
```

---

## 13. Component Library

### ContentCard

```dart
// lib/shared/widgets/content_card.dart
// Poster-style card (2:3 ratio)

class ContentCard extends StatefulWidget {
  final Content content;
  final VoidCallback? onTap;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/content/${content.id}'),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(imageUrl: content.poster, fit: BoxFit.cover),
              // Status badge (FREE / PREMIUM)
              // Bottom gradient + title
              // Hover overlay with play icon
            ],
          ),
        ),
      ),
    );
  }
}
```

### GenreChip

```dart
class GenreChip extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : AppColors.glassBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.glassBorder,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: AppTextStyles.label.copyWith(
            color: isActive ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
```

### SkeletonLoader

```dart
class SkeletonCard extends StatefulWidget {
  // Shimmer animation using shimmer package
  // Aspect ratio 2:3 for content cards
  // Square for song cards
}
```

### LiveBadge

```dart
class LiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        ),
        borderRadius: BorderRadius.circular(6),
        boxShadow: [BoxShadow(color: Colors.red.withOpacity(0.4), blurRadius: 8)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated blinking dot
          _BlinkingDot(),
          const SizedBox(width: 4),
          const Text('LIVE', style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          )),
        ],
      ),
    );
  }
}
```

### RatingBadge

```dart
class RatingBadge extends StatelessWidget {
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.glassAccent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, color: AppColors.accent, size: 14),
          const SizedBox(width: 4),
          Text('$rating', style: AppTextStyles.label.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
```

---

## 14. Flutter File Structure

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── router/
│   │   └── app_router.dart         # GoRouter with auth redirect
│   └── utils/
│       ├── format_utils.dart       # formatDuration, formatTimeAgo
│       └── extensions.dart
│
├── data/
│   ├── models/
│   │   ├── content.dart
│   │   ├── user.dart
│   │   ├── series.dart
│   │   ├── episode.dart
│   │   └── season.dart
│   ├── services/
│   │   ├── tmdb_service.dart
│   │   ├── auth_service.dart
│   │   ├── content_service.dart    # songs, news
│   │   └── payment_service.dart
│   └── repositories/
│       ├── content_repository.dart
│       └── user_repository.dart
│
├── features/
│   ├── home/
│   │   ├── home_screen.dart
│   │   ├── widgets/
│   │   │   ├── hero_section.dart
│   │   │   ├── top10_section.dart
│   │   │   ├── editors_choice_section.dart
│   │   │   ├── feature_promo_card.dart
│   │   │   └── cta_banner.dart
│   │   └── home_provider.dart
│   │
│   ├── browse/
│   │   ├── browse_screen.dart
│   │   └── browse_provider.dart
│   │
│   ├── content_detail/
│   │   ├── content_detail_screen.dart
│   │   ├── widgets/
│   │   │   ├── episode_list.dart
│   │   │   ├── season_selector.dart
│   │   │   ├── cast_row.dart
│   │   │   └── action_buttons.dart
│   │   └── content_detail_provider.dart
│   │
│   ├── player/
│   │   ├── player_screen.dart
│   │   └── player_controls.dart
│   │
│   ├── search/
│   │   └── search_screen.dart
│   │
│   ├── songs/
│   │   ├── songs_screen.dart
│   │   └── widgets/
│   │       └── song_card.dart
│   │
│   ├── news/
│   │   ├── news_screen.dart
│   │   └── widgets/
│   │       ├── news_ticker.dart
│   │       └── news_card.dart
│   │
│   ├── pricing/
│   │   ├── pricing_screen.dart
│   │   └── widgets/
│   │       └── pricing_card.dart
│   │
│   ├── account/
│   │   └── account_screen.dart
│   │
│   └── auth/
│       ├── login_screen.dart
│       └── register_screen.dart
│
├── navigation/
│   ├── app_shell.dart              # Root scaffold with nav + player
│   ├── bottom_nav_pill.dart
│   └── more_popup_sheet.dart
│
└── shared/
    ├── widgets/
    │   ├── content_card.dart
    │   ├── section_row.dart
    │   ├── glass_container.dart
    │   ├── skeleton_loader.dart
    │   ├── genre_chip.dart
    │   ├── live_badge.dart
    │   ├── rating_badge.dart
    │   └── mini_player_bar.dart
    └── providers/
        ├── auth_provider.dart
        ├── player_provider.dart
        └── ui_provider.dart
```

---

## 15. Dependencies

```yaml
# pubspec.yaml

dependencies:
  flutter:
    sdk: flutter

  # Navigation
  go_router: ^14.0.0

  # State management
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # Networking
  dio: ^5.4.0
  cached_network_image: ^3.3.0

  # UI & Styling
  google_fonts: ^6.2.0                 # Sora font
  flutter_animate: ^4.5.0             # GSAP-equivalent animations
  shimmer: ^3.0.0                      # Skeleton loaders
  marquee: ^2.2.0                      # News ticker

  # Video/Audio
  youtube_player_flutter: ^9.0.0      # YouTube trailer
  chewie: ^1.7.0                       # Video player controls
  video_player: ^2.8.0

  # Glassmorphism
  # BackdropFilter is native Flutter — no extra package needed

  # Storage / Auth
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0

  # Utilities
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0
  visibility_detector: ^0.4.0+2       # Scroll reveal trigger
  intl: ^0.19.0

dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  riverpod_generator: ^2.3.0
```

---

## Appendix A: GoRouter Configuration

```dart
// lib/core/router/app_router.dart

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final isAuth = ref.read(authProvider).isAuthenticated;
    final isAuthRoute = state.location == '/login' || state.location == '/register';
    if (!isAuth && !isAuthRoute) return '/login';
    if (isAuth && isAuthRoute) return '/';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
    ShellRoute(
      builder: (ctx, state, child) => AppShell(child: child),
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/browse', builder: (_, state) => BrowseScreen(
          type: state.queryParameters['type'],
          sort: state.queryParameters['sort'],
        )),
        GoRoute(path: '/content/:id', builder: (_, state) =>
            ContentDetailScreen(id: state.pathParameters['id']!)),
        GoRoute(path: '/player/:id', builder: (_, state) =>
            PlayerScreen(id: state.pathParameters['id']!)),
        GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
        GoRoute(path: '/songs', builder: (_, __) => const SongsScreen()),
        GoRoute(path: '/live-news', builder: (_, __) => const NewsScreen()),
        GoRoute(path: '/pricing', builder: (_, __) => const PricingScreen()),
        GoRoute(path: '/account', builder: (_, state) => AccountScreen(
          tab: state.queryParameters['tab'],
        )),
      ],
    ),
  ],
);
```

---

## Appendix B: AppShell — Root Scaffold

```dart
// lib/navigation/app_shell.dart

class AppShell extends ConsumerStatefulWidget {
  final Widget child;

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;

  final _routes = ['/', '/browse?type=movie', '/browse?type=series', '/songs'];

  @override
  Widget build(BuildContext context) {
    final playerState = ref.watch(playerProvider);
    final hasPlayer = playerState.currentContent != null;

    return Scaffold(
      backgroundColor: AppColors.bgBase,
      extendBody: true,                          // allows content behind bottom nav
      body: Stack(
        children: [
          // Main page content
          widget.child,

          // Mini player bar (slides up when content is playing)
          if (hasPlayer)
            Positioned(
              bottom: 88 + MediaQuery.of(context).padding.bottom,
              left: 0, right: 0,
              child: const MiniPlayerBar(),
            ),

          // Bottom nav pill
          BottomNavPill(
            currentIndex: _currentIndex,
            onTabTapped: (i) {
              setState(() => _currentIndex = i);
              context.go(_routes[i]);
            },
            onMoreTapped: () => showMoreSheet(context),
          ),
        ],
      ),
    );
  }
}
```

---

*Documentation Version: 1.0*
*Last Updated: April 2026*
*React Source: Camcine Web App (src.zip)*