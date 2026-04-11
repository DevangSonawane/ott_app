import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/ui_provider.dart';
import '../utils/constants.dart';
import 'bottom_nav_bar.dart';
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
        return Scaffold(
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
                const Positioned(top: 0, left: 0, right: 0, child: TopNavBar()),
              ],
            ),
          ),
          bottomNavigationBar: isTablet ? null : const BottomNavBar(),
        );
      },
    );
  }
}
