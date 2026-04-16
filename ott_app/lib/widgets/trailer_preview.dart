import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'dart:async';

import 'app_image.dart';

class TrailerPreview extends StatefulWidget {
  const TrailerPreview({
    super.key,
    required this.fallbackImage,
    required this.trailerUrl,
    this.borderRadius = 18,
  });

  final String fallbackImage;
  final String trailerUrl;
  final double borderRadius;

  @override
  State<TrailerPreview> createState() => _TrailerPreviewState();
}

class _TrailerPreviewState extends State<TrailerPreview> {
  YoutubePlayerController? _controller;
  StreamSubscription<YoutubePlayerValue>? _sub;
  Object? _error;

  @override
  void initState() {
    super.initState();
    final id = _youTubeId(widget.trailerUrl);
    if (id == null) return;

    try {
      final ctrl = YoutubePlayerController(
        params: YoutubePlayerParams(
          mute: true,
          showControls: false,
          showFullscreenButton: false,
          playsInline: true,
          strictRelatedVideos: true,
          userAgent: _browserUserAgent(),
        ),
        onWebResourceError: (e) {
          if (!mounted) return;
          setState(() => _error = e);
        },
      );
      ctrl.loadVideoById(videoId: id);

      _sub = ctrl.stream.listen((v) async {
        if (!mounted) return;
        if (v.hasError) {
          setState(() => _error = v.error);
          // Stop rendering the player when YouTube blocks embeds.
          await ctrl.close();
          if (!mounted) return;
          setState(() => _controller = null);
        }
      });

      _controller = ctrl;
    } catch (e) {
      _controller = null;
      _error = e;
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = _controller;
    if (ctrl == null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          AppImage(
            source: widget.fallbackImage,
            fit: BoxFit.cover,
            placeholderBorderRadius: 0,
          ),
          if (_error != null && kDebugMode)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                'Trailer preview unavailable ($_error)',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.55),
                    ),
              ),
            ),
        ],
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Stack(
          fit: StackFit.expand,
          children: [
            AppImage(
              source: widget.fallbackImage,
              fit: BoxFit.cover,
              placeholderBorderRadius: 0,
            ),
            YoutubePlayer(
              controller: ctrl,
              aspectRatio: 16 / 9,
              backgroundColor: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  String _browserUserAgent() {
    // Best-effort UA spoofing; doesn't guarantee embeddability.
    return switch (defaultTargetPlatform) {
      TargetPlatform.iOS =>
        'Mozilla/5.0 (iPhone; CPU iPhone OS 17_4 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.4 Mobile/15E148 Safari/604.1',
      TargetPlatform.android =>
        'Mozilla/5.0 (Linux; Android 13; Pixel 7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Mobile Safari/537.36',
      _ =>
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 14_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
    };
  }

  // Keep the existing URL parsing logic unchanged.
  String? _youTubeId(String url) {
    final raw = url.trim();
    if (raw.isEmpty) return null;

    final uri = Uri.tryParse(raw);
    if (uri == null) return null;

    final host = uri.host.toLowerCase();
    if (host.contains('youtu.be')) {
      final seg = uri.pathSegments;
      return seg.isEmpty ? null : seg.first;
    }

    if (host.contains('youtube.com')) {
      final v = uri.queryParameters['v'];
      if (v != null && v.isNotEmpty) return v;
      // /embed/<id>
      if (uri.pathSegments.length >= 2 && uri.pathSegments[0] == 'embed') {
        return uri.pathSegments[1];
      }
    }
    return null;
  }
}
