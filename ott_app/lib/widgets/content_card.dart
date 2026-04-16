import 'dart:ui';

import 'package:flutter/material.dart';

import '../models/movie.dart';
import '../theme/app_colors.dart';
import '../utils/extensions.dart';
import 'app_image.dart';

enum ContentCardVariant { defaultPoster, continueWatching, top10, largePoster }

class ContentCard extends StatefulWidget {
  const ContentCard({
    super.key,
    required this.content,
    required this.variant,
    required this.onSelect,
    this.rank,
  });

  final Movie content;
  final ContentCardVariant variant;
  final ValueChanged<Movie> onSelect;
  final int? rank;

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  bool _overlayVisible = false;
  late final AnimationController _overlayController;
  late final Animation<double> _overlayAnim;

  (double w, double h) _sizeForVariant() {
    switch (widget.variant) {
      case ContentCardVariant.defaultPoster:
        return (150, 225);
      case ContentCardVariant.continueWatching:
        return (280, 158);
      case ContentCardVariant.top10:
        return (240, 330);
      case ContentCardVariant.largePoster:
        return (220, 320);
    }
  }

  @override
  void initState() {
    super.initState();
    _overlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _overlayAnim = CurvedAnimation(
      parent: _overlayController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _overlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (w, h) = _sizeForVariant();
    final isTop10 =
        widget.variant == ContentCardVariant.top10 && widget.rank != null;
    final posterRadiusValue = isTop10
        ? 22.0
        : (widget.variant == ContentCardVariant.largePoster ? 28.0 : 12.0);
    final borderRadius = BorderRadius.circular(posterRadiusValue);
    return RepaintBoundary(
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: () async {
          Haptics.light();
          widget.onSelect(widget.content);
        },
        onLongPress: () async {
          Haptics.medium();
          if (_overlayVisible) return;
          setState(() => _overlayVisible = true);
          _overlayController.forward(from: 0);
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOutCubic,
          scale: _pressed ? 0.96 : 1.0,
          child: SizedBox(
            width: w,
            height: h,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                if (isTop10) ...[
                  Positioned(
                    left: -25,
                    bottom: -6,
                    child: _RankNumber(
                      rank: widget.rank!,
                      fontSize: 158,
                      strokeColor: AppColors.accent,
                    ),
                  ),
                  Positioned(
                    left: 54,
                    bottom: 0,
                    child: SizedBox(
                      width: 170,
                      height: h - 12,
                      child: _posterWithInfo(
                        width: 170,
                        height: h - 12,
                        radius: borderRadius,
                        showTypeBadge: true,
                      ),
                    ),
                  ),
                  if (widget.content.rating != null)
                    Positioned(
                      left: 54 + 12,
                      top: 40,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.background.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.accent),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.38),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star_rounded,
                                size: 14, color: AppColors.accent),
                            const SizedBox(width: 4),
                            Text(
                              (widget.content.rating! * 10).toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ] else
                  _posterWithInfo(
                    width: w,
                    height: h,
                    radius: borderRadius,
                    showTypeBadge: true,
                  ),
                if (widget.variant == ContentCardVariant.continueWatching &&
                    widget.content.progress != null)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: 3,
                      color: AppColors.borderSubtle,
                      child: AnimatedFractionallySizedBox(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeOutCubic,
                        alignment: Alignment.centerLeft,
                        widthFactor:
                            (widget.content.progress!.clamp(0, 100)) / 100,
                        child: Container(color: AppColors.accent),
                      ),
                    ),
                  ),
                if (widget.variant == ContentCardVariant.defaultPoster &&
                    widget.content.genre.isNotEmpty)
                  Positioned(
                    left: 8,
                    bottom: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary.withOpacity(0.75),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: Text(
                        widget.content.genre.first,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary.withOpacity(0.92),
                        ),
                      ),
                    ),
                  ),
                if (widget.variant == ContentCardVariant.defaultPoster &&
                    widget.content.rating != null)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.backgroundSecondary.withOpacity(0.70),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        (widget.content.rating! * 10).toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                if (_overlayVisible)
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: _closeOverlay,
                      child: AnimatedBuilder(
                        animation: _overlayAnim,
                        builder: (context, child) =>
                            Opacity(opacity: _overlayAnim.value, child: child),
                        child: ClipRRect(
                          borderRadius: borderRadius,
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                            child: Container(
                              color: AppColors.background.withOpacity(0.82),
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: _closeOverlay,
                                      borderRadius: BorderRadius.circular(999),
                                      child: const Padding(
                                        padding: EdgeInsets.all(6),
                                        child: Icon(Icons.close_rounded,
                                            color: Colors.white54, size: 18),
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    widget.content.title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      _overlayBtn(
                                        icon: Icons.play_arrow_rounded,
                                        filled: true,
                                        onTap: () {
                                          _closeOverlay();
                                          widget.onSelect(widget.content);
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      _overlayBtn(
                                          icon: Icons.add_rounded,
                                          onTap: _closeOverlay),
                                      const SizedBox(width: 10),
                                      _overlayBtn(
                                          icon: Icons.info_outline_rounded,
                                          onTap: _closeOverlay),
                                    ],
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
            ),
          ),
        ),
      ),
    );
  }

  void _closeOverlay() {
    _overlayController.reverse().then((_) {
      if (!mounted) return;
      setState(() => _overlayVisible = false);
    });
  }

  Widget _overlayBtn({
    required IconData icon,
    required VoidCallback onTap,
    bool filled = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? Colors.white : Colors.white.withOpacity(0.06),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Icon(icon, color: filled ? Colors.black : Colors.white),
      ),
    );
  }

  Widget _posterWithInfo({
    required double width,
    required double height,
    required BorderRadius radius,
    required bool showTypeBadge,
  }) {
    final isSeries = widget.content.type == 'series';
    final rating = widget.content.rating;
    final metaLeft = isSeries ? 'TV' : widget.content.year.toString();
    final large = widget.variant == ContentCardVariant.largePoster;
    final titleSize = large ? 13.5 : 12.0;
    final metaSize = large ? 10.5 : 10.0;
    final showBottomRating = widget.variant != ContentCardVariant.top10;

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.38),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppImage(
              source: widget.content.image,
              width: width,
              height: height,
              fit: BoxFit.cover,
              placeholderBorderRadius: radius.topLeft.x,
            ),
            // Gradient overlay like web ContentCard.
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.95),
                    Colors.black.withOpacity(0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            if (showTypeBadge)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.50),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    isSeries ? 'SERIES' : 'HD',
                    style: const TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.content.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: titleSize,
                      height: 1.05,
                      letterSpacing: -0.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        metaLeft,
                        style: TextStyle(
                          fontSize: metaSize,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withOpacity(0.40),
                          letterSpacing: 1.4,
                        ),
                      ),
                      const Spacer(),
                      if (showBottomRating && rating != null)
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: AppColors.accent,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              (rating * 10).toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: Colors.white.withOpacity(0.60),
                              ),
                            ),
                          ],
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
}

class _RankNumber extends StatelessWidget {
  const _RankNumber({
    required this.rank,
    required this.fontSize,
    required this.strokeColor,
  });
  final int rank;
  final double fontSize;
  final Color strokeColor;

  @override
  Widget build(BuildContext context) {
    final text = rank.toString();
    return Stack(
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..color = strokeColor
              ..strokeWidth = 2.0,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            fontStyle: FontStyle.italic,
            color: Colors.transparent,
          ),
        ),
      ],
    );
  }
}
