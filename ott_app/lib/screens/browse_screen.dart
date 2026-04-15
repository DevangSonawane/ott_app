import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/movie.dart';
import '../providers/app_content_provider.dart';
import '../providers/content_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/content_grid.dart';

class BrowseScreen extends ConsumerWidget {
  const BrowseScreen({super.key, this.initialType});

  final String? initialType; // all|movie|series

  void _open(BuildContext context, WidgetRef ref, Movie movie) {
    ref.read(contentProvider.notifier).selectMovie(movie);
    context.push('/content/${movie.id}');
  }

  void _goWith(
    BuildContext context,
    Uri current, {
    String? type,
    String? sort,
    String? genre,
  }) {
    final next = <String, String>{...current.queryParameters};
    if (type != null) next['type'] = type;
    if (sort != null) next['sort'] = sort;
    if (genre != null) {
      if (genre.isEmpty) {
        next.remove('genre');
      } else {
        next['genre'] = genre;
      }
    }
    context.go(Uri(path: '/browse', queryParameters: next).toString());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPadding = MediaQuery.of(context).padding.top + 70 + 16;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 160;

    final uri = GoRouterState.of(context).uri;
    final type = uri.queryParameters['type'] ?? initialType ?? 'all';
    final sort = uri.queryParameters['sort'] ?? 'popular';
    final selectedGenre = uri.queryParameters['genre'] ?? '';

    final asyncGenres = ref.watch(genresProvider);
    final asyncItems = selectedGenre.isEmpty
        ? ref.watch(allContentProvider)
        : ref.watch(genreContentProvider(selectedGenre));

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(0, topPadding, 0, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    type == 'movie'
                        ? 'Popular Movies'
                        : (type == 'series' ? 'TV Shows' : 'Discover'),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Colors.transparent,
                      barrierColor: Colors.black.withOpacity(0.45),
                      builder: (context) => _FilterSheet(
                        type: type,
                        sort: sort,
                        onSelectType: (v) => _goWith(context, uri, type: v),
                        onSelectSort: (v) => _goWith(context, uri, sort: v),
                      ),
                    );
                  },
                  icon: const Icon(Icons.tune_rounded,
                      color: AppColors.textSecondary),
                ),
                IconButton(
                  onPressed: () {
                    final scope =
                        type == 'movie' || type == 'series' ? type : 'all';
                    context.go('/search?scope=$scope');
                  },
                  icon: const Icon(Icons.search_rounded,
                      color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _PillTabs(
                    values: const [
                      ('All', 'all'),
                      ('Movies', 'movie'),
                      ('Series', 'series'),
                    ],
                    current: type,
                    onSelect: (v) => _goWith(context, uri, type: v),
                  ),
                ),
                const SizedBox(width: 10),
                _PillTabs(
                  values: const [
                    ('Popular', 'popular'),
                    ('Top Rated', 'top_rated'),
                  ],
                  current: sort,
                  onSelect: (v) => _goWith(context, uri, sort: v),
                  compact: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          asyncGenres.when(
            data: (genres) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      _chip(
                        context,
                        label: 'All',
                        active: selectedGenre.isEmpty,
                        onTap: () => _goWith(context, uri, genre: ''),
                      ),
                      for (final g in genres) ...[
                        const SizedBox(width: 10),
                        _chip(
                          context,
                          label: g.name,
                          active: selectedGenre == g.id,
                          onTap: () => _goWith(context, uri, genre: g.id),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
            loading: () => const SizedBox(height: 40),
            error: (_, __) => const SizedBox(height: 40),
          ),
          const SizedBox(height: 16),
          asyncItems.when(
            data: (items) {
              final typed = switch (type) {
                'movie' =>
                  items.where((m) => m.type == 'movie').toList(growable: false),
                'series' => items
                    .where((m) => m.type == 'series')
                    .toList(growable: false),
                _ => items,
              };

              final sorted = [...typed];
              if (sort == 'top_rated') {
                sorted.sort((a, b) {
                  final ar = a.rating ?? -1;
                  final br = b.rating ?? -1;
                  return br.compareTo(ar);
                });
              }

              return ContentGrid(
                title: 'Browse',
                subtitle:
                    sort == 'top_rated' ? 'Top rated' : 'Popular right now',
                contents: sorted,
                onSelect: (m) => _open(context, ref, m),
              );
            },
            loading: () => const ContentGrid(
              title: 'Browse',
              subtitle: 'Popular right now',
              contents: <Movie>[],
              onSelect: _noopMovieSelect,
              loadingSkeleton: true,
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Unable to load browse content. ($e)',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(
    BuildContext context, {
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.glassAccent : AppColors.glassBg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active
                ? AppColors.accent.withOpacity(0.35)
                : AppColors.glassBorder,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: active ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.0,
              ),
        ),
      ),
    );
  }
}

class _PillTabs extends StatelessWidget {
  const _PillTabs({
    required this.values,
    required this.current,
    required this.onSelect,
    this.compact = false,
  });

  final List<(String, String)> values;
  final String current;
  final ValueChanged<String> onSelect;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.glassBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (label, value) in values)
            _tab(
              context,
              label: compact ? label.replaceAll(' ', '\n') : label,
              value: value,
            ),
        ],
      ),
    );
  }

  Widget _tab(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final active = current == value;
    return InkWell(
      onTap: () => onSelect(value),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 14,
          vertical: 8,
        ),
        decoration: active
            ? BoxDecoration(
                color: AppColors.glassAccent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.accent.withOpacity(0.35)),
              )
            : null,
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: active ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.8,
                height: 1.0,
              ),
        ),
      ),
    );
  }
}

class _FilterSheet extends StatelessWidget {
  const _FilterSheet({
    required this.type,
    required this.sort,
    required this.onSelectType,
    required this.onSelectSort,
  });

  final String type;
  final String sort;
  final ValueChanged<String> onSelectType;
  final ValueChanged<String> onSelectSort;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xD908080A),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filters',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.italic,
                    ),
              ),
              const SizedBox(height: 12),
              Text('Type',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      )),
              const SizedBox(height: 8),
              _PillTabs(
                values: const [
                  ('All', 'all'),
                  ('Movies', 'movie'),
                  ('Series', 'series'),
                ],
                current: type,
                onSelect: (v) {
                  Navigator.of(context).pop();
                  onSelectType(v);
                },
              ),
              const SizedBox(height: 14),
              Text('Sort',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.4,
                      )),
              const SizedBox(height: 8),
              _PillTabs(
                values: const [
                  ('Popular', 'popular'),
                  ('Top Rated', 'top_rated'),
                ],
                current: sort,
                onSelect: (v) {
                  Navigator.of(context).pop();
                  onSelectSort(v);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _noopMovieSelect(Movie _) {}
