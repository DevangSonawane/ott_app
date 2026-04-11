import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'shimmer_placeholder.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholderBorderRadius = 12,
  });

  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double placeholderBorderRadius;

  bool get _isAsset => source.startsWith('assets/');
  bool get _isNetwork =>
      source.startsWith('http://') || source.startsWith('https://');
  bool get _isLocalAssetLike => !_isNetwork && source.isNotEmpty;

  List<String> _assetCandidates(String input) {
    final normalized = input.trim().replaceAll('\\', '/');
    final out = <String>[];

    void add(String value) {
      final v = value.trim();
      if (v.isEmpty || out.contains(v)) return;
      out.add(v);
      final encoded = Uri.encodeFull(v);
      if (encoded != v && !out.contains(encoded)) {
        out.add(encoded);
      }
    }

    add(normalized);

    final noLeadingSlash =
        normalized.startsWith('/') ? normalized.substring(1) : normalized;
    add(noLeadingSlash);

    if (!noLeadingSlash.startsWith('assets/') &&
        !noLeadingSlash.startsWith('public/')) {
      add('public/$noLeadingSlash');
      add('assets/web/$noLeadingSlash');
    }

    if (noLeadingSlash.startsWith('public/')) {
      add('assets/web/${noLeadingSlash.substring('public/'.length)}');
    }
    if (noLeadingSlash.startsWith('assets/web/')) {
      add('public/${noLeadingSlash.substring('assets/web/'.length)}');
    }

    return out;
  }

  Widget _brokenImage() {
    return Container(
      width: width,
      height: height,
      color: AppColors.card,
      alignment: Alignment.center,
      child: const Icon(Icons.broken_image_rounded, color: AppColors.textMuted),
    );
  }

  Widget _buildAssetChain(List<String> candidates, int index) {
    if (index >= candidates.length) return _brokenImage();
    final candidate = candidates[index];
    return Image.asset(
      candidate,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stack) {
        if (index == candidates.length - 1) {
          debugPrint('AppImage asset failed: $source ($error)');
        }
        return _buildAssetChain(candidates, index + 1);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (source.isEmpty) {
      child = _brokenImage();
    } else if (_isAsset) {
      child = _buildAssetChain(_assetCandidates(source), 0);
    } else if (_isNetwork) {
      child = CachedNetworkImage(
        imageUrl: source,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, _) => ShimmerPlaceholder(
          width: width ?? MediaQuery.of(context).size.width,
          height: height ?? (MediaQuery.of(context).size.width * 9 / 16),
          borderRadius: placeholderBorderRadius,
        ),
        errorWidget: (context, error, __) {
          debugPrint('AppImage network failed: $source ($error)');
          return _brokenImage();
        },
      );
    } else if (_isLocalAssetLike) {
      child = _buildAssetChain(_assetCandidates(source), 0);
    } else {
      child = _brokenImage();
    }

    final br = borderRadius;
    if (br == null) return child;
    return ClipRRect(borderRadius: br, child: child);
  }
}
