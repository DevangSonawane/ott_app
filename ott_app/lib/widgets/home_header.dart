import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/hero_slide.dart';
import '../providers/app_content_provider.dart';
import '../providers/content_provider.dart';
import '../theme/app_colors.dart';
import '../utils/extensions.dart';
import 'app_image.dart';
import 'for_user_header.dart';
import 'glass_container.dart';

class HomeHeader extends ConsumerStatefulWidget {
  const HomeHeader({super.key});

  @override
  ConsumerState<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends ConsumerState<HomeHeader> {
  String _category = 'Categories';
  final _categoryChipKey = GlobalKey();
  final _profileIconKey = GlobalKey();
  final _heroController = PageController();
  ProviderSubscription<AsyncValue<List<HeroSlide>>>? _heroSlidesSubscription;
  Timer? _heroTimer;
  int _heroIndex = 0;
  int _heroCount = 1;

  @override
  void initState() {
    super.initState();

    _heroSlidesSubscription =
        ref.listenManual<AsyncValue<List<HeroSlide>>>(heroSlidesProvider,
            (prev, next) {
      final count =
          next.valueOrNull?.isNotEmpty == true ? next.valueOrNull!.length : 1;
      if (count == _heroCount) return;
      setState(() {
        _heroCount = count;
        if (_heroIndex >= _heroCount) _heroIndex = 0;
      });
      if (_heroController.hasClients) {
        _heroController.jumpToPage(_heroIndex);
      }
    });

    _heroTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted) return;
      if (_heroCount < 2) return;
      if (!_heroController.hasClients) return;
      final next = (_heroIndex + 1) % _heroCount;
      _heroController.animateToPage(
        next,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _heroSlidesSubscription?.close();
    _heroTimer?.cancel();
    _heroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    final profileName =
        ref.watch(contentProvider.select((s) => s.selectedProfile?.name)) ??
            'You';

    final heroSlidesAsync = ref.watch(heroSlidesProvider);
    final slides = heroSlidesAsync.valueOrNull?.isNotEmpty == true
        ? heroSlidesAsync.valueOrNull!
        : const [fallbackHeroSlide];
    if (_heroCount != slides.length) {
      // Keep controller state in sync without setState loops.
      _heroCount = slides.length;
      if (_heroIndex >= _heroCount) _heroIndex = 0;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(16, topInset + 10, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _topRow(context, profileName),
          const SizedBox(height: 12),
          _chipsRow(context),
          const SizedBox(height: 14),
          _heroCard(context, slides),
        ],
      ),
    );
  }

  Widget _topRow(BuildContext context, String name) {
    return Row(
      children: [
        Expanded(
          child: ForUserHeader(userName: name),
        ),
        _iconButton(
          context,
          icon: Icons.cast_rounded,
          onTap: () {},
        ),
        const SizedBox(width: 4),
        _iconButton(
          context,
          icon: Icons.file_download_outlined,
          onTap: () {},
        ),
        const SizedBox(width: 4),
        _iconButton(
          context,
          icon: Icons.search_rounded,
          onTap: () => context.go('/search?scope=all'),
        ),
        const SizedBox(width: 4),
        _iconButton(
          context,
          icon: Icons.person_rounded,
          onTap: () => _openProfileMenu(context),
          key: _profileIconKey,
        ),
      ],
    );
  }

