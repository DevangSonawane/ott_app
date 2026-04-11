import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/movie.dart';
import '../providers/content_provider.dart';
import '../providers/app_content_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/content_grid.dart';
import '../widgets/movie_detail_modal.dart';

class MoviesScreen extends ConsumerWidget {
  const MoviesScreen({super.key});

  void _open(BuildContext context, WidgetRef ref, Movie movie) {
    ref.read(contentProvider.notifier).selectMovie(movie);
    showMovieDetailModal(context, movie);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPadding = MediaQuery.of(context).padding.top + 70 + 16;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 80;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0, topPadding, 0, bottomPadding),
      child: ref.watch(hollywoodProvider).when(
            data: (items) => ContentGrid(
              title: 'Movies',
              subtitle: 'Trending now',
              contents: items,
              onSelect: (m) => _open(context, ref, m),
            ),
            loading: () => const ContentGrid(
              title: 'Movies',
              subtitle: 'Trending now',
              contents: const <Movie>[],
              onSelect: _noopMovieSelect,
              loadingSkeleton: true,
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Unable to load movies.',
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
