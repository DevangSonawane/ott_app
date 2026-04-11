import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';

import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../utils/constants.dart';
import 'gradient_button.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet =
        MediaQuery.of(context).size.width >= AppBreakpoints.tabletMin;
    final columns = isTablet ? 4 : 2;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _social(Icons.alternate_email_rounded),
              const SizedBox(width: 10),
              _social(Icons.camera_alt_outlined),
              const SizedBox(width: 10),
              _social(Icons.facebook_rounded),
              const SizedBox(width: 10),
              _social(Icons.play_circle_outline_rounded),
            ],
          ),
          const Gap(18),
          LayoutBuilder(
            builder: (context, constraints) {
              final spacing = 18.0;
              final tileWidth =
                  (constraints.maxWidth - (columns - 1) * spacing) / columns;

              Widget tile(Widget child, {double? width}) {
                return SizedBox(width: width ?? tileWidth, child: child);
              }

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  tile(_section(context, title: 'Browse', items: const [
                    'Home',
                    'TV Shows',
                    'Movies',
                    'Originals',
                    'New & Popular',
                  ])),
                  tile(_section(context, title: 'Help', items: const [
                    'Account',
                    'Support Center',
                    'Privacy',
                    'Terms of Use',
                    'Contact Us',
                  ])),
                  tile(_section(context, title: 'Legal', items: const [
                    'Cookie Preferences',
                    'Corporate Information',
                    'Legal Notices',
                    'Accessibility',
                  ])),
                  tile(
                    _stayUpdated(context),
                    width: isTablet ? null : constraints.maxWidth,
                  ),
                ],
              );
            },
          ),
          const Gap(18),
          const Divider(color: AppColors.borderSubtle, height: 1),
          const Gap(14),
          Row(
            children: [
              RichText(
                text: TextSpan(
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                  children: const [
                    TextSpan(text: 'theFlash'),
                    TextSpan(
                        text: 'x', style: TextStyle(color: AppColors.accent)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Entertainment without limits',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textMuted),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Text(
                  'English',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textMuted),
                ),
              ),
            ],
          ),
          const Gap(10),
          Text(
            '© 2024',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textFaint),
          ),
        ],
      ),
    );
  }

  Widget _social(IconData icon) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 20),
      ),
    ).animate().scaleXY(begin: 0.98, end: 1, duration: 240.ms);
  }

  Widget _section(BuildContext context,
      {required String title, required List<String> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
        ),
        const Gap(10),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              item,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted),
            ),
          ),
      ],
    );
  }

  Widget _stayUpdated(BuildContext context) {
    final controller = TextEditingController();
    return Container(
      decoration: AppDecorations.cardDecoration.copyWith(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Stay Updated',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const Gap(8),
          Text(
            'Get occasional updates on new releases and features.',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textMuted),
          ),
          const Gap(12),
          TextField(
            controller: controller,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Email address',
              hintStyle: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted),
              filled: true,
              fillColor: Colors.white.withOpacity(0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: AppColors.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: AppColors.accent),
              ),
            ),
          ),
          const Gap(10),
          GradientButton(
            label: 'Subscribe',
            height: 44,
            borderRadius: 14,
            onTap: () => controller.clear(),
          ),
        ],
      ),
    );
  }
}
