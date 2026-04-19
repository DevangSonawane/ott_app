import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/movie.dart';
import '../providers/content_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../services/web_content_repository.dart';
import 'content_card.dart';
import 'glass_container.dart';
import 'movie_detail_modal.dart';
import 'shimmer_placeholder.dart';
import 'voice_search_button.dart';

final _recentSearchesProvider = FutureProvider<List<String>>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('recent_searches') ?? <String>[];
});

final _overlaySearchProvider =
    FutureProvider.autoDispose.family<List<Movie>, String>((ref, query) async {
  if (query.trim().isEmpty) return const <Movie>[];
  final web = await WebContentRepository.load();
  final q = query.trim().toLowerCase();
  return web.allMovies
      .where((m) =>
          m.title.toLowerCase().contains(q) ||
          m.genre.any((g) => g.toLowerCase().contains(q)))
      .toList(growable: false);
});

class SearchOverlay extends ConsumerStatefulWidget {
  const SearchOverlay({super.key});

  @override
  ConsumerState<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends ConsumerState<SearchOverlay> {
  final _controller = TextEditingController();
  String _query = '';
  bool _isVoiceListening = false;
  String _voiceLiveText = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveRecent(String q) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList('recent_searches') ?? <String>[];
    final next = [
      q,
      ...current.where((e) => e.toLowerCase() != q.toLowerCase())
    ].take(10).toList();
    await prefs.setStringList('recent_searches', next);
    ref.invalidate(_recentSearchesProvider);
  }

  void _open(Movie movie) {
    _saveRecent(movie.title);
    ref.read(contentProvider.notifier).selectMovie(movie);
    showMovieDetailModal(context, movie);
  }

  @override
  Widget build(BuildContext context) {
    final recentAsync = ref.watch(_recentSearchesProvider);
    final resultsAsync = ref.watch(_overlaySearchProvider(_query));

    final mq = MediaQuery.of(context);
    final maxOverlayHeight =
        (mq.size.height * 0.82).clamp(320.0, mq.size.height).toDouble();

    return Material(
      type: MaterialType.transparency,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 720,
              maxHeight: maxOverlayHeight,
            ),
            child: GlassContainer(
              blurSigma: 12,
              decoration: AppDecorations.glassDecoration.copyWith(
                borderRadius: BorderRadius.circular(18),
                color: AppColors.backgroundSecondary.withOpacity(0.85),
              ),
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextField(
                      controller: _controller,
                      autofocus: true,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Search titles, people, genres...',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: AppColors.textMuted),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.06),
                        prefixIcon: const Icon(Icons.search_rounded,
                            color: AppColors.textMuted),
                        suffixIcon: SizedBox(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_query.isNotEmpty)
                                IconButton(
                                  onPressed: () {
                                    _controller.clear();
                                    setState(() => _query = '');
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              VoiceSearchButton(
                                onResult: (text) {
                                  _controller.text = text;
                                  _controller.selection =
                                      TextSelection.collapsed(
                                          offset: text.length);
                                  setState(() => _query = text);
                                  if (mounted) {
                                    setState(() => _voiceLiveText = '');
                                  }
                                },
                                onInterimResult: (text) {
                                  _controller.text = text;
                                  _controller.selection =
                                      TextSelection.collapsed(
                                          offset: text.length);
                                  if (mounted) {
                                    setState(() => _voiceLiveText = text);
                                  }
                                },
                                onListeningChanged: (isListening) {
                                  if (!mounted) return;
                                  setState(() {
                                    _isVoiceListening = isListening;
                                    if (!isListening) _voiceLiveText = '';
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
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
                          borderSide: const BorderSide(
                              color: AppColors.accent, width: 1.2),
                        ),
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                    if (_isVoiceListening) ...[
                      const Gap(10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 180),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeOutCubic,
                        child: Align(
                          key: ValueKey(_voiceLiveText),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _voiceLiveText.trim().isEmpty
                                ? 'Listening…'
                                : _voiceLiveText,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textMuted,
                                      height: 1.25,
                                    ),
                          ),
                        ),
                      ),
                    ],
                    const Gap(12),
                    recentAsync.when(
                      data: (recent) {
                        if (recent.isEmpty) return const SizedBox.shrink();
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final chip in recent.take(8))
                                InkWell(
                                  onTap: () {
                                    _controller.text = chip;
                                    _controller.selection =
                                        TextSelection.collapsed(
                                            offset: chip.length);
                                    setState(() => _query = chip);
                                  },
                                  borderRadius: BorderRadius.circular(999),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.06),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                          color: AppColors.borderSubtle),
                                    ),
                                    child: Text(
                                      chip,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                              color: AppColors.textMuted),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                      error: (_, __) => const SizedBox.shrink(),
                      loading: () => const SizedBox.shrink(),
                    ),
                    const Gap(12),
                    Expanded(
                      child: resultsAsync.when(
                        data: (results) {
                          if (results.isEmpty) {
                            return Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 24),
                                child: Text(
                                  _query.trim().isEmpty
                                      ? 'Start typing to search.'
                                      : 'No results found.',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(color: AppColors.textMuted),
                                ),
                              ),
                            );
                          }
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 2 / 3,
                            ),
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              final movie = results[index];
                              return ContentCard(
                                content: movie,
                                variant: ContentCardVariant.defaultPoster,
                                onSelect: _open,
                              )
                                  .animate(delay: (index * 60).ms)
                                  .fadeIn(duration: 260.ms)
                                  .slideY(begin: 0.06, end: 0);
                            },
                          );
                        },
                        loading: () => GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 2 / 3,
                          ),
                          itemCount: 6,
                          itemBuilder: (context, index) =>
                              const ShimmerPlaceholder(
                                  width: 150, height: 225, borderRadius: 12),
                        ),
                        error: (_, __) => Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Text(
                              'Search unavailable right now.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppColors.textMuted),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ).animate().fadeIn(duration: 220.ms).slideY(begin: -0.06, end: 0),
        ),
      ),
    );
  }
}
