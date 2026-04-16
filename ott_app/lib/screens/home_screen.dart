import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/movie.dart';
import '../providers/content_provider.dart';
import '../providers/app_content_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/content_row.dart';
import '../widgets/home_header.dart';
import '../widgets/app_image.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, WidgetRef ref, Movie movie) {
    ref.read(contentProvider.notifier).selectMovie(movie);
    context.push('/content/${movie.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      color: AppColors.accent,
      strokeWidth: 2.5,
      onRefresh: () async {
        await Future<void>.delayed(const Duration(milliseconds: 450));
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(
            child: const HomeHeader(),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 6),
              child: ref.watch(top10Provider).when(
                    data: (items) => ContentRow(
                      title: 'Top 10',
                      contents: items,
                      variant: ContentRowVariant.top10,
                      onSelect: (m) => _open(context, ref, m),
                    ),
                    loading: () => ContentRow(
                      title: 'Top 10',
                      contents: const <Movie>[],
                      variant: ContentRowVariant.top10,
                      loadingSkeleton: true,
                      onSelect: (_) {},
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Unable to load Top 10. ($e)',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.textMuted),
                      ),
                    ),
                  ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 6),
              child: ref.watch(trendingProvider).when(
                    data: (items) => ContentRow(
                      title: 'Trending Now',
                      contents: items.take(12).toList(growable: false),
                      variant: ContentRowVariant.defaultPoster,
                      onSelect: (m) => _open(context, ref, m),
                      actionLabel: 'All',
                      onActionTap: () => context.go('/browse?type=all'),
                    ),
                    loading: () => ContentRow(
                      title: 'Trending Now',
                      contents: const <Movie>[],
                      variant: ContentRowVariant.defaultPoster,
                      loadingSkeleton: true,
                      onSelect: (_) {},
                      actionLabel: 'All',
                      onActionTap: () => context.go('/browse?type=all'),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Unable to load Trending Now. ($e)',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.textMuted),
                      ),
                    ),
                  ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 18, bottom: 6),
              child: _FeaturedSection(onSelect: (m) => _open(context, ref, m)),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 6),
              child: ref.watch(popularMoviesProvider).when(
                    data: (items) => ContentRow(
                      title: 'Popular Movies',
                      contents: items,
                      variant: ContentRowVariant.defaultPoster,
                      onSelect: (m) => _open(context, ref, m),
                      actionLabel: 'All',
                      onActionTap: () => context.go('/browse?type=movie'),
                    ),
                    loading: () => ContentRow(
                      title: 'Popular Movies',
                      contents: const <Movie>[],
                      variant: ContentRowVariant.defaultPoster,
                      loadingSkeleton: true,
                      onSelect: (_) {},
                      actionLabel: 'All',
                      onActionTap: () => context.go('/browse?type=movie'),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Unable to load Popular Movies. ($e)',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.textMuted),
                      ),
                    ),
                  ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 6),
              child: ref.watch(nowPlayingProvider).when(
                    data: (items) => ContentRow(
                      title: 'Now Playing',
                      contents: items,
                      variant: ContentRowVariant.defaultPoster,
                      onSelect: (m) => _open(context, ref, m),
                      actionLabel: 'All',
                      onActionTap: () => context.go('/browse?type=movie'),
                    ),
                    loading: () => ContentRow(
                      title: 'Now Playing',
                      contents: const <Movie>[],
                      variant: ContentRowVariant.defaultPoster,
                      loadingSkeleton: true,
                      onSelect: (_) {},
                      actionLabel: 'All',
                      onActionTap: () => context.go('/browse?type=movie'),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Unable to load Now Playing. ($e)',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.textMuted),
                      ),
                    ),
                  ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 14, bottom: 6),
              child: ref.watch(tvSeriesProvider).when(
                    data: (items) => ContentRow(
                      title: 'TV Series',
                      contents: items,
                      variant: ContentRowVariant.defaultPoster,
                      onSelect: (m) => _open(context, ref, m),
                      actionLabel: 'All',
                      onActionTap: () => context.go('/browse?type=series'),
                    ),
                    loading: () => ContentRow(
                      title: 'TV Series',
                      contents: const <Movie>[],
                      variant: ContentRowVariant.defaultPoster,
                      loadingSkeleton: true,
                      onSelect: (_) {},
                      actionLabel: 'All',
                      onActionTap: () => context.go('/browse?type=series'),
                    ),
                    error: (e, _) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Unable to load TV Series. ($e)',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.textMuted),
                      ),
                    ),
                  ),
            ),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(height: 12),
          ),
          SliverToBoxAdapter(
            child: ref.watch(spotlightPickProvider).when(
                  data: (movie) => movie == null
                      ? const SizedBox.shrink()
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 26),
                          child: _SpotlightCard(movie: movie),
                        ),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + 80,
            ),
            sliver: const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}

