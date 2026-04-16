import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

import '../providers/app_content_provider.dart';
import '../providers/player_provider.dart';
import '../theme/app_colors.dart';

class PlayerScreen extends ConsumerWidget {
  const PlayerScreen({super.key, required this.contentId});

  final String contentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncMovie = ref.watch(contentByIdProvider(contentId));
    final topPadding = MediaQuery.of(context).padding.top;

    return asyncMovie.when(
      data: (movie) {
        if (movie == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: Center(
              child: Text(
                'Content not found.',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        ref.read(playerProvider.notifier).play(movie);

        return _PlayerScaffold(
          topPadding: topPadding,
          contentId: contentId,
        );
      },
      loading: () => const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'Unable to load player. ($e)',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

class _PlayerScaffold extends ConsumerStatefulWidget {
  const _PlayerScaffold({
    required this.topPadding,
    required this.contentId,
  });

  final double topPadding;
  final String contentId;

  @override
  ConsumerState<_PlayerScaffold> createState() => _PlayerScaffoldState();
}

class _PlayerScaffoldState extends ConsumerState<_PlayerScaffold> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _trailerLaunchAttempted = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final movie = await ref.read(contentByIdProvider(widget.contentId).future);
    if (!mounted || movie == null) return;

    final videoUrl = (movie.videoUrl ?? '').trim();
    final trailer = (movie.trailer ?? '').trim();

    if (videoUrl.isNotEmpty && !_looksLikeYouTube(videoUrl)) {
      try {
        final controller =
            VideoPlayerController.networkUrl(Uri.parse(videoUrl));
        await controller.initialize();
        if (!mounted) {
          await controller.dispose();
          return;
        }
        setState(() {
          _videoController = controller;
          _chewieController = ChewieController(
            videoPlayerController: controller,
            autoPlay: true,
            looping: false,
            allowFullScreen: true,
            allowMuting: true,
            showControlsOnInitialize: false,
          );
        });
        return;
      } catch (e) {
        if (!mounted) return;
        setState(() => _error = 'Unable to play videoUrl. ($e)');
        return;
      }
    }

    if (trailer.isNotEmpty) {
      // This mirrors the React app: playback is via YouTube trailers.
      // We open the trailer inside an in-app web view so users stay in the app.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _openTrailer(trailer);
      });
      return;
    }

    if (!mounted) return;
    setState(() => _error = 'No playable trailer/video for this title.');
  }

  bool _looksLikeYouTube(String url) {
    final lower = url.toLowerCase();
    return lower.contains('youtube.com') || lower.contains('youtu.be');
  }

  Future<void> _openTrailer(String url) async {
    if (_trailerLaunchAttempted) return;
    _trailerLaunchAttempted = true;

    Uri? uri;
    try {
      uri = Uri.parse(url);
    } catch (_) {}
    if (uri == null) {
      setState(() => _error = 'Invalid trailer URL.');
      return;
    }

    final ok = await launchUrl(uri, mode: LaunchMode.inAppWebView);
    if (!ok && mounted) {
      setState(() => _error = 'Unable to open trailer URL.');
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = widget.topPadding;
    final chewie = _chewieController;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: chewie != null
                  ? Chewie(controller: chewie)
                  : Container(
                      color: const Color(0xFF0B0E12),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_error != null) ...[
                            Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.35,
                                  ),
                            ),
                            const SizedBox(height: 14),
                          ],
                          Consumer(
                            builder: (context, ref, _) {
                              final asyncMovie =
                                  ref.watch(contentByIdProvider(widget.contentId));
                              final trailer = asyncMovie.valueOrNull?.trailer;
                              final trailerUrl = (trailer ?? '').trim();
                              if (trailerUrl.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return ElevatedButton.icon(
                                onPressed: () => _openTrailer(trailerUrl),
                                icon: const Icon(Icons.play_arrow_rounded),
                                label: const Text('OPEN TRAILER'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accent,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 12),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          Positioned(
            top: topPadding + 12,
            left: 12,
            child: InkWell(
              onTap: () => context.pop(),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child:
                    const Icon(Icons.arrow_back_rounded, color: Colors.white),
              ),
            ),
          ),
          Positioned(
            top: topPadding + 12,
            right: 12,
            child: InkWell(
              onTap: () => ref.read(playerProvider.notifier).stop(),
              borderRadius: BorderRadius.circular(999),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: Colors.white.withOpacity(0.12)),
                ),
                child: const Icon(Icons.close_rounded, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
