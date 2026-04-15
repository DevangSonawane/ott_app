import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/player_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../utils/extensions.dart';
import 'glass_container.dart';

class MiniPlayerBar extends ConsumerWidget {
  const MiniPlayerBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final player = ref.watch(playerProvider);
    final current = player.current;
    if (current == null) return const SizedBox.shrink();

    final bottomSafe = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomSafe + 8),
      child: GlassContainer(
        blurSigma: 24,
        borderRadius: BorderRadius.circular(18),
        decoration: AppDecorations.glassDecoration.copyWith(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0xD908080A),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: InkWell(
          onTap: () => context.push('/player/${current.id}'),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColors.accent.withOpacity(0.18),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: AppColors.accent, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        current.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Now Playing',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.0,
                            ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Haptics.selection();
                    ref.read(playerProvider.notifier).stop();
                  },
                  icon: const Icon(Icons.close_rounded,
                      color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