class _FeaturedSection extends ConsumerWidget {
  const _FeaturedSection({required this.onSelect});

  final ValueChanged<Movie> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final featuredAsync = ref.watch(featuredProvider);
    final popularAsync = ref.watch(popularMoviesProvider);

    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      child: featuredAsync.when(
        data: (featured) {
          final popular = popularAsync.valueOrNull ?? const <Movie>[];
          final row =
              [...featured, ...popular].take(8).toList(growable: false);
          return _BigHeadingSection(
            title: 'FEATURED',
            subtitle: 'MOVIES',
            pillText: 'Featured',
            items: row,
            onSelect: onSelect,
          );
        },
        loading: () => _BigHeadingSection(
          title: 'FEATURED',
          subtitle: 'MOVIES',
          pillText: 'Featured',
          items: const <Movie>[],
          onSelect: onSelect,
          loadingSkeleton: true,
        ),
        error: (e, _) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Unable to load Featured. ($e)',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textMuted),
          ),
        ),
      ),
    );
  }
}

class _BigHeadingSection extends StatelessWidget {
  const _BigHeadingSection({
    required this.title,
    required this.subtitle,
    required this.pillText,
    required this.items,
    required this.onSelect,
    this.loadingSkeleton = false,
  });

  final String title;
  final String subtitle;
  final String pillText;
  final List<Movie> items;
  final ValueChanged<Movie> onSelect;
  final bool loadingSkeleton;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 720;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: isWide ? 76 : 48,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            height: 0.9,
                            letterSpacing: -1.0,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 2.0
                              ..color = AppColors.accent,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 6.0,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 340,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              if (loadingSkeleton) {
                return Container(
                  width: 220,
                  height: 320,
                  decoration: BoxDecoration(
                    color: AppColors.overlay,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                );
              }
              final m = items[index];
              return SizedBox(
                width: 220,
                child: GestureDetector(
                  onTap: () => onSelect(m),
                  child: _LargePosterCard(movie: m),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemCount: loadingSkeleton ? 6 : items.length,
          ),
        ),
      ],
    );
  }
}

class _LargePosterCard extends ConsumerWidget {
  const _LargePosterCard({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We keep this light-weight: a large poster with the same overlay meta style.
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AppImage(source: movie.image, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.92),
                  Colors.black.withOpacity(0.25),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 1.05,
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      movie.type == 'series' ? 'TV' : '${movie.year}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white.withOpacity(0.45),
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.6,
                          ),
                    ),
                    const Spacer(),
                    if (movie.rating != null)
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 16, color: AppColors.accent),
                          const SizedBox(width: 2),
                          Text(
                            (movie.rating! * 10).toStringAsFixed(1),
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.white.withOpacity(0.70),
                                      fontWeight: FontWeight.w900,
                                    ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SpotlightCard extends StatelessWidget {
  const _SpotlightCard({required this.movie});
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/content/${movie.id}'),
      borderRadius: BorderRadius.circular(32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          height: 420,
          color: AppColors.backgroundSecondary,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppImage(source: movie.image, fit: BoxFit.cover),
              Container(color: Colors.black.withOpacity(0.45)),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xC806080A),
                      Color(0x7A06080A),
                      Color(0xC806080A),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      AppColors.background.withOpacity(0.65),
                      Colors.transparent,
                      AppColors.background.withOpacity(0.20),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: AppColors.accentSubtle,
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                                color: AppColors.accent.withOpacity(0.40)),
                          ),
                          child: Text(
                            'Spotlight Pick'.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                  color: Colors.white.withOpacity(0.85),
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.0,
                                ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          movie.title.toUpperCase(),
                          textAlign: TextAlign.right,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                height: 0.92,
                              ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          movie.description,
                          textAlign: TextAlign.right,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withOpacity(0.75),
                                height: 1.4,
                              ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (movie.rating != null) ...[
                              const Icon(Icons.star_rounded,
                                  size: 18, color: AppColors.accent),
                              const SizedBox(width: 4),
                              Text(
                                (movie.rating! * 10).toStringAsFixed(1),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.70),
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: 2.0,
                                    ),
                              ),
                              const SizedBox(width: 12),
                            ],
                            Text(
                              movie.type == 'series' ? 'TV' : '${movie.year}',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: Colors.white.withOpacity(0.45),
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 2.0,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          alignment: WrapAlignment.end,
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 12),
                              decoration: BoxDecoration(
                                color: AppColors.background.withOpacity(0.45),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: AppColors.accent),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentGlow,
                                    blurRadius: 24,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.play_arrow_rounded,
                                      color: Colors.white, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Watch Now'.toUpperCase(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 2.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            if (MediaQuery.of(context).size.width >= 420)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.06),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Explore'.toUpperCase(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(
                                            color:
                                                Colors.white.withOpacity(0.70),
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 2.0,
                                          ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.arrow_outward_rounded,
                                        size: 16,
                                        color: Colors.white70),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
