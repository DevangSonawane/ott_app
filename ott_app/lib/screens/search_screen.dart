import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../models/movie.dart';
import '../providers/content_provider.dart';
import '../providers/app_content_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/content_card.dart';
import '../widgets/shimmer_placeholder.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key, this.scope = 'all'});

  /// Search scope: all|movie|series|songs|news
  final String scope;

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
    context.push('/content/${m.id}');
  }

  @override
  Widget build(BuildContext context) {
    final asyncResults = ref.watch(searchResultsProvider);
    final topPadding = MediaQuery.of(context).padding.top + 70 + 16;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 80;
    final scope = widget.scope;
    final scopeLabel = switch (scope) {
      'movie' => 'Movies',
      'series' => 'Series',
      'songs' => 'Songs',
      'news' => 'News',
      _ => 'All',
    };
    return Padding(
      padding: EdgeInsets.fromLTRB(16, topPadding, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search $scopeLabel',
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
              hintText: scope == 'all'
                  ? 'Search titles, people, genres...'
                  : 'Search $scopeLabel...',
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
                borderSide:
                    const BorderSide(color: AppColors.accent, width: 1.2),
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
                    final filtered = (scope == 'movie' || scope == 'series')
                        ? results
                            .where((m) => m.type == scope)
                            .toList(growable: false)
                        : results;
                    if (scope == 'songs' || scope == 'news') {
                      return Center(
                        child: Text(
                          'Search for $scopeLabel is coming soon.',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: AppColors.textMuted),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    if (filtered.isEmpty) {
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
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        return ContentCard(
                          content: filtered[index],
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
