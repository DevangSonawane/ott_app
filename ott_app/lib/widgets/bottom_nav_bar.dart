import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../utils/extensions.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  static const _items = [
    _NavItem(label: 'Home', icon: Icons.home_rounded, route: '/'),
    _NavItem(label: 'Search', icon: Icons.search_rounded, route: '/search'),
    _NavItem(label: 'TV', icon: Icons.tv_rounded, route: '/tv'),
    _NavItem(label: 'Movies', icon: Icons.movie_rounded, route: '/movies'),
    _NavItem(label: 'Profile', icon: Icons.person_rounded, route: '/account'),
  ];

  int _indexForLocation(String location) {
    for (var i = 0; i < _items.length; i++) {
      final route = _items[i].route;
      if (route == '/' && location == '/') return i;
      if (route != '/' && location.startsWith(route)) return i;
    }
    if (location.startsWith('/genre/')) return 0;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _indexForLocation(location);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(top: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              for (var i = 0; i < _items.length; i++)
                Expanded(
                  child: _BottomNavTile(
                    item: _items[i],
                    selected: i == index,
                    onTap: () {
                      Haptics.selection();
                      context.go(_items[i].route);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavTile extends StatelessWidget {
  const _BottomNavTile(
      {required this.item, required this.selected, required this.onTap});

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          color: selected ? AppColors.accent : AppColors.textMuted,
          fontWeight: FontWeight.w700,
        );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: 220.ms,
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? AppColors.accent.withOpacity(0.12)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(item.icon,
                color: selected ? AppColors.accent : AppColors.textMuted),
            const SizedBox(height: 2),
            Text(item.label, style: textStyle),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 200.ms);
  }
}

class _NavItem {
  const _NavItem(
      {required this.label, required this.icon, required this.route});
  final String label;
  final IconData icon;
  final String route;
}
