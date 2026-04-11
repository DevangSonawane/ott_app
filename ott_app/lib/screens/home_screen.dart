import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie.dart';
import '../providers/content_provider.dart';
import '../providers/app_content_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/content_row.dart';
import '../widgets/footer.dart';
import '../widgets/hero_slider.dart';
import '../widgets/movie_detail_modal.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, WidgetRef ref, Movie movie) {
    ref.read(contentProvider.notifier).selectMovie(movie);
    showMovieDetailModal(context, movie);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final heroHeight = (size.height * 0.70).clamp(420.0, 680.0);

    final continueRow = ref.watch(continueWatchingProvider).when(
          data: (items) => ContentRow(
            title: 'Continue Watching',
            subtitle: 'Pick up where you left off',
            contents: items,
            variant: ContentRowVariant.continueWatching,
            onSelect: (m) => _open(context, ref, m),
          ),
          loading: () => ContentRow(
            title: 'Continue Watching',
            subtitle: 'Pick up where you left off',
            contents: const <Movie>[],
            variant: ContentRowVariant.continueWatching,
            loadingSkeleton: true,
            onSelect: (_) {},
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Unable to load content. ($e)',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: AppColors.textMuted),
            ),
          ),
        );

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
            child: SizedBox(
              height: heroHeight,
              child: HeroSlider(height: heroHeight),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 18),
              child: continueRow,
            ),
          ),
          SliverToBoxAdapter(
            child: ref.watch(bollywoodProvider).when(
                  data: (items) => ContentRow(
                    title: 'Top 10 Bollywood Movies',
                    contents: items.take(10).toList(growable: false),
                    variant: ContentRowVariant.defaultPoster,
                    onSelect: (m) => _open(context, ref, m),
                    showFilter: true,
                  ),
                  loading: () => ContentRow(
                    title: 'Top 10 Bollywood Movies',
                    contents: const <Movie>[],
                    variant: ContentRowVariant.defaultPoster,
                    loadingSkeleton: true,
                    onSelect: (_) {},
                    showFilter: true,
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Unable to load content. ($e)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
          ),
          SliverToBoxAdapter(
            child: ref.watch(indianSeriesProvider).when(
                  data: (items) => ContentRow(
                    title: 'Indian Web Series',
                    contents: items,
                    variant: ContentRowVariant.defaultPoster,
                    onSelect: (m) => _open(context, ref, m),
                    showFilter: true,
                  ),
                  loading: () => ContentRow(
                    title: 'Indian Web Series',
                    contents: const <Movie>[],
                    variant: ContentRowVariant.defaultPoster,
                    loadingSkeleton: true,
                    onSelect: (_) {},
                    showFilter: true,
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Unable to load content. ($e)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
          ),
          SliverToBoxAdapter(
            child: ref.watch(hollywoodProvider).when(
                  data: (items) => ContentRow(
                    title: 'Top Hollywood',
                    contents: items,
                    variant: ContentRowVariant.defaultPoster,
                    onSelect: (m) => _open(context, ref, m),
                    showFilter: true,
                  ),
                  loading: () => ContentRow(
                    title: 'Top Hollywood',
                    contents: const <Movie>[],
                    variant: ContentRowVariant.defaultPoster,
                    loadingSkeleton: true,
                    onSelect: (_) {},
                    showFilter: true,
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Unable to load content. ($e)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
          ),
          SliverToBoxAdapter(
            child: ref.watch(dramaProvider).when(
                  data: (items) => ContentRow(
                    title: 'Drama Series',
                    contents: items,
                    variant: ContentRowVariant.defaultPoster,
                    onSelect: (m) => _open(context, ref, m),
                    showFilter: true,
                  ),
                  loading: () => ContentRow(
                    title: 'Drama Series',
                    contents: const <Movie>[],
                    variant: ContentRowVariant.defaultPoster,
                    loadingSkeleton: true,
                    onSelect: (_) {},
                    showFilter: true,
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Unable to load content. ($e)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
          ),
          SliverToBoxAdapter(
            child: ref.watch(top10Provider).when(
                  data: (items) => ContentRow(
                    title: 'Top 10 in India',
                    subtitle: 'Today in India',
                    contents: items,
                    variant: ContentRowVariant.top10,
                    onSelect: (m) => _open(context, ref, m),
                  ),
                  loading: () => ContentRow(
                    title: 'Top 10 in India',
                    subtitle: 'Today in India',
                    contents: const <Movie>[],
                    variant: ContentRowVariant.top10,
                    loadingSkeleton: true,
                    onSelect: (_) {},
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Unable to load content. ($e)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
          ),
          SliverToBoxAdapter(
            child: ref.watch(actionProvider).when(
                  data: (items) => ContentRow(
                    title: 'Action',
                    contents: items,
                    variant: ContentRowVariant.defaultPoster,
                    onSelect: (m) => _open(context, ref, m),
                    showFilter: true,
                  ),
                  loading: () => ContentRow(
                    title: 'Action',
                    contents: const <Movie>[],
                    variant: ContentRowVariant.defaultPoster,
                    loadingSkeleton: true,
                    onSelect: (_) {},
                    showFilter: true,
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Unable to load content. ($e)',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                ),
          ),
          const SliverToBoxAdapter(child: Footer()),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
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
