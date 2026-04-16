import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../utils/extensions.dart';
import 'glass_container.dart';

class ProfileMenuButton extends StatefulWidget {
  const ProfileMenuButton({super.key});

  @override
  State<ProfileMenuButton> createState() => _ProfileMenuButtonState();
}

class _ProfileMenuButtonState extends State<ProfileMenuButton> {
  final _buttonKey = GlobalKey();

  void _openMenu() {
    Haptics.selection();
    final rootContext = context;

    final buttonBox = _buttonKey.currentContext?.findRenderObject() as RenderBox?;
    final overlayBox = Overlay.of(context).context.findRenderObject() as RenderBox?;
    final offset = (buttonBox != null && overlayBox != null)
        ? buttonBox.localToGlobal(Offset.zero, ancestor: overlayBox)
        : const Offset(0, 0);
    final size = buttonBox?.size ?? const Size(44, 44);

    showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Profile',
      barrierColor: Colors.black.withOpacity(0.28),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned(
                top: offset.dy + size.height + 10,
                right: 16,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 240),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: GlassContainer(
                      blurSigma: 24,
                      borderRadius: BorderRadius.circular(16),
                      decoration: BoxDecoration(
                        color: const Color(0xD908080A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.glassBorder),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _menuItem(
                              context,
                              icon: Icons.switch_account_rounded,
                              label: 'Switch Profile',
                              onTap: () => rootContext.push('/profiles'),
                            ),
                            _menuItem(
                              context,
                              icon: Icons.manage_accounts_rounded,
                              label: 'Profile Settings',
                              onTap: () => rootContext.push('/profile-settings'),
                            ),
                            _menuItem(
                              context,
                              icon: Icons.local_offer_rounded,
                              label: 'Pricing',
                              onTap: () => rootContext.go('/pricing'),
                            ),
                            const Divider(
                                height: 1, color: AppColors.borderSubtle),
                            _menuItem(
                              context,
                              icon: Icons.login_rounded,
                              label: 'Login',
                              onTap: () => rootContext.push('/login'),
                            ),
                            _menuItem(
                              context,
                              icon: Icons.person_add_alt_1_rounded,
                              label: 'Sign Up',
                              onTap: () => rootContext.push('/signup'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position:
                Tween<Offset>(begin: const Offset(0, -0.02), end: Offset.zero)
                    .animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: AppColors.textFaint),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _buttonKey,
      onTap: _openMenu,
      borderRadius: BorderRadius.circular(999),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Icon(Icons.person_rounded, color: AppColors.textPrimary),
      ),
    );
  }
}
