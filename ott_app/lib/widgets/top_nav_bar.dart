import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/ui_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../widgets/glass_container.dart';

class TopNavBar extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const TopNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  ConsumerState<TopNavBar> createState() => _TopNavBarState();
}

class _TopNavBarState extends ConsumerState<TopNavBar> {
  final _layerLink = LayerLink();
  OverlayEntry? _menuEntry;
  static const double _menuWidth = 220;
  static const double _avatarSize = 34;

  @override
  void dispose() {
    _closeMenu();
    super.dispose();
  }

  void _closeMenu() {
    _menuEntry?.remove();
    _menuEntry = null;
  }

  void _toggleMenu() {
    if (_menuEntry != null) {
      _closeMenu();
      return;
    }
    final overlay = Overlay.of(context, rootOverlay: true);
    _menuEntry = OverlayEntry(
      builder: (context) {
        final mq = MediaQuery.of(context);
        final maxMenuHeight = (mq.size.height - mq.padding.top - 90)
            .clamp(240.0, mq.size.height)
            .toDouble();
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _closeMenu,
                behavior: HitTestBehavior.translucent,
                child: const SizedBox.expand(),
              ),
            ),
            CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(
                _avatarSize - _menuWidth - 8,
                46,
              ),
              child: Material(
                color: Colors.transparent,
                child: GlassContainer(
                  blurSigma: 12,
                  decoration: AppDecorations.glassDecoration.copyWith(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: _menuWidth,
                      maxWidth: _menuWidth,
                      maxHeight: maxMenuHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 4),
                            _menuItem(
                              'Switch Profile',
                              () => context.push('/profiles'),
                              icon: Icons.switch_account_rounded,
                              trailingIcon: Icons.chevron_right_rounded,
                              emphasized: true,
                            ),
                            _menuItem(
                              'Profile Settings',
                              () => context.push('/profile-settings'),
                              icon: Icons.manage_accounts_rounded,
                            ),
                            _menuItem(
                              'Pricing',
                              () => context.go('/pricing'),
                              icon: Icons.local_offer_rounded,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Divider(
                                  height: 1, color: AppColors.borderSubtle),
                            ),
                            _menuItem(
                              'Login',
                              () => context.push('/login'),
                              icon: Icons.login_rounded,
                            ),
                            _menuItem(
                              'Sign Up',
                              () => context.push('/signup'),
                              icon: Icons.person_add_alt_1_rounded,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    overlay.insert(_menuEntry!);
  }

  Widget _menuItem(
    String title,
    VoidCallback onTap, {
    IconData? icon,
    IconData? trailingIcon,
    bool emphasized = false,
  }) {
    return InkWell(
      onTap: () {
        _toggleMenu();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 18,
                color: emphasized ? AppColors.accent : AppColors.textMuted,
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight:
                          emphasized ? FontWeight.w800 : FontWeight.w600,
                    ),
              ),
            ),
            if (trailingIcon != null)
              Icon(trailingIcon, size: 18, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  void _openSearchPage() {
    _closeMenu();
    final loc = GoRouterState.of(context).uri.toString();
    final uri = Uri.tryParse(loc);
    var scope = 'all';
    if (loc.startsWith('/browse')) {
      final type = uri?.queryParameters['type'];
      if (type == 'movie' || type == 'series') scope = type!;
    } else if (loc.startsWith('/movies')) {
      scope = 'movie';
    } else if (loc.startsWith('/tv')) {
      scope = 'series';
    } else if (loc.startsWith('/songs')) {
      scope = 'songs';
    } else if (loc.startsWith('/live-news')) {
      scope = 'news';
    }
    context
        .go(Uri(path: '/search', queryParameters: {'scope': scope}).toString());
  }

  @override
  Widget build(BuildContext context) {
    final scrolled = ref.watch(navScrolledProvider);
    final topInset = MediaQuery.of(context).padding.top;
    return AnimatedContainer(
      duration: 250.ms,
      height: topInset + 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: !scrolled
          ? const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.black54, Colors.transparent],
              ),
            )
          : null,
      child: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: Align(
          alignment: Alignment.center,
          child: GlassContainer(
            enabled: scrolled,
            blurSigma: 12,
            decoration: AppDecorations.glassDecoration.copyWith(
              color: scrolled
                  ? AppColors.background.withOpacity(0.52)
                  : Colors.transparent,
              border: Border.all(
                  color:
                      scrolled ? AppColors.borderSubtle : Colors.transparent),
            ),
            child: SizedBox(
              height: 54,
              child: Stack(
                children: [
                  if (scrolled)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Colors.transparent,
                              Colors.white.withOpacity(0.10),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => context.go('/'),
                        borderRadius: BorderRadius.circular(14),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 6),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.accent,
                                      AppColors.accentHover,
                                    ],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accent.withOpacity(0.35),
                                      blurRadius: 14,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.local_movies_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Camcine',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      _iconButton(
                        icon: Icons.search_rounded,
                        onTap: _openSearchPage,
                        rotateOnPress: true,
                      ),
                      const SizedBox(width: 8),
                      _notificationBell(),
                      const SizedBox(width: 8),
                      CompositedTransformTarget(
                        link: _layerLink,
                        child: _profileAvatar(onTap: _toggleMenu),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _notificationBell() {
    return _iconButton(
      icon: Icons.notifications_none_rounded,
      onTap: () {},
      trailing: Positioned(
        top: 8,
        right: 10,
        child: AnimatedContainer(
          duration: 600.ms,
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
              color: AppColors.accent, shape: BoxShape.circle),
        )
            .animate(onPlay: (c) => c.repeat())
            .scaleXY(begin: 0.9, end: 1.15, duration: 1.2.seconds)
            .then(delay: 200.ms)
            .scaleXY(begin: 1.15, end: 0.9, duration: 1.2.seconds),
      ),
    );
  }

  Widget _profileAvatar({required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedScale(
        duration: 200.ms,
        scale: 1,
        child: Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.08),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: const Icon(Icons.person_rounded,
              color: AppColors.textPrimary, size: 18),
        ),
      ),
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool rotateOnPress = false,
    Widget? trailing,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(icon, color: AppColors.textPrimary),
          ),
        )
            .animate(target: 1)
            .rotate(begin: 0, end: rotateOnPress ? 0.04 : 0, duration: 200.ms),
        if (trailing != null) trailing,
      ],
    );
  }
}
