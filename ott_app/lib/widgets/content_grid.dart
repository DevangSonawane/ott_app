import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../models/movie.dart';
import '../theme/app_colors.dart';
import 'content_card.dart';
import 'shimmer_placeholder.dart';

class ContentGrid extends StatelessWidget {
  const ContentGrid({
    super.key,
    required this.title,
    this.subtitle,
    required this.contents,
    required this.onSelect,
    this.loadingSkeleton = false,
  });

  final String title;
  final String? subtitle;
  final List<Movie> contents;
  final ValueChanged<Movie> onSelect;
  final bool loadingSkeleton;

  int _crossAxisCount(double maxWidth) {
    if (maxWidth >= 1000) return 5;
    if (maxWidth >= 760) return 4;
    if (maxWidth >= 520) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = _crossAxisCount(constraints.maxWidth);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              if (subtitle != null) ...[
                const Gap(4),
                Text(
                  subtitle!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textMuted),
                ),
              ],
              const Gap(12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: loadingSkeleton ? 10 : contents.length,
                itemBuilder: (context, index) {
                  if (loadingSkeleton) {
                    return const ShimmerPlaceholder(
                      width: 150,
                      height: 225,
                      borderRadius: 12,
                    );
                  }
                  final movie = contents[index];
                  return ContentCard(
                    content: movie,
                    variant: ContentCardVariant.defaultPoster,
                    onSelect: onSelect,
                  )
                      .animate(delay: (index * 35).ms)
                      .fadeIn(duration: 220.ms)
                      .slideY(begin: 0.04, end: 0);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