  void _openProfileMenu(BuildContext context) {
    Haptics.selection();
    final rootContext = context;

    final buttonBox =
        _profileIconKey.currentContext?.findRenderObject() as RenderBox?;
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    final offset = (buttonBox != null && overlayBox != null)
        ? buttonBox.localToGlobal(Offset.zero, ancestor: overlayBox)
        : const Offset(0, 0);
    final size = buttonBox?.size ?? const Size(44, 44);

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Profile',
      barrierColor: Colors.black.withOpacity(0.28),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned(
                top: offset.dy + size.height + 10,
                right: 16,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 240),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
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
                            _menuItem(
                              context,
                              icon: Icons.switch_account_rounded,
                              label: 'Switch Profile',
                              onTap: () => rootContext.push('/profiles'),
                            ),
                            _menuItem(
                              context,
                              icon: Icons.manage_accounts_rounded,
                              label: 'Profile Settings',
                              onTap: () => rootContext.push('/profile-settings'),
                            ),
                            _menuItem(
                              context,
                              icon: Icons.local_offer_rounded,
                              label: 'Pricing',
                              onTap: () => rootContext.go('/pricing'),
                            ),
                            const Divider(
                                height: 1, color: AppColors.borderSubtle),
                            _menuItem(
                              context,
                              icon: Icons.login_rounded,
                              label: 'Login',
                              onTap: () => rootContext.push('/login'),
                            ),
                            _menuItem(
                              context,
                              icon: Icons.person_add_alt_1_rounded,
                              label: 'Sign Up',
                              onTap: () => rootContext.push('/signup'),
                            ),
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
                Tween<Offset>(begin: const Offset(0, -0.02), end: Offset.zero)
                    .animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
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

  Widget _chipsRow(BuildContext context) {
    Widget chip(String label, {bool dropdown = false}) {
      final active = dropdown;
      return InkWell(
        onTap: () {
          Haptics.selection();
          if (dropdown) {
            _openCategories(context);
            return;
          }
        },
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          key: dropdown ? _categoryChipKey : null,
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: active ? Colors.white.withOpacity(0.10) : AppColors.glassBg,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                dropdown ? _category : label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.textPrimary.withOpacity(0.90),
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.6,
                    ),
              ),
              if (dropdown) ...[
                const SizedBox(width: 6),
                Icon(Icons.keyboard_arrow_down_rounded,
                    size: 16, color: AppColors.textSecondary),
              ],
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          chip('Categories', dropdown: true),
        ],
      ),
    );
  }

  void _openCategories(BuildContext context) async {
    final buttonBox =
        _categoryChipKey.currentContext?.findRenderObject() as RenderBox?;
    final overlayBox =
        Overlay.of(context).context.findRenderObject() as RenderBox?;
    final position = (buttonBox != null && overlayBox != null)
        ? RelativeRect.fromRect(
            Rect.fromPoints(
              buttonBox.localToGlobal(Offset.zero, ancestor: overlayBox) +
                  Offset(0, buttonBox.size.height + 8),
              buttonBox.localToGlobal(Offset.zero, ancestor: overlayBox) +
                  Offset(buttonBox.size.width, buttonBox.size.height + 8),
            ),
            Offset.zero & overlayBox.size,
          )
        : const RelativeRect.fromLTRB(16, 120, 16, 0);

    final result = await showMenu<String>(
      context: context,
      position: position,
      color: const Color(0xD908080A),
      items: const [
        PopupMenuItem(value: 'Categories', child: Text('Categories')),
        PopupMenuItem(value: 'Action', child: Text('Action')),
        PopupMenuItem(value: 'Drama', child: Text('Drama')),
        PopupMenuItem(value: 'Comedy', child: Text('Comedy')),
      ],
    );
    if (!mounted) return;
    if (result == null) return;
    setState(() {
      _category = result;
    });
  }

  Widget _heroCard(BuildContext context, List<HeroSlide> slides) {
    final slide = slides[_heroIndex.clamp(0, slides.length - 1)];
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 380,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            PageView.builder(
              controller: _heroController,
              itemCount: slides.length,
              onPageChanged: (i) => setState(() => _heroIndex = i),
              itemBuilder: (context, index) {
                final s = slides[index];
                return AppImage(
                  source: s.image,
                  fit: BoxFit.cover,
                  placeholderBorderRadius: 0,
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.78),
                    Colors.black.withOpacity(0.30),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: Text(
                      slide.title,
                      key: ValueKey('title-${slide.id}'),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                            height: 1.0,
                          ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    child: Text(
                      slide.meta,
                      key: ValueKey('meta-${slide.id}'),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withOpacity(0.60),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _ctaPrimary(
                          context,
                          icon: Icons.play_arrow_rounded,
                          label: 'Play',
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _ctaGhost(
                          context,
                          icon: Icons.add_rounded,
                          label: 'My List',
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ctaPrimary(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Haptics.selection();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ctaGhost(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Haptics.selection();
        onTap();
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconButton(
    BuildContext context, {
    required IconData icon,
    required VoidCallback onTap,
    Key? key,
  }) {
    return InkWell(
      onTap: () {
        Haptics.selection();
        onTap();
      },
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        key: key,
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: AppColors.textPrimary),
      ),
    );
  }
}
