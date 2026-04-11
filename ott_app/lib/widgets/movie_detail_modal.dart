import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../models/movie.dart';
import '../providers/app_content_provider.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';
import 'app_image.dart';
import 'gradient_button.dart';
import 'shimmer_placeholder.dart';

Future<void> showMovieDetailModal(BuildContext context, Movie movie) async {
  final isTablet =
      MediaQuery.of(context).size.width >= AppBreakpoints.tabletMin;
  if (isTablet) {
    await showDialog<void>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: _MovieDetailDialog(movie: movie),
      ),
    );
    return;
  }

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.95,
        minChildSize: 0.35,
        builder: (context, scrollController) {
          return _MovieDetailSheet(
              movie: movie, scrollController: scrollController);
        },
      );
    },
  );
}

class _MovieDetailDialog extends StatefulWidget {
  const _MovieDetailDialog({required this.movie});
  final Movie movie;

  @override
  State<_MovieDetailDialog> createState() => _MovieDetailDialogState();
}

class _MovieDetailDialogState extends State<_MovieDetailDialog> {
  late Movie _movie = widget.movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(18),
            child: SingleChildScrollView(
              child: _MovieDetailBody(
                movie: _movie,
                onSelectSimilar: (m) => setState(() => _movie = m),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon:
                  const Icon(Icons.close_rounded, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 220.ms).scaleXY(begin: 0.98, end: 1);
  }
}

class _MovieDetailSheet extends StatefulWidget {
  const _MovieDetailSheet(
      {required this.movie, required this.scrollController});
  final Movie movie;
  final ScrollController scrollController;

  @override
  State<_MovieDetailSheet> createState() => _MovieDetailSheetState();
}

class _MovieDetailSheetState extends State<_MovieDetailSheet> {
  late Movie _movie = widget.movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardElevated,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Stack(
        children: [
          ListView(
            controller: widget.scrollController,
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const Gap(12),
              _MovieDetailBody(
                movie: _movie,
                onSelectSimilar: (m) => setState(() => _movie = m),
              ),
              const Gap(16),
            ],
          ),
          Positioned(
            top: 6,
            right: 6,
            child: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon:
                  const Icon(Icons.close_rounded, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 220.ms).slideY(begin: 0.08, end: 0);
  }
}

class _MovieDetailBody extends ConsumerWidget {
  const _MovieDetailBody({required this.movie, required this.onSelectSimilar});

  final Movie movie;
  final ValueChanged<Movie> onSelectSimilar;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(allContentProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Hero(
              tag: 'modal-${movie.id}',
              child: AppImage(
                source: movie.image,
                fit: BoxFit.cover,
                placeholderBorderRadius: 16,
              ),
            ),
          ),
        ),
        const Gap(14),
        Text(
          movie.title,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
        ),
        const Gap(8),
        Text(
          movie.description,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textSecondary),
        ),
        const Gap(14),
        Row(
          children: [
            Expanded(
              child: GradientButton(
                label: 'Watch Video',
                icon: Icons.play_arrow_rounded,
                height: 48,
                borderRadius: 14,
                onTap: () {},
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GradientButton(
                label: 'Rent 1 Day • ₹49',
                icon: Icons.shopping_bag_outlined,
                height: 48,
                borderRadius: 14,
                onTap: () {},
              ),
            ),
          ],
        ),
        const Gap(18),
        Text(
          'Similar Movies',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
        ),
        const Gap(10),
        SizedBox(
          height: 225,
          child: allAsync.when(
            data: (all) {
              final related = all
                  .where((m) =>
                      m.id != movie.id &&
                      m.genre.isNotEmpty &&
                      movie.genre.any((g) => m.genre.contains(g)))
                  .take(12)
                  .toList(growable: false);
              final similar =
                  related.isNotEmpty ? related : all.where((m) => m.id != movie.id).take(12).toList(growable: false);

              if (similar.isEmpty) {
                return Center(
                  child: Text(
                    'No similar titles yet.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textMuted),
                  ),
                );
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final m = similar[index];
                  return InkWell(
                    onTap: () => onSelectSimilar(m),
                    borderRadius: BorderRadius.circular(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AppImage(
                        source: m.image,
                        width: 150,
                        height: 225,
                        fit: BoxFit.cover,
                        placeholderBorderRadius: 12,
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: similar.length,
              );
            },
            loading: () => ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) => const ShimmerPlaceholder(
                  width: 150, height: 225, borderRadius: 12),
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemCount: 6,
            ),
            error: (_, __) => Center(
              child: Text(
                'Unable to load similar titles.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textMuted),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
