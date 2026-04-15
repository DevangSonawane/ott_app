import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/movie.dart';
import '../providers/content_provider.dart';
import '../providers/app_content_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/content_grid.dart';

class TvScreen extends ConsumerWidget {
  const TvScreen({super.key});

  void _open(BuildContext context, WidgetRef ref, Movie movie) {
    ref.read(contentProvider.notifier).selectMovie(movie);
    context.push('/content/${movie.id}');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPadding = MediaQuery.of(context).padding.top + 70 + 16;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 80;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0, topPadding, 0, bottomPadding),
      child: ref.watch(trendingTvProvider).when(
            data: (items) => ContentGrid(
              title: 'TV Shows',
              subtitle: 'Trending series',
              contents: items,
              onSelect: (m) => _open(context, ref, m),
            ),
            loading: () => const ContentGrid(
              title: 'TV Shows',
              subtitle: 'Trending series',
              contents: <Movie>[],
              loadingSkeleton: true,
              onSelect: _noopMovieSelect,
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Unable to load TV shows.',
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

void _noopMovieSelect(Movie _) {}
