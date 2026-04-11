import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../widgets/gradient_button.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _newReleases = false;
  bool _twoFactor = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top + 70 + 16;
    final bottomPadding = MediaQuery.of(context).padding.bottom + 80;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, topPadding, 16, bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Settings',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const Gap(14),
          _card(
            context,
            icon: Icons.person_outline_rounded,
            title: 'Account Overview',
            child: _overviewGrid(context),
            footer: Row(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderSubtle),
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: const Text('Edit Profile'),
                ),
              ],
            ),
          ),
          const Gap(14),
          _card(
            context,
            icon: Icons.calendar_today_outlined,
            title: 'Subscription',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _pill('3 Months', AppColors.gold),
                    const SizedBox(width: 10),
                    _statusPill('Active'),
                  ],
                ),
                const Gap(12),
                _infoRow(context, 'Last payment', '02 Apr 2026'),
                _infoRow(context, 'Next billing', '02 Jul 2026'),
                const Gap(12),
                Row(
                  children: [
                    Expanded(
                      child: GradientButton(
                        label: 'Upgrade Plan',
                        height: 46,
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.redAccent),
                          foregroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text('Cancel Subscription'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Gap(14),
          _card(
            context,
            icon: Icons.credit_card_rounded,
            title: 'Payment Method',
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.white.withOpacity(0.06),
                    border: Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card_rounded,
                          color: AppColors.textPrimary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Visa •••• 4242',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(12),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderSubtle),
                    foregroundColor: AppColors.textPrimary,
                  ),
                  child: const Text('Change Payment Method'),
                ),
              ],
            ),
          ),
          const Gap(14),
          _card(
            context,
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            child: Column(
              children: [
                SwitchListTile(
                  value: _emailNotifications,
                  onChanged: (v) => setState(() => _emailNotifications = v),
                  title: const Text('Email Notifications'),
                  activeColor: AppColors.accent,
                ),
                SwitchListTile(
                  value: _pushNotifications,
                  onChanged: (v) => setState(() => _pushNotifications = v),
                  title: const Text('Push Notifications'),
                  activeColor: AppColors.accent,
                ),
                SwitchListTile(
                  value: _newReleases,
                  onChanged: (v) => setState(() => _newReleases = v),
                  title: const Text('New Releases'),
                  activeColor: AppColors.accent,
                ),
              ],
            ),
          ),
          const Gap(14),
          _card(
            context,
            icon: Icons.language_rounded,
            title: 'Language & Region',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<String>(
                  value: _language,
                  dropdownColor: AppColors.cardElevated,
                  decoration: InputDecoration(
                    labelText: 'Language',
                    labelStyle: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: AppColors.textMuted),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(color: AppColors.borderSubtle),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppColors.accent),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'English', child: Text('English')),
                    DropdownMenuItem(value: 'Hindi', child: Text('Hindi')),
                    DropdownMenuItem(value: 'Tamil', child: Text('Tamil')),
                    DropdownMenuItem(value: 'Telugu', child: Text('Telugu')),
                    DropdownMenuItem(value: 'Kannada', child: Text('Kannada')),
                  ],
                  onChanged: (v) => setState(() => _language = v ?? 'English'),
                ),
                const Gap(12),
                _infoRow(context, 'Region',
                    Localizations.localeOf(context).countryCode ?? 'IN'),
              ],
            ),
          ),
          const Gap(14),
          _card(
            context,
            icon: Icons.shield_outlined,
            title: 'Security',
            child: Column(
              children: [
                ListTile(
                  onTap: () {},
                  title: const Text('Change Password'),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textMuted),
                ),
                SwitchListTile(
                  value: _twoFactor,
                  onChanged: (v) => setState(() => _twoFactor = v),
                  title: const Text('Two-Factor Authentication'),
                  activeColor: AppColors.accent,
                ),
                ListTile(
                  onTap: () {},
                  title: const Text('Active Sessions'),
                  trailing: const Icon(Icons.chevron_right_rounded,
                      color: AppColors.textMuted),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
    Widget? footer,
  }) {
    return Container(
      decoration: AppDecorations.cardDecoration.copyWith(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.accent),
              const SizedBox(width: 10),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                    ),
              ),
            ],
          ),
          const Gap(12),
          DefaultTextStyle.merge(
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.textPrimary),
            child: child,
          ),
          if (footer != null) ...[
            const Gap(12),
            footer,
          ],
        ],
      ),
    );
  }

  Widget _overviewGrid(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.25,
      children: const [
        _OverviewCell(label: 'Full Name', value: 'Alex Johnson'),
        _OverviewCell(label: 'Username', value: 'alexj'),
        _OverviewCell(label: 'Account Status', value: 'Active'),
        _OverviewCell(label: 'Email', value: 'alex.johnson@example.com'),
        _OverviewCell(label: 'Phone', value: '+91 98765 43210'),
        _OverviewCell(
            label: 'Billing Address',
            value: '12, MG Road, Bengaluru, KA 560001'),
      ],
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted)),
        ),
        Text(value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _pill(String text, Color c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Text(text,
          style:
              TextStyle(color: c, fontWeight: FontWeight.w900, fontSize: 12)),
    );
  }

  Widget _statusPill(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Text(text,
          style: const TextStyle(
              color: AppColors.success,
              fontWeight: FontWeight.w900,
              fontSize: 12)),
    );
  }
}

class _OverviewCell extends StatelessWidget {
  const _OverviewCell({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: AppColors.textMuted),
          ),
          const Gap(6),
          Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
