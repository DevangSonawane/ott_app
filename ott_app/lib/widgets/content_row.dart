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
    this.actionLabel,
    this.onActionTap,
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
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  State<ContentRow> createState() => _ContentRowState();
}

class _ContentRowState extends State<ContentRow> {
  String _filter = 'all'; // all|movies|tv
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

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
              if (isTop10) return _top10Header(context, constraints.maxWidth);

              final narrow = constraints.maxWidth < 400;
              final titleBlock = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: narrow ? 3 : 4,
                        height: narrow ? 20 : 24,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(3),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.accentGlow,
                              blurRadius: 18,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.2,
                              ),
                        ),
                      ),
                    ],
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
                  if (!widget.showFilter &&
                      widget.actionLabel != null &&
                      widget.onActionTap != null) ...[
                    const SizedBox(width: 12),
                    _actionLink(context,
                        label: widget.actionLabel!, onTap: widget.onActionTap!),
                  ],
                ],
              );
            },
          ),
        ),
        Gap(isTop10 ? 10 : 12),
        Builder(
          builder: (context) {
            final height = widget.variant == ContentRowVariant.continueWatching
                ? 170.0
                : (isTop10 ? 410.0 : 240.0);
            final listPadding = isTop10
                ? const EdgeInsets.fromLTRB(28, 0, 16, 32)
                : const EdgeInsets.symmetric(horizontal: 16);

            final list = SizedBox(
              height: height,
              child: widget.loadingSkeleton
                  ? ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
                      padding: listPadding,
                      itemBuilder: (context, index) {
                        final w =
                            widget.variant == ContentRowVariant.continueWatching
                                ? 280.0
                                : (isTop10 ? 240.0 : 150.0);
                        final h =
                            widget.variant == ContentRowVariant.continueWatching
                                ? 158.0
                                : (isTop10 ? 330.0 : 225.0);
                        return ShimmerPlaceholder(
                            width: w, height: h, borderRadius: 12);
                      },
                      separatorBuilder: (_, __) =>
                          SizedBox(width: isTop10 ? 20 : 12),
                      itemCount: 5,
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      controller: _scrollController,
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
                      separatorBuilder: (_, __) =>
                          SizedBox(width: isTop10 ? 20 : 12),
                      itemCount: items.length,
                    ),
            );

            return list;
          },
        ),
      ],
    );
  }

  Widget _top10Header(BuildContext context, double maxWidth) {
    final isWide = maxWidth >= 720;
    final isHuge = maxWidth >= 1100;
    // On some devices the post-padding width lands exactly at 360, which still
    // overflows the horizontal header by a couple pixels.
    final isCompact = maxWidth <= 360;
    final titleSize = isHuge
        ? 112.0
        : (isWide ? 96.0 : (isCompact ? 64.0 : 72.0));
    final strokeWidth = isHuge ? 2.8 : (isWide ? 2.4 : 2.0);

    final labelSize = isWide ? 18.0 : 12.0;
    final labelSpacing = isWide ? 6.0 : 4.0;

    final header = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _outlinedText(
          'TOP 10',
          fontSize: titleSize,
          strokeWidth: strokeWidth,
          strokeColor: AppColors.accent,
        ),
        SizedBox(width: isWide ? 14 : 10),
        Padding(
          padding: EdgeInsets.only(top: isWide ? 18 : 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'MOVIES',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: labelSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: labelSpacing,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                'TODAY',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: labelSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: labelSpacing,
                      color: AppColors.textPrimary.withOpacity(0.70),
                    ),
              ),
            ],
          ),
        ),
      ],
    );

    if (isCompact) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _outlinedText(
            'TOP 10',
            fontSize: titleSize,
            strokeWidth: strokeWidth,
            strokeColor: AppColors.accent,
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'MOVIES',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: labelSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: labelSpacing,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(width: 12),
              Text(
                'TODAY',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontSize: labelSize,
                      fontWeight: FontWeight.w900,
                      letterSpacing: labelSpacing,
                      color: AppColors.textPrimary.withOpacity(0.70),
                    ),
              ),
            ],
          ),
        ],
      );
    }

    if (!isWide) return header;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: header),
        Padding(
          padding: const EdgeInsets.only(top: 14),
          child: Row(
            children: [
              _scrollBtn(
                icon: Icons.chevron_left_rounded,
                onTap: () => _scrollTop10(maxWidth, direction: -1),
              ),
              const SizedBox(width: 10),
              _scrollBtn(
                icon: Icons.chevron_right_rounded,
                onTap: () => _scrollTop10(maxWidth, direction: 1),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _scrollBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 18, color: AppColors.textSecondary),
      ),
    );
  }

  void _scrollTop10(double width, {required int direction}) {
    if (!_scrollController.hasClients) return;
    final amount = width >= 1024 ? 520.0 : 320.0;
    final pos = _scrollController.position;
    final next = (_scrollController.offset + (amount * direction))
        .clamp(0.0, pos.maxScrollExtent);
    _scrollController.animateTo(
      next,
      duration: const Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    );
  }

  Widget _outlinedText(
    String text, {
    required double fontSize,
    required double strokeWidth,
    required Color strokeColor,
  }) {
    final base = Theme.of(context).textTheme.displayLarge?.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          height: 0.9,
          letterSpacing: -1.2,
        );

    return Stack(
      children: [
        Text(
          text,
          style: base?.copyWith(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
            shadows: [
              BoxShadow(
                color: strokeColor.withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 0),
              ),
            ],
          ),
        ),
        Text(
          text,
          style: base?.copyWith(color: Colors.transparent),
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

  Widget _actionLink(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.6,
                  ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.arrow_outward_rounded,
                size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
