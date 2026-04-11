import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../models/movie.dart';
import '../providers/content_provider.dart';
import '../providers/app_content_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/content_card.dart';
import '../widgets/movie_detail_modal.dart';
import '../widgets/shimmer_placeholder.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _open(Movie m) {
    ref.read(contentProvider.notifier).selectMovie(m);
    showMovieDetailModal(context, m);
  }

  @override
  Widget build(BuildContext context) {
    final asyncResults = ref.watch(searchResultsProvider);
    final topPadding = MediaQuery.of(context).padding.top + 70 + 16;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 80;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPadding, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const Gap(12),
          TextField(
            controller: _controller,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Search titles, people, genres...',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: Colors.white.withOpacity(0.06),
              prefixIcon:
                  const Icon(Icons.search_rounded, color: AppColors.textMuted),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
              ),
              ),
            onChanged: (v) => ref.read(searchQueryProvider.notifier).state = v,
          ),
          const Gap(12),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - 12) / 2;
                final itemHeight = itemWidth * 3 / 2;
                final gridDelegate =
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2 / 3,
                );

                return asyncResults.when(
                  data: (results) {
                    if (results.isEmpty) {
                      return Center(
                        child: Text(
                          'No results found.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textMuted),
                        ),
                      );
                    }
                    return GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.only(bottom: bottomPadding),
                      gridDelegate: gridDelegate,
                      itemCount: results.length,
                      itemBuilder: (context, index) {
                        return ContentCard(
                          content: results[index],
                          variant: ContentCardVariant.defaultPoster,
                          onSelect: _open,
                        );
                      },
                    );
                  },
                  loading: () => GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomPadding),
                    gridDelegate: gridDelegate,
                    itemCount: 8,
                    itemBuilder: (context, index) => ShimmerPlaceholder(
                      width: itemWidth,
                      height: itemHeight,
                      borderRadius: 12,
                    ),
                  ),
                  error: (_, __) => Center(
                    child: Text(
                      'Search unavailable right now.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textMuted),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
