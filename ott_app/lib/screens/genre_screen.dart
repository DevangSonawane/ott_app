import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../data/content_data.dart';
import '../models/movie.dart';
import '../providers/content_provider.dart';
import '../providers/app_content_provider.dart';
import '../theme/app_colors.dart';
import '../utils/extensions.dart';
import '../widgets/content_row.dart';
import '../widgets/footer.dart';
import '../widgets/hero_slider.dart';
import '../widgets/movie_detail_modal.dart';

class GenreScreen extends ConsumerStatefulWidget {
  const GenreScreen({super.key, required this.genreId});
  final String genreId;

  @override
  ConsumerState<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends ConsumerState<GenreScreen> {
  late String _genreId = widget.genreId;

  void _open(Movie movie) {
    ref.read(contentProvider.notifier).selectMovie(movie);
    showMovieDetailModal(context, movie);
  }

  @override
  void didUpdateWidget(covariant GenreScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.genreId != widget.genreId) {
      _genreId = widget.genreId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentAsync = ref.watch(genreContentProvider(_genreId));
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(height: 420, child: const HeroSlider()),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back_rounded,
                      color: AppColors.textPrimary),
                  const SizedBox(width: 6),
                  Text(
                    'Back to Home',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textPrimary),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPersistentHeader(
          pinned: true,
          delegate: _GenreHeader(
            currentId: _genreId,
            onSelect: (id) {
              Haptics.selection();
              context.go('/genre/$id');
            },
          ),
        ),
        SliverToBoxAdapter(
          child: const Gap(12),
        ),
        SliverToBoxAdapter(
          child: contentAsync.when(
            data: (content) {
              if (content.isEmpty) return _emptyState(context);
              return ContentRow(
                title: genres
                    .firstWhere((g) => g.id == _genreId,
                        orElse: () => genres.first)
                    .name,
                contents: content,
                variant: ContentRowVariant.defaultPoster,
                onSelect: _open,
                showFilter: true,
              );
            },
            loading: () => ContentRow(
              title: genres
                  .firstWhere((g) => g.id == _genreId,
                      orElse: () => genres.first)
                  .name,
              contents: const <Movie>[],
              variant: ContentRowVariant.defaultPoster,
              onSelect: (_) {},
              showFilter: true,
              loadingSkeleton: true,
            ),
            error: (_, __) => _emptyState(context),
          ),
        ),
        const SliverToBoxAdapter(child: Footer()),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
        SliverPadding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 80),
          sliver: const SliverToBoxAdapter(child: SizedBox.shrink()),
        ),
      ],
    );
  }

  Widget _emptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            'No content available in this genre yet.',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textMuted),
            textAlign: TextAlign.center,
          ),
          const Gap(14),
          InkWell(
            onTap: () => context.go('/'),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Text(
                'Browse All Content',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenreHeader extends SliverPersistentHeaderDelegate {
  _GenreHeader({required this.currentId, required this.onSelect});

  final String currentId;
  final ValueChanged<String> onSelect;

  @override
  double get minExtent => 56;

  @override
  double get maxExtent => 56;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.background.withOpacity(0.92),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final g = genres[index];
          final active = g.id == currentId;
          return InkWell(
            onTap: () => onSelect(g.id),
            borderRadius: BorderRadius.circular(999),
            child: AnimatedContainer(
              duration: 200.ms,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: active ? AppColors.accent : AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Text(
                g.name,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: active ? Colors.white : AppColors.textMuted,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemCount: genres.length,
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _GenreHeader oldDelegate) {
    return oldDelegate.currentId != currentId;
  }
}
