import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../models/hero_slide.dart';
import '../providers/content_provider.dart';
import '../providers/app_content_provider.dart';
import '../theme/app_colors.dart';
import 'app_image.dart';

class HeroSlider extends ConsumerStatefulWidget {
  const HeroSlider({super.key, this.height});

  /// Optional explicit height for the slider.
  ///
  /// If null, the widget will use its parent constraint height when bounded,
  /// otherwise it falls back to the full screen height.
  final double? height;

  @override
  ConsumerState<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends ConsumerState<HeroSlider> {
  final _controller = PageController();
  Timer? _timer;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(8.seconds, (_) {
      if (!mounted) return;
      if (!_controller.hasClients) return;
      final slides =
          ref.read(heroSlidesProvider).valueOrNull ?? const [fallbackHeroSlide];
      final next = ((_controller.page ?? 0).round() + 1) % slides.length;
      _controller.animateToPage(next,
          duration: 550.ms, curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncSlides = ref.watch(heroSlidesProvider);
    final slides = asyncSlides.valueOrNull ?? const [fallbackHeroSlide];

    ref.listen<AsyncValue<List<HeroSlide>>>(heroSlidesProvider,
        (previous, next) {
      final newSlides = next.valueOrNull;
      if (newSlides == null || newSlides.isEmpty) return;
      ref.read(contentProvider.notifier).setHeroSlide(newSlides.first);
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        final computedHeight = widget.height ??
            (constraints.hasBoundedHeight ? constraints.maxHeight : null) ??
            MediaQuery.of(context).size.height;

        return SizedBox(
          height: computedHeight,
          child: Stack(
            children: [
              PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (index) {
                  ref
                      .read(contentProvider.notifier)
                      .setHeroSlide(slides[index]);
                },
                itemBuilder: (context, index) {
                  final slide = slides[index];
                  return _HeroSlideView(
                    slide: slide,
                    dragOffset: _dragOffset,
                    onPointerMoveDelta: (dx) {
                      setState(() => _dragOffset =
                          (_dragOffset + dx).clamp(-30, 30));
                    },
                    onPointerEnd: () => setState(() => _dragOffset = 0),
                  );
                },
              ),
              Positioned(
                left: 16,
                bottom: 18,
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: slides.length,
                  effect: WormEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: AppColors.accent,
                    dotColor: Colors.white.withOpacity(0.28),
                  ),
                ),
              ),
              if (asyncSlides.hasError)
                Positioned(
                  left: 16,
                  top: MediaQuery.of(context).padding.top + 12,
                  right: 16,
                  child: IgnorePointer(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Text(
                        'Content load failed: ${asyncSlides.error}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroSlideView extends StatelessWidget {
  const _HeroSlideView({
    required this.slide,
    required this.dragOffset,
    required this.onPointerMoveDelta,
    required this.onPointerEnd,
  });

  final HeroSlide slide;
  final double dragOffset;
  final ValueChanged<double> onPointerMoveDelta;
  final VoidCallback onPointerEnd;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width >= 640 ? 672.0 : 520.0;
    final leftPadding = MediaQuery.of(context).size.width >= 640 ? 40.0 : 16.0;

    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerMove: (e) => onPointerMoveDelta(e.delta.dx),
      onPointerUp: (_) => onPointerEnd(),
      onPointerCancel: (_) => onPointerEnd(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Transform.translate(
            offset: Offset(dragOffset, 0),
            child: AppImage(
              source: slide.image,
              fit: BoxFit.cover,
              placeholderBorderRadius: 0,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [AppColors.background, Colors.transparent],
              ),
            ),
          ),
          Positioned(
            left: leftPadding,
            right: 16,
            bottom: 90,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: _HeroSlideContent(slide: slide),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSlideContent extends StatelessWidget {
  const _HeroSlideContent({required this.slide});
  final HeroSlide slide;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'theFlashx',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.accent,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.8,
              ),
        ),
        const Gap(10),
        Text(
          slide.meta,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textMuted),
        ),
        const Gap(10),
        Text(slide.title)
            .animate()
            .slideY(
                begin: 0.3, end: 0, duration: 800.ms, curve: Curves.easeOutExpo)
            .fadeIn(duration: 800.ms),
        const Gap(10),
        Text(
          slide.description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.textSecondary),
        ).animate(delay: 300.ms).fadeIn(duration: 600.ms),
        const Gap(16),
        LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxWidth < 360;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _ctaWhite(
                    context,
                    label: 'Watch Now',
                    icon: Icons.play_arrow_rounded,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  _ctaGhost(
                    context,
                    label: 'Add to List',
                    icon: Icons.add_rounded,
                    onTap: () {},
                  ),
                  const SizedBox(width: 8),
                  _ctaGhost(
                    context,
                    label: 'More Info',
                    icon: Icons.info_outline_rounded,
                    onTap: () {},
                    iconOnly: compact,
                  ),
                ],
              ),
            );
          },
        )
            .animate(delay: 500.ms)
            .slideY(begin: 0.2, end: 0, duration: 500.ms)
            .fadeIn(duration: 500.ms),
      ],
    );
  }

  Widget _ctaWhite(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.black, size: 20),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ctaGhost(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
    bool iconOnly = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: iconOnly ? 10 : 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 20),
            if (!iconOnly) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
