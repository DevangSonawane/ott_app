import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/movie.dart';
import '../providers/app_content_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/app_image.dart';
import '../widgets/trailer_preview.dart';

class ContentDetailScreen extends ConsumerStatefulWidget {
  const ContentDetailScreen({super.key, required this.contentId});

  final String contentId;

  @override
  ConsumerState<ContentDetailScreen> createState() => _ContentDetailScreenState();
}

class _ContentDetailScreenState extends ConsumerState<ContentDetailScreen> {
  bool _autoPlayed = false;

  @override
  Widget build(BuildContext context) {
    final asyncMovie = ref.watch(contentByIdProvider(widget.contentId));

    return asyncMovie.when(
      data: (movie) {
        if (movie == null) {
          return _scaffold(
            context,
            child: const _Empty(),
          );
        }

        final trailer = (movie.trailer ?? '').trim();
        final videoUrl = (movie.videoUrl ?? '').trim();
        final canPlay = trailer.isNotEmpty || videoUrl.isNotEmpty;

        // Auto-play happens inside the trailer preview (inline) via WebView.
        // Keep this flag reserved for future non-inline fallbacks.
        if (!_autoPlayed && trailer.isNotEmpty) _autoPlayed = true;

        return _scaffold(
          context,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                  child: _TrailerHero(
                    image: (movie.bannerImage.isNotEmpty
                            ? movie.bannerImage
                            : movie.image)
                        .trim(),
                    trailerUrl: trailer,
                    videoUrl: videoUrl,
                    canPlay: canPlay,
                    onCast: () {},
                    onClose: () => context.go('/'),
                    onPlay: () {
                      if (!canPlay) return;
                      _playPrimary(context, ref, movie);
                    },
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                              height: 1.05,
                            ),
                      ),
                      const SizedBox(height: 10),
                      _MetaRow(movie: movie),
                      const SizedBox(height: 14),
                      _PrimaryPlayButton(
                        enabled: canPlay,
                        onTap: () {
                          if (!canPlay) return;
                          _playPrimary(context, ref, movie);
                        },
                      ),
                      const SizedBox(height: 10),
                      _SecondaryButton(
                        label: 'Download',
                        icon: Icons.download_rounded,
                        onTap: () {},
                      ),
                      const SizedBox(height: 16),
                      Text(
                        movie.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withOpacity(0.80),
                              height: 1.4,
                            ),
                      ),
                      const SizedBox(height: 12),
                      _CreditsBlock(movie: movie),
                      const SizedBox(height: 18),
                      _ActionRow(
                        onMyList: () {},
                        onRate: () {},
                        onShare: () => _share(movie),
                        onDownloaded: () {},
                      ),
                      const SizedBox(height: 18),
                      if (movie.type == 'series')
                        _EpisodesSection(
                          episodes: movie.episodes,
                          totalEpisodes: movie.totalEpisodes,
                          onSelectEpisode: (_) {
                            if (!canPlay) return;
                            _playPrimary(context, ref, movie);
                          },
                        )
                      else
                        _MoreTabs(
                          currentId: movie.id,
                          onSelect: (m) => context.push('/content/${m.id}'),
                          onOpenTrailer: null,
                        ),
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => _scaffold(
        context,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => _scaffold(
        context,
        child: Center(
          child: Text(
            'Unable to load content. ($e)',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }

  // Intentionally no external trailer launching: trailers should play inline
  // in the hero preview like the React web app.
}

Future<void> _share(Movie movie) async {
  final trailer = (movie.trailer ?? '').trim();
  if (trailer.isEmpty) return;
  final uri = Uri.tryParse(trailer);
  if (uri == null) return;
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

bool _looksLikeYouTube(String url) {
  final lower = url.toLowerCase();
  return lower.contains('youtube.com') || lower.contains('youtu.be');
}

Future<void> _playPrimary(
  BuildContext context,
  WidgetRef ref,
  Movie movie,
) async {
  final trailer = (movie.trailer ?? '').trim();
  final videoUrl = (movie.videoUrl ?? '').trim();

  // Prefer direct video URLs inside the app player.
  if (videoUrl.isNotEmpty && !_looksLikeYouTube(videoUrl)) {
    ref.read(playerProvider.notifier).play(movie);
    if (context.mounted) context.push('/player/${movie.id}');
    return;
  }

  // Trailers are meant to play in the inline header WebView. Don't launch
  // YouTube externally; guide the user to tap the preview area if autoplay
  // is blocked on their device.
  if (trailer.isNotEmpty) {
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Trailer is playing above. Tap the preview to play/unmute.')),
    );
    return;
  }

  if (!context.mounted) return;
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('No trailer/video available for this title.')),
  );
}

Widget _scaffold(
  BuildContext context, {
  required Widget child,
}) {
  return Scaffold(
    backgroundColor: AppColors.background,
    body: SafeArea(bottom: false, child: child),
  );
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Content not found.',
        style: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _TrailerHero extends StatelessWidget {
  const _TrailerHero({
    required this.image,
    required this.trailerUrl,
    required this.videoUrl,
    required this.canPlay,
    required this.onCast,
    required this.onClose,
    required this.onPlay,
  });

  final String image;
  final String trailerUrl;
  final String videoUrl;
  final bool canPlay;
  final VoidCallback onCast;
  final VoidCallback onClose;
  final VoidCallback onPlay;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            TrailerPreview(
              fallbackImage: image,
              trailerUrl: trailerUrl,
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.55),
                    Colors.black.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    _IconBubble(icon: Icons.cast_rounded, onTap: onCast),
                    const SizedBox(width: 10),
                    _IconBubble(icon: Icons.close_rounded, onTap: onClose),
                  ],
                ),
              ),
            ),
            if (canPlay && trailerUrl.trim().isEmpty)
              Positioned.fill(
                child: Center(
                  child: GestureDetector(
                    onTap: onPlay,
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.40),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.accent, width: 3),
                      ),
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.40),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _MetaRow extends StatelessWidget {
  const _MetaRow({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final metaLeft = <String>[
      '${movie.year}',
      movie.type == 'series' ? 'TV' : 'Movie',
      if ((movie.duration ?? '').trim().isNotEmpty) movie.duration!,
      if (movie.type == 'series' && movie.totalEpisodes != null)
        '${movie.totalEpisodes} eps',
    ];

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final t in metaLeft.where((e) => e.trim().isNotEmpty))
          Text(
            t,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Colors.white.withOpacity(0.85),
                  fontWeight: FontWeight.w800,
                ),
          ),
        _metaChip(context,
            icon: Icons.hdr_strong_rounded, label: 'Dolby Vision'),
        _metaChip(context, icon: Icons.hd_rounded, label: 'HD'),
        _metaChip(context, icon: Icons.closed_caption_rounded, label: 'CC'),
        _metaChip(context, icon: Icons.translate_rounded, label: 'Subtitles'),
      ],
    );
  }

  Widget _metaChip(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: Colors.white.withOpacity(0.65)),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white.withOpacity(0.65),
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

