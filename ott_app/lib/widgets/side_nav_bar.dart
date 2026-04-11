import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../utils/extensions.dart';

class SideNavBar extends StatefulWidget {
  const SideNavBar({super.key});

  @override
  State<SideNavBar> createState() => _SideNavBarState();
}

class _SideNavBarState extends State<SideNavBar> {
  bool _expanded = false;

  static const _items = <_SideItem>[
    _SideItem(label: 'Home', icon: Icons.home_rounded, route: '/'),
    _SideItem(label: 'Search', icon: Icons.search_rounded, route: '/search'),
    _SideItem(label: 'TV', icon: Icons.tv_rounded, route: '/tv'),
    _SideItem(label: 'Movies', icon: Icons.movie_rounded, route: '/movies'),
    _SideItem(
        label: 'Live', icon: Icons.live_tv_rounded, route: '/genre/action'),
    _SideItem(
        label: 'My List', icon: Icons.bookmark_rounded, route: '/genre/drama'),
    _SideItem(
        label: 'Profiles', icon: Icons.people_rounded, route: '/profiles'),
    _SideItem(
        label: 'Settings', icon: Icons.settings_rounded, route: '/account'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = _expanded ? 224.0 : 64.0;
    final location = GoRouterState.of(context).uri.toString();
    return AnimatedContainer(
      duration: 300.ms,
      curve: Curves.easeInOut,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(right: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            InkWell(
              onTap: () => setState(() => _expanded = !_expanded),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.accent.withOpacity(0.14),
                        boxShadow: [AppDecorations.accentGlow],
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: AppColors.accent),
                    ),
                    if (_expanded) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary,
                                ),
                            children: const [
                              TextSpan(text: 'the'),
                              TextSpan(
                                  text: 'Flashx',
                                  style: TextStyle(color: AppColors.accent)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  final item = _items[index];
                  final active = location == item.route ||
                      (item.route != '/' && location.startsWith(item.route));
                  return _SideNavTile(
                    expanded: _expanded,
                    item: item,
                    active: active,
                    onTap: () {
                      Haptics.selection();
                      context.go(item.route);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SideNavTile extends StatelessWidget {
  const _SideNavTile({
    required this.expanded,
    required this.item,
    required this.active,
    required this.onTap,
  });

  final bool expanded;
  final _SideItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: 220.ms,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: active
                ? AppColors.accent.withOpacity(0.15)
                : Colors.transparent,
            boxShadow: active ? [AppDecorations.accentGlow] : null,
          ),
          child: Row(
            children: [
              Icon(item.icon,
                  color: active ? AppColors.accent : AppColors.textMuted),
              if (expanded) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: active
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 180.ms);
  }
}

class _SideItem {
  const _SideItem(
      {required this.label, required this.icon, required this.route});
  final String label;
  final IconData icon;
  final String route;
}
