import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/player_provider.dart';
import '../providers/ui_provider.dart';
import '../utils/constants.dart';
import 'bottom_nav_bar.dart';
import 'mini_player_bar.dart';
import 'side_nav_bar.dart';
import 'top_nav_bar.dart';

class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth >= AppBreakpoints.tabletMin;
        final isPlaying = ref.watch(playerProvider).isPlaying;
        final uri = GoRouterState.of(context).uri;
        final path = uri.path;
        final isHome = path == '/';
        final isImmersive =
            path.startsWith('/content/') || path.startsWith('/player/');
        final showTopNav =
            !isHome &&
            !isImmersive &&
            !path.startsWith('/songs') &&
            !path.startsWith('/live-news');
        return Scaffold(
          extendBody: !isTablet,
          body: NotificationListener<ScrollNotification>(
            onNotification: (n) {
              final should = n.metrics.pixels > 8;
              final current = ref.read(navScrolledProvider);
              if (current != should) {
                ref.read(navScrolledProvider.notifier).state = should;
              }
              return false;
            },
            child: Stack(
              children: [
                Row(
                  children: [
                    if (isTablet) const SideNavBar(),
                    Expanded(child: child),
                  ],
                ),
                if (showTopNav)
                  const Positioned(
                      top: 0, left: 0, right: 0, child: TopNavBar()),
                if (!isTablet && isPlaying)
                  const Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: MiniPlayerBar(),
                  ),
                if (!isTablet)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: isPlaying ? 80 : 0,
                    child: const BottomNavBar(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
