import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';

class GradientButton extends StatefulWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.gradient,
    this.height = 52,
    this.borderRadius = 14,
    this.fullWidth = true,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Gradient? gradient;
  final double height;
  final double borderRadius;
  final bool fullWidth;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(widget.borderRadius);
    final decoration = widget.gradient != null
        ? BoxDecoration(gradient: widget.gradient)
        : AppDecorations.gradientButtonDecoration;
    final child = AnimatedScale(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      scale: _pressed ? 0.98 : 1,
      child: Container(
        height: widget.height,
        decoration: decoration.copyWith(
          borderRadius: borderRadius,
          boxShadow: [AppDecorations.accentGlow],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _pressed = true),
            onTapCancel: () => setState(() => _pressed = false),
            onTapUp: (_) => setState(() => _pressed = false),
            borderRadius: borderRadius,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.icon != null) ...[
                    Icon(widget.icon, color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                  ],
                  Flexible(
                    child: Text(
                      widget.label,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final keyed = KeyedSubtree(key: ValueKey(widget.label), child: child);
    return widget.fullWidth
        ? SizedBox(width: double.infinity, child: keyed)
        : keyed;
  }
}
