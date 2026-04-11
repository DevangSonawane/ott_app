import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../models/user_profile.dart';
import '../providers/content_provider.dart';
import '../providers/profile_provider.dart';
import '../theme/app_colors.dart';
import '../utils/constants.dart';
import '../utils/extensions.dart';
import '../widgets/shimmer_placeholder.dart';

class ProfileSelectionScreen extends ConsumerWidget {
  const ProfileSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);
    final isTablet =
        MediaQuery.of(context).size.width >= AppBreakpoints.tabletMin;
    final avatarSize = isTablet ? 128.0 : 96.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [
              Column(
                children: [
                  Text(
                    "Who's watching?",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: notifier.toggleEditMode,
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                      child: Text(
                        state.isEditMode ? 'Done' : 'Manage Profiles',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(24),
              Expanded(
                child: SingleChildScrollView(
                  child: Center(
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 24,
                      runSpacing: 24,
                      children: [
                        for (var i = 0; i < state.profiles.length; i++)
                          _ProfileCard(
                            profile: state.profiles[i],
                            avatarSize: avatarSize,
                            isEditMode: state.isEditMode,
                            isEditing:
                                state.editingProfileId == state.profiles[i].id,
                            index: i,
                            onTap: () {
                              if (state.isEditMode) {
                                notifier.startEditing(state.profiles[i].id);
                                return;
                              }
                              ref
                                  .read(contentProvider.notifier)
                                  .selectProfile(state.profiles[i]);
                              context.pop();
                            },
                            onNameChanged: (name) => notifier.renameProfile(
                                id: state.profiles[i].id, name: name),
                          ),
                        _AddProfileCard(
                          avatarSize: avatarSize,
                          index: state.profiles.length,
                          onTap: () {
                            Haptics.medium();
                            notifier.addProfile();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatefulWidget {
  const _ProfileCard({
    required this.profile,
    required this.avatarSize,
    required this.isEditMode,
    required this.isEditing,
    required this.index,
    required this.onTap,
    required this.onNameChanged,
  });

  final UserProfile profile;
  final double avatarSize;
  final bool isEditMode;
  final bool isEditing;
  final int index;
  final VoidCallback onTap;
  final ValueChanged<String> onNameChanged;

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.profile.name);

  @override
  void didUpdateWidget(covariant _ProfileCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.name != widget.profile.name &&
        _controller.text != widget.profile.name) {
      _controller.text = widget.profile.name;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onLongPress: widget.isEditMode ? null : widget.onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: widget.avatarSize,
                height: widget.avatarSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: widget.isEditMode
                        ? AppColors.accent
                        : AppColors.borderSubtle,
                    width: widget.isEditMode ? 1.2 : 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.profile.avatar,
                    fit: BoxFit.cover,
                    placeholder: (context, _) => ShimmerPlaceholder(
                      width: widget.avatarSize,
                      height: widget.avatarSize,
                      borderRadius: 8,
                    ),
                  ),
                ),
              ),
              if (widget.profile.isKids)
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Text(
                      'KIDS',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.6,
                          ),
                    ),
                  ),
                ),
              if (widget.isEditMode)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.borderSubtle),
                      ),
                      child: const Icon(Icons.edit_rounded,
                          color: AppColors.textPrimary),
                    ),
                  ),
                ),
            ],
          ),
          const Gap(10),
          SizedBox(
            width: widget.avatarSize,
            child: widget.isEditMode && widget.isEditing
                ? TextField(
                    controller: _controller,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                        border: InputBorder.none, isDense: true),
                    onSubmitted: widget.onNameChanged,
                  )
                : Text(
                    widget.profile.name,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
          ),
        ],
      ),
    )
        .animate(delay: (widget.index * 100).ms)
        .scaleXY(
            begin: 0.8, end: 1.0, duration: 500.ms, curve: Curves.easeOutExpo)
        .fadeIn(duration: 500.ms);
  }
}

class _AddProfileCard extends StatelessWidget {
  const _AddProfileCard(
      {required this.avatarSize, required this.index, required this.onTap});
  final double avatarSize;
  final int index;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: AppColors.borderSubtle, style: BorderStyle.solid),
              color: Colors.white.withOpacity(0.03),
            ),
            child: const Icon(Icons.add_rounded,
                color: AppColors.textMuted, size: 34),
          ),
          const Gap(10),
          SizedBox(
            width: avatarSize,
            child: Text(
              'Add Profile',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted),
            ),
          ),
        ],
      ),
    )
        .animate(delay: (index * 100).ms)
        .scaleXY(
            begin: 0.8, end: 1.0, duration: 500.ms, curve: Curves.easeOutExpo)
        .fadeIn(duration: 500.ms);
  }
}
