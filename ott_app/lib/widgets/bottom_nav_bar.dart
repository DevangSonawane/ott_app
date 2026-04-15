import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/movie.dart';
import '../providers/content_provider.dart';
import '../theme/app_colors.dart';
import '../utils/extensions.dart';
import 'glass_container.dart';

enum _NavMode { primary, secondary }

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key});

  static const _primaryItems = [
    _NavItem(icon: Icons.home_rounded, route: '/'),
    _NavItem(icon: Icons.movie_rounded, route: '/browse?type=movie'),
    _NavItem(icon: Icons.tv_rounded, route: '/browse?type=series'),
    _NavItem(icon: Icons.apps_rounded, route: ''),
  ];

  static const _secondaryItems = [
    _NavItem(icon: Icons.music_note_rounded, route: '/songs'),
    _NavItem(icon: Icons.wifi_tethering_rounded, route: '/live-news'),
    _NavItem(icon: Icons.apps_rounded, route: ''),
  ];

  _NavMode _modeForLocation(String location) {
    if (location.startsWith('/songs') || location.startsWith('/live-news')) {
      return _NavMode.secondary;
    }
    return _NavMode.primary;
  }

  int _indexForLocation(
    String location, {
    required _NavMode mode,
    required Movie? selectedMovie,
  }) {
    if (mode == _NavMode.secondary) {
      if (location.startsWith('/songs')) return 0;
      if (location.startsWith('/live-news')) return 1;
      return -1;
    }

    if (location == '/') return 0;
    if (location.startsWith('/browse')) {
      final uri = Uri.tryParse(location);
      final type = uri?.queryParameters['type'];
      if (type == 'series') return 2;
      return 1;
    }
    if (location.startsWith('/content') || location.startsWith('/player')) {
      if (selectedMovie?.type == 'series') return 2;
      if (selectedMovie?.type == 'movie') return 1;
      return -1;
    }
    return -1;
  }

  void _openMoreSheet(BuildContext context, {required _NavMode mode}) {
    Haptics.selection();
    final rootContext = context;
    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final pillBottomPadding = bottomSafe + 2 < 10 ? 10.0 : bottomSafe + 2;
    const pillHeight = 60.0;
    const gap = 10.0;

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'More',
      barrierColor: Colors.black.withOpacity(0.28),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned(
                left: 18,
                right: 18,
                bottom: pillBottomPadding + pillHeight + gap,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 260),
                    child: GlassContainer(
                      blurSigma: 24,
                      borderRadius: BorderRadius.circular(16),
                      decoration: BoxDecoration(
                        color: const Color(0xD908080A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (mode == _NavMode.primary) ...[
                              _sheetItem(
                                context,
                                label: 'Songs',
                                icon: Icons.music_note_rounded,
                                onTap: () => rootContext.go('/songs'),
                              ),
                              _sheetItem(
                                context,
                                label: 'News',
                                icon: Icons.wifi_tethering_rounded,
                                onTap: () => rootContext.go('/live-news'),
                              ),
                            ] else ...[
                              _sheetItem(
                                context,
                                label: 'Home',
                                icon: Icons.home_rounded,
                                onTap: () => rootContext.go('/'),
                              ),
                              _sheetItem(
                                context,
                                label: 'Movies',
                                icon: Icons.movie_rounded,
                                onTap: () =>
                                    rootContext.go('/browse?type=movie'),
                              ),
                              _sheetItem(
                                context,
                                label: 'Series',
                                icon: Icons.tv_rounded,
                                onTap: () =>
                                    rootContext.go('/browse?type=series'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
                    .animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  Widget _sheetItem(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: AppColors.textFaint),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).uri.toString();
    final mode = _modeForLocation(location);
    final selectedMovie = ref.watch(
      contentProvider.select((s) => s.selectedMovie),
    );
    final index = _indexForLocation(
      location,
      mode: mode,
      selectedMovie: selectedMovie,
    );

    final items = mode == _NavMode.primary ? _primaryItems : _secondaryItems;

    final bottomSafe = MediaQuery.of(context).padding.bottom;
    final bottomPadding = bottomSafe + 2 < 10 ? 10.0 : bottomSafe + 2;
    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, bottomPadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.55),
                  blurRadius: 34,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: GlassContainer(
              blurSigma: 32,
              borderRadius: BorderRadius.circular(40),
              decoration: BoxDecoration(
                color: const Color(0xD9080A0E),
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: AppColors.glassBorder),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(items.length, (i) {
                    final item = items[i];
                    return _BottomNavTile(
                      item: item,
                      selected: i == index,
                      onTap: () {
                        if (item.route.isEmpty) {
                          _openMoreSheet(context, mode: mode);
                          return;
                        }
                        Haptics.selection();
                        context.go(item.route);
                      },
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomNavTile extends StatelessWidget {
  const _BottomNavTile({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: 220.ms,
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected ? AppColors.glassAccent : Colors.transparent,
          border: Border.all(
            color: selected
                ? AppColors.accent.withOpacity(0.35)
                : Colors.transparent,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 12),
                  ),
                ]
              : null,
        ),
        child: Icon(
          item.icon,
          size: 22,
          color: selected ? AppColors.accent : AppColors.textSecondary,
        ),
      ),
    ).animate().fadeIn(duration: 180.ms);
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.route});
  final IconData icon;
  final String route;
}
