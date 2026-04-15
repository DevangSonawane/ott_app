import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/app_content_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_colors.dart';
import '../widgets/app_image.dart';

class ContentDetailScreen extends ConsumerWidget {
  const ContentDetailScreen({super.key, required this.contentId});

  final String contentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMovie = ref.watch(contentByIdProvider(contentId));
    final topPadding = MediaQuery.of(context).padding.top;

    return asyncMovie.when(
      data: (movie) {
        if (movie == null) {
          return _scaffold(
            context,
            topPadding: topPadding,
            child: Center(
              child: Text(
                'Content not found.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        return _scaffold(
          context,
          topPadding: topPadding,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.72,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      AppImage(
                        source: movie.image,
                        fit: BoxFit.cover,
                        placeholderBorderRadius: 0,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              AppColors.background,
                              AppColors.background.withOpacity(0.30),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              AppColors.background.withOpacity(0.90),
                              AppColors.background.withOpacity(0.45),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: topPadding + 12,
                        left: 12,
                        child: _iconPill(
                          context,
                          icon: Icons.arrow_back_rounded,
                          onTap: () => context.pop(),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 24,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 720),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  if (movie.rating != null)
                                    _badge(
                                      context,
                                      label:
                                          '⭐ ${(movie.rating! * 10).toStringAsFixed(1)}',
                                      emphasized: true,
                                    ),
                                  const SizedBox(width: 10),
                                  _mutedText(
                                    context,
                                    '${movie.year}',
                                  ),
                                  const SizedBox(width: 10),
                                  _badge(
                                    context,
                                    label: 'PREMIUM',
                                    emphasized: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                movie.title.toUpperCase(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w900,
                                      fontStyle: FontStyle.italic,
                                      height: 0.95,
                                    ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                movie.description,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Colors.white.withOpacity(0.60),
                                      height: 1.35,
                                    ),
                              ),
                              const SizedBox(height: 14),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: [
                                  _primaryButton(
                                    context,
                                    label: 'PLAY NOW',
                                    icon: Icons.play_arrow_rounded,
                                    onTap: () {
                                      ref
                                          .read(playerProvider.notifier)
                                          .play(movie);
                                      context.push('/player/${movie.id}');
                                    },
                                  ),
                                  _ghostButton(
                                    context,
                                    label: 'WATCHLIST',
                                    icon: Icons.add_rounded,
                                    onTap: () {},
                                  ),
                                  _ghostButton(
                                    context,
                                    label: 'SHARE',
                                    icon: Icons.ios_share_rounded,
                                    onTap: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 160),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'About',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.description,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                      ),
                      const SizedBox(height: 14),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          for (final g in movie.genre.take(6))
                            _genreChip(context, g),
                        ],
                      ),
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
        topPadding: topPadding,
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => _scaffold(
        context,
        topPadding: topPadding,
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

  Widget _scaffold(
    BuildContext context, {
    required double topPadding,
    required Widget child,
  }) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: EdgeInsets.only(top: topPadding),
        child: child,
      ),
    );
  }

  Widget _badge(
    BuildContext context, {
    required String label,
    bool emphasized = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: emphasized ? AppColors.accent : AppColors.glassBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: emphasized ? Colors.transparent : AppColors.glassBorder,
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
      ),
    );
  }

  Widget _mutedText(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Colors.white.withOpacity(0.55),
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
    );
  }

  Widget _genreChip(BuildContext context, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.glassBg,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
      ),
    );
  }

  Widget _primaryButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.30),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ghostButton(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.glassBg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconPill(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.glassBg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}
