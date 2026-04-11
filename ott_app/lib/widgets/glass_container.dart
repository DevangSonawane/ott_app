import 'dart:ui';

import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.enabled = true,
    this.blurSigma = 12,
    this.decoration,
    this.borderRadius,
  });

  final Widget child;
  final bool enabled;
  final double blurSigma;
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    if (!enabled) {
      return DecoratedBox(
        decoration: decoration ??
            BoxDecoration(
              borderRadius: effectiveBorderRadius,
              color: Colors.transparent,
            ),
        child: child,
      );
    }
    return ClipRRect(
      borderRadius: effectiveBorderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: DecoratedBox(
          decoration: decoration ??
              BoxDecoration(
                borderRadius: effectiveBorderRadius,
                color: Colors.white.withOpacity(0.06),
              ),
          child: child,
        ),
      ),
    );
  }
}
