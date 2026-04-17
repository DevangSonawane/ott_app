import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

import '../providers/subscription_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';

class SubscriptionScreen extends ConsumerStatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  ConsumerState<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends ConsumerState<SubscriptionScreen> {
  int? _expandedFaq;

  static const _plans = <_Plan>[
    _Plan(
      id: 'free',
      name: 'Free',
      monthlyPrice: 0,
      annualPrice: 0,
      features: [
        'SD quality',
        '1 screen',
        'Limited content',
        'Ads included',
      ],
      isPopular: false,
    ),
    _Plan(
      id: 'standard',
      name: 'Standard',
      monthlyPrice: 199,
      annualPrice: 1990,
      features: [
        'HD quality',
        '2 screens',
        'Full content library',
        'Ad-free experience',
        'Downloads',
      ],
      isPopular: false,
    ),
    _Plan(
      id: 'premium',
      name: 'Premium',
      monthlyPrice: 499,
      annualPrice: 4990,
      features: [
        '4K Ultra HD',
        '4 screens',
        'All content',
        'Ad-free experience',
        'Downloads',
        'Early access',
      ],
      isPopular: true,
    ),
  ];

  static const _faq = <_FaqItem>[
    _FaqItem(
      q: 'Can I change my plan later?',
      a: 'Yes, you can upgrade or downgrade your plan at any time. Changes will be applied to your next billing cycle.',
    ),
    _FaqItem(
      q: 'What payment methods do you accept?',
      a: 'We accept all major credit cards, debit cards, UPI, and net banking. Payment is processed securely.',
    ),
    _FaqItem(
      q: 'Can I cancel anytime?',
      a: 'Yes, you can cancel your subscription anytime. You will retain access until the end of your billing period.',
    ),
    _FaqItem(
      q: 'Is there a free trial?',
      a: 'We offer a 7-day free trial for new subscribers. No credit card required.',
    ),
    _FaqItem(
      q: 'How many devices can I watch on?',
      a: 'It depends on your plan. Free: 1 device, Standard: 2 devices, Premium: 4 devices simultaneously.',
    ),
  ];

