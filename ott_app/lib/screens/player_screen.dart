import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

        return Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    color: const Color(0xFF0B0E12),
                    alignment: Alignment.center,
                    child: Text(
                      'PLAYER (stub)\n${movie.title}',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
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
                    child: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white),
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