class _PrimaryPlayButton extends StatelessWidget {
  const _PrimaryPlayButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: enabled ? onTap : null,
        icon: const Icon(Icons.play_arrow_rounded, size: 26),
        label: Text(
          'Play',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          disabledBackgroundColor: Colors.white.withOpacity(0.25),
          disabledForegroundColor: Colors.black.withOpacity(0.35),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 22),
        label: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white.withOpacity(0.92),
                fontWeight: FontWeight.w900,
              ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.16),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}

class _CreditsBlock extends StatelessWidget {
  const _CreditsBlock({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final castLine = movie.cast.isEmpty ? '' : movie.cast.take(4).join(', ');
    final creatorsLine =
        movie.creators.isEmpty ? '' : movie.creators.take(2).join(', ');

    if (castLine.isEmpty && creatorsLine.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (castLine.isNotEmpty)
          Text(
            'Cast: $castLine',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.40),
                  height: 1.35,
                ),
          ),
        if (creatorsLine.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            'Creators: $creatorsLine',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.40),
                  height: 1.35,
                ),
          ),
        ],
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.onMyList,
    required this.onRate,
    required this.onShare,
    required this.onDownloaded,
  });

  final VoidCallback onMyList;
  final VoidCallback onRate;
  final VoidCallback onShare;
  final VoidCallback onDownloaded;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionItem(icon: Icons.add_rounded, label: 'My List', onTap: onMyList),
        _ActionItem(
            icon: Icons.thumb_up_outlined, label: 'Rate', onTap: onRate),
        _ActionItem(icon: Icons.send_rounded, label: 'Share', onTap: onShare),
        _ActionItem(
          icon: Icons.download_done_rounded,
          label: 'Downloaded',
          onTap: onDownloaded,
        ),
      ],
    );
  }
}