  String _formatPrice(int price) {
    return NumberFormat.currency(
      locale: 'en-IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(price);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subscriptionProvider);
    final notifier = ref.read(subscriptionProvider.notifier);

    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 900;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.4,
          colors: [AppColors.accent.withOpacity(0.20), Colors.transparent],
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
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              16,
              MediaQuery.of(context).padding.top + 70 + 16,
              16,
              MediaQuery.of(context).padding.bottom + 80,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1020),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _header(context),
                    const Gap(24),
                    _billingToggle(context, state, notifier),
                    const Gap(18),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final p in _plans) ...[
                            Expanded(
                              child: _planCard(
                                context,
                                plan: p,
                                billingCycle: state.billingCycle,
                                selectedPlanId: state.selectedPlanId,
                                formatPrice: _formatPrice,
                                onSelect: () => notifier.selectPlan(p.id),
                              ),
                            ),
                            if (p.id != _plans.last.id) const SizedBox(width: 16),
                          ],
                        ],
                      )
                    else
                      Column(
                        children: [
                          for (final p in _plans) ...[
                            _planCard(
                              context,
                              plan: p,
                              billingCycle: state.billingCycle,
                              selectedPlanId: state.selectedPlanId,
                              formatPrice: _formatPrice,
                              onSelect: () => notifier.selectPlan(p.id),
                            ),
                            const Gap(14),
                          ],
                        ],
                      ),
                    const Gap(26),
                    _faqSection(context),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isHuge = width >= 1100;
    final titleSize = isHuge ? 48.0 : 40.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Choose Your '),
              TextSpan(
                text: 'Plan',
                style: TextStyle(
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: [AppColors.accent, AppColors.accentHover],
                    ).createShader(const Rect.fromLTWH(0, 0, 220, 60)),
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontSize: titleSize,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
        ),
        const Gap(10),
        Text(
          'Stream unlimited movies, shows, live news, and songs. Cancel anytime.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
        ),
      ],
    );
  }

  Widget _billingToggle(
    BuildContext context,
    SubscriptionState state,
    SubscriptionNotifier notifier,
  ) {
    Widget pill({
      required String label,
      required String value,
      Widget? trailing,
    }) {
      final active = state.billingCycle == value;
      return InkWell(
        onTap: () => notifier.selectBillingCycle(value),
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: 220.ms,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: active
                ? const LinearGradient(
                    colors: [AppColors.accent, AppColors.accentHover],
                  )
                : null,
            color: active ? null : Colors.transparent,
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.28),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: active ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing,
              ],
            ],
          ),
        ),
      );
    }

    return Align(
      alignment: Alignment.center,
      child: Container(
        decoration: AppDecorations.glassDecoration.copyWith(
          borderRadius: BorderRadius.circular(999),
        ),
        padding: const EdgeInsets.all(6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 132,
              child: pill(label: 'Monthly', value: 'monthly'),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 172,
              child: pill(
                label: 'Annual',
                value: 'annual',
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Save 20%',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _planCard(
    BuildContext context, {
    required _Plan plan,
    required String billingCycle,
    required String selectedPlanId,
    required String Function(int price) formatPrice,
    required VoidCallback onSelect,
  }) {
    final price = billingCycle == 'monthly' ? plan.monthlyPrice : plan.annualPrice;
    final isSelected = selectedPlanId == plan.id;
    final isPopular = plan.isPopular;

    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(28),
      child: AnimatedContainer(
        duration: 280.ms,
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
        decoration: AppDecorations.glassDecoration.copyWith(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: isPopular
                ? AppColors.accent
                : (isSelected ? Colors.white.withOpacity(0.35) : AppColors.border),
            width: isPopular ? 1.4 : 1,
          ),
          boxShadow: [
            if (isPopular)
              BoxShadow(
                color: AppColors.accent.withOpacity(0.25),
                blurRadius: 34,
                offset: const Offset(0, 18),
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isPopular) ...[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.accent, AppColors.accentHover],
                    ),
                    borderRadius: BorderRadius.circular(999),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withOpacity(0.35),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome_rounded,
                          size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        'Most Popular',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(12),
            ],
            Text(
              plan.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const Gap(14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatPrice(price),
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        height: 0.95,
                      ),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '/mo',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
            const Gap(18),
            for (final f in plan.features) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded,
                        size: 14, color: AppColors.accent),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      f,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.3,
                          ),
                    ),
                  ),
                ],
              ),
              const Gap(10),
            ],
            const Gap(8),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: isSelected ? AppColors.accent : AppColors.borderStrong,
                    width: 1.2,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  foregroundColor:
                      isSelected ? AppColors.accent : Colors.white,
                ),
                child: Text(
                  isSelected ? 'Current Plan' : (plan.id == 'free' ? 'Get Started' : 'Subscribe'),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _faqSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Frequently Asked Questions',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
        ),
        const Gap(14),
        for (var i = 0; i < _faq.length; i++) ...[
          _faqItem(context, index: i, item: _faq[i]),
          const Gap(10),
        ],
      ],
    );
  }

  Widget _faqItem(BuildContext context, {required int index, required _FaqItem item}) {
    final expanded = _expandedFaq == index;
    return Container(
      decoration: AppDecorations.glassDecoration.copyWith(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: () => setState(() => _expandedFaq = expanded ? null : index),
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      item.q,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedRotation(
                    duration: 220.ms,
                    turns: expanded ? 0.5 : 0,
                    child: Icon(
                      Icons.expand_more_rounded,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
              if (expanded) ...[
                const Gap(10),
                Text(
                  item.a,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Plan {
  const _Plan({
    required this.id,
    required this.name,
    required this.monthlyPrice,
    required this.annualPrice,
    required this.features,
    required this.isPopular,
  });

  final String id;
  final String name;
  final int monthlyPrice;
  final int annualPrice;
  final List<String> features;
  final bool isPopular;
}

class _FaqItem {
  const _FaqItem({required this.q, required this.a});
  final String q;
  final String a;
}
