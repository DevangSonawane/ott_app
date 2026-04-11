import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../data/content_data.dart';
import '../providers/subscription_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../utils/extensions.dart';
import '../widgets/gradient_button.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(subscriptionProvider);
    final notifier = ref.read(subscriptionProvider.notifier);
    final plan =
        planFor(tier: state.selectedTier, billingCycle: state.billingCycle);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.4,
          colors: [AppColors.accent.withOpacity(0.2), Colors.transparent],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomRight,
                  radius: 1.2,
                  colors: [Colors.white.withOpacity(0.05), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    AppColors.background.withOpacity(0.9),
                    Colors.transparent
                  ],
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.of(context).padding.top + 70 + 16,
              16,
              MediaQuery.of(context).padding.bottom + 80,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _intro(context),
                const Gap(18),
                _comparisonTable(context),
                const Gap(18),
                _billingToggle(context, state, notifier),
                const Gap(14),
                Row(
                  children: [
                    Expanded(
                      child: _planCard(
                        context,
                        selected: state.selectedTier == 'super',
                        name: 'Super',
                        price:
                            planFor(tier: 'super', billingCycle: state.billingCycle)
                                .price,
                        period: _periodLabel(state.billingCycle),
                        badgeColor: AppColors.gold,
                        onTap: () async {
                          await Haptics.medium();
                          notifier.selectTier('super');
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _planCard(
                        context,
                        selected: state.selectedTier == 'premium',
                        name: 'Premium',
                        price: planFor(
                                tier: 'premium',
                                billingCycle: state.billingCycle)
                            .price,
                        period: _periodLabel(state.billingCycle),
                        badgeColor: AppColors.accent,
                        onTap: () async {
                          await Haptics.medium();
                          notifier.selectTier('premium');
                        },
                      ),
                    ),
                  ],
                ),
                const Gap(16),
                GradientButton(
                  label: 'Continue with ${plan.name}',
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _intro(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.auto_awesome,
                  color: AppColors.textPrimary, size: 16),
              const SizedBox(width: 8),
              Text(
                'theFlashx Premium',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
        const Gap(14),
        Text(
          'Subscribe and enjoy unlimited movies, shows & live sports',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
        ),
        const Gap(8),
        Text(
          'Choose the plan that suits your viewing style. Upgrade anytime.',
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _comparisonTable(BuildContext context) {
    TextStyle headerStyle(Color c) =>
        Theme.of(context).textTheme.titleMedium!.copyWith(
              color: c,
              fontWeight: FontWeight.w900,
            );

    TextStyle cellStyle({Color? c, FontWeight w = FontWeight.w600}) =>
        Theme.of(context)
            .textTheme
            .bodySmall!
            .copyWith(color: c ?? AppColors.textMuted, fontWeight: w);

    Widget yes(Color c) => Icon(Icons.check_rounded, color: c, size: 18);
    Widget no() =>
        const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 18);

    return Container(
      decoration: AppDecorations.cardDecoration.copyWith(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2.2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text('Feature', style: headerStyle(AppColors.textPrimary)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                  child: Text('Super', style: headerStyle(AppColors.gold))),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Center(
                  child: Text('Premium',
                      style: headerStyle(AppColors.textPrimary))),
            ),
          ]),
          _row(
            context,
            'All content (Movies, Live sports, TV, Specials)',
            yes(AppColors.textPrimary),
            yes(AppColors.textPrimary),
          ),
          _row(context, 'Watch on TV or Laptop', yes(AppColors.textPrimary),
              yes(AppColors.textPrimary)),
          _row(context, 'Ads free movies and shows', no(),
              yes(AppColors.textPrimary)),
          _row(
              context,
              'Number of devices',
              Text('2', style: cellStyle(c: AppColors.textPrimary)),
              Text('4', style: cellStyle(c: AppColors.textPrimary))),
          _row(
            context,
            'Max video quality',
            Text('Full HD 1080p',
                style: cellStyle(c: AppColors.textPrimary, w: FontWeight.w700)),
            Text('4K 2160p + Dolby Vision',
                style: cellStyle(c: AppColors.textPrimary, w: FontWeight.w700)),
          ),
          _row(
              context,
              'Max audio quality',
              Text('Dolby Atmos', style: cellStyle(c: AppColors.textPrimary)),
              Text('Dolby Atmos', style: cellStyle(c: AppColors.textPrimary))),
        ],
      ),
    );
  }

  TableRow _row(BuildContext context, String feature, Widget superCell,
      Widget premiumCell) {
    final style = Theme.of(context)
        .textTheme
        .bodySmall
        ?.copyWith(color: AppColors.textMuted);
    return TableRow(children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text(feature, style: style),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(child: superCell),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(child: premiumCell),
      ),
    ]);
  }

  Widget _billingToggle(BuildContext context, SubscriptionState state,
      SubscriptionNotifier notifier) {
    Widget pill(String label, String value) {
      final active = state.billingCycle == value;
      return Expanded(
        child: InkWell(
          onTap: () => notifier.selectBillingCycle(value),
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: 200.ms,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: active ? Colors.black : AppColors.textMuted,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          pill('Monthly', 'monthly'),
          pill('Quarterly', 'quarterly'),
          pill('Yearly', 'yearly'),
        ],
      ),
    );
  }

  Widget _planCard(
    BuildContext context, {
    required bool selected,
    required String name,
    required int price,
    required String period,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? Colors.white.withOpacity(0.06) : Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
              color: selected ? Colors.white : AppColors.borderSubtle),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                      ),
                ),
                const Gap(10),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w900),
                    children: [
                      TextSpan(
                          text: '₹$price',
                          style: const TextStyle(color: AppColors.textPrimary)),
                      TextSpan(
                          text: '/$period',
                          style: const TextStyle(
                              color: AppColors.textMuted,
                              fontWeight: FontWeight.w600,
                              fontSize: 14)),
                    ],
                  ),
                ),
                const Gap(10),
                Text(
                  selected ? 'Selected' : 'Tap to select',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: AppColors.textMuted),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? AppColors.accent
                      : Colors.white.withOpacity(0.06),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: selected
                    ? const Icon(Icons.check_rounded,
                        color: Colors.white, size: 16)
                    : Icon(Icons.circle_outlined, color: badgeColor, size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _periodLabel(String billingCycle) {
    switch (billingCycle) {
      case 'monthly':
        return 'month';
      case 'quarterly':
        return 'quarter';
      case 'yearly':
        return 'year';
      default:
        return 'month';
    }
  }
}