class _ActionItem extends StatelessWidget {
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Icon(icon, color: Colors.white.withOpacity(0.85), size: 26),
              const SizedBox(height: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Colors.white.withOpacity(0.70),
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EpisodesSection extends StatelessWidget {
  const _EpisodesSection({
    required this.episodes,
    required this.totalEpisodes,
    required this.onSelectEpisode,
  });

  final List<Episode> episodes;
  final int? totalEpisodes;
  final ValueChanged<Episode> onSelectEpisode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Episodes',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white.withOpacity(0.92),
                fontWeight: FontWeight.w900,
              ),
        ),
        if (totalEpisodes != null) ...[
          const SizedBox(height: 6),
          Text(
            '$totalEpisodes episodes',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.55),
                ),
          ),
        ],
        const SizedBox(height: 10),
        if (episodes.isEmpty)
          Text(
            'Episodes are not available yet.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.60),
                ),
          )
        else
          ListView.separated(
            itemCount: episodes.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final ep = episodes[index];
              return InkWell(
                onTap: () => onSelectEpisode(ep),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: 128,
                        height: 72,
                        child: AppImage(
                          source: ep.thumbnail,
                          fit: BoxFit.cover,
                          placeholderBorderRadius: 0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${ep.number}. ${ep.title}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.92),
                                  fontWeight: FontWeight.w900,
                                  height: 1.1,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            ep.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.55),
                                  height: 1.35,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}

class _MoreTabs extends ConsumerWidget {
  const _MoreTabs({
    required this.currentId,
    required this.onSelect,
    this.onOpenTrailer,
  });

  final String currentId;
  final ValueChanged<Movie> onSelect;
  final VoidCallback? onOpenTrailer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moreAsync = ref.watch(popularMoviesProvider);
    final trailersAsync = ref.watch(trendingProvider);

    return DefaultTabController(
      length: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white.withOpacity(0.45),
            indicatorColor: AppColors.accent,
            indicatorWeight: 3,
            labelStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
            tabs: const [
              Tab(text: 'More Like This'),
              Tab(text: 'Trailers & More'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 420,
            child: TabBarView(
              children: [
                moreAsync.when(
                  data: (items) => _PosterGrid(
                    items: items.where((m) => m.id != currentId).take(12).toList(),
                    onSelect: onSelect,
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                ),
                trailersAsync.when(
                  data: (items) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (onOpenTrailer != null) ...[
                        _SecondaryButton(
                          label: 'Open Trailer',
                          icon: Icons.play_arrow_rounded,
                          onTap: onOpenTrailer!,
                        ),
                        const SizedBox(height: 12),
                      ],
                      Expanded(
                        child: _PosterGrid(
                          items: items.where((m) => m.id != currentId).take(12).toList(),
                          onSelect: onSelect,
                        ),
                      ),
                    ],
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterGrid extends StatelessWidget {
  const _PosterGrid({required this.items, required this.onSelect});

  final List<Movie> items;
  final ValueChanged<Movie> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.only(top: 4),
      physics: const BouncingScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2 / 3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final m = items[index];
        return InkWell(
          onTap: () => onSelect(m),
          borderRadius: BorderRadius.circular(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AppImage(
              source: m.image,
              fit: BoxFit.cover,
              placeholderBorderRadius: 0,
            ),
          ),
        );
      },
    );
  }
}
