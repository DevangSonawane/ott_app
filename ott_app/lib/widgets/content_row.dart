import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../models/movie.dart';
import '../theme/app_colors.dart';
import 'content_card.dart';
import 'shimmer_placeholder.dart';

enum ContentRowVariant { defaultPoster, continueWatching, top10 }

class ContentRow extends StatefulWidget {
  const ContentRow({
    super.key,
    required this.title,
    this.subtitle,
    required this.contents,
    required this.variant,
    required this.onSelect,
    this.showFilter = false,
    this.loadingSkeleton = false,
  });

  final String title;
  final String? subtitle;
  final List<Movie> contents;
  final ContentRowVariant variant;
  final bool showFilter;
  final bool loadingSkeleton;
  final ValueChanged<Movie> onSelect;

  @override
  State<ContentRow> createState() => _ContentRowState();
}

class _ContentRowState extends State<ContentRow> {
  String _filter = 'all'; // all|movies|tv

  List<Movie> _filtered() {
    if (!widget.showFilter) return widget.contents;
    switch (_filter) {
      case 'movies':
        return widget.contents
            .where((m) => m.type == 'movie')
            .toList(growable: false);
      case 'tv':
        return widget.contents
            .where((m) => m.type == 'series')
            .toList(growable: false);
      default:
        return widget.contents;
    }
  }

  ContentCardVariant _cardVariant() {
    switch (widget.variant) {
      case ContentRowVariant.defaultPoster:
        return ContentCardVariant.defaultPoster;
      case ContentRowVariant.continueWatching:
        return ContentCardVariant.continueWatching;
      case ContentRowVariant.top10:
        return ContentCardVariant.top10;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered();
    final cardVariant = _cardVariant();
    final isTop10 = widget.variant == ContentRowVariant.top10;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final narrow = constraints.maxWidth < 400;
              final titleBlock = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  if (widget.subtitle != null) ...[
                    const Gap(4),
                    Text(
                      widget.subtitle!,
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ],
                ],
              );

              final pills = widget.showFilter
                  ? Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _pill('All', 'all'),
                        _pill('Movies', 'movies'),
                        _pill('TV Shows', 'tv'),
                      ],
                    )
                  : const SizedBox.shrink();

              if (narrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    titleBlock,
                    if (widget.showFilter) ...[
                      const Gap(10),
                      pills,
                    ],
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(child: titleBlock),
                  if (widget.showFilter) pills,
                ],
              );
            },
          ),
        ),
        const Gap(12),
        Builder(
          builder: (context) {
            final height = widget.variant == ContentRowVariant.continueWatching
                ? 170.0
                : (isTop10 ? 280.0 : 240.0);
            final listPadding = isTop10
                ? const EdgeInsets.only(bottom: 30, left: 40, right: 16)
                : const EdgeInsets.symmetric(horizontal: 16);

            final list = SizedBox(
              height: height,
              child: widget.loadingSkeleton
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: listPadding,
                      itemBuilder: (context, index) {
                        final w =
                            widget.variant == ContentRowVariant.continueWatching
                                ? 280.0
                                : (isTop10 ? 160.0 : 150.0);
                        final h =
                            widget.variant == ContentRowVariant.continueWatching
                                ? 158.0
                                : 225.0;
                        return ShimmerPlaceholder(
                            width: w, height: h, borderRadius: 12);
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: 5,
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: listPadding,
                      itemBuilder: (context, index) {
                        final movie = items[index];
                        final rank = isTop10 ? index + 1 : null;
                        return ContentCard(
                          content: movie,
                          variant: cardVariant,
                          rank: rank,
                          onSelect: widget.onSelect,
                        )
                            .animate(delay: (index * 80).ms)
                            .slideX(begin: 0.1, end: 0, duration: 400.ms)
                            .fadeIn(duration: 400.ms);
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: items.length,
                    ),
            );

            return list;
          },
        ),
      ],
    );
  }

  Widget _pill(String label, String value) {
    final active = _filter == value;
    return InkWell(
      onTap: () => setState(() => _filter = value),
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active
              ? AppColors.accent.withOpacity(0.18)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color:
                active ? AppColors.accent.withOpacity(0.40) : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: active ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
              ),
        ),
      ),
    );
  }
}
