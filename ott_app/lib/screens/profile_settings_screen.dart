import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../widgets/gradient_button.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final _name = TextEditingController(text: 'Alex');
  String _maturity = 'All';
  bool _autoplay = true;
  String _language = 'English';

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back_rounded,
                        color: AppColors.textPrimary),
                  ),
                  Text(
                    'Profile Settings',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ],
              ),
              const Gap(14),
              Container(
                decoration: AppDecorations.cardDecoration.copyWith(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white.withOpacity(0.06),
                            border: Border.all(color: AppColors.borderSubtle),
                          ),
                          child: const Icon(Icons.person_rounded,
                              color: AppColors.textMuted, size: 54),
                        ),
                        Positioned(
                          right: 6,
                          bottom: 6,
                          child: Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.55),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.borderSubtle),
                            ),
                            child: const Icon(Icons.edit_rounded,
                                color: AppColors.textPrimary, size: 18),
                          ),
                        ),
                      ],
                    ),
                    const Gap(14),
                    TextField(
                      controller: _name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: AppColors.textMuted),
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.06),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: AppColors.borderSubtle),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                              color: AppColors.accent, width: 1.2),
                        ),
                      ),
                    ),
                    const Gap(12),
                    DropdownButtonFormField<String>(
                      value: _maturity,
                      dropdownColor: AppColors.cardElevated,
                      decoration: InputDecoration(
                        labelText: 'Maturity Rating',
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
                          borderSide: const BorderSide(
                              color: AppColors.accent, width: 1.2),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'All', child: Text('All')),
                        DropdownMenuItem(value: '13+', child: Text('13+')),
                        DropdownMenuItem(value: '18+', child: Text('18+')),
                      ],
                      onChanged: (v) => setState(() => _maturity = v ?? 'All'),
                    ),
                    const Gap(12),
                    SwitchListTile(
                      value: _autoplay,
                      onChanged: (v) => setState(() => _autoplay = v),
                      title: const Text('Autoplay'),
                      activeColor: AppColors.accent,
                    ),
                    const Gap(6),
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
                          borderSide: const BorderSide(
                              color: AppColors.accent, width: 1.2),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'English', child: Text('English')),
                        DropdownMenuItem(value: 'Hindi', child: Text('Hindi')),
                        DropdownMenuItem(value: 'Tamil', child: Text('Tamil')),
                        DropdownMenuItem(
                            value: 'Telugu', child: Text('Telugu')),
                        DropdownMenuItem(
                            value: 'Kannada', child: Text('Kannada')),
                      ],
                      onChanged: (v) =>
                          setState(() => _language = v ?? 'English'),
                    ),
                    const Gap(12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: AppColors.cardElevated,
                              title: const Text('Delete Profile'),
                              content:
                                  const Text('This action cannot be undone.'),
                              actions: [
                                TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel')),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: TextButton.styleFrom(
                                      foregroundColor: Colors.redAccent),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );
                          if (ok == true && context.mounted) context.pop();
                        },
                        style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent),
                        child: const Text('Delete Profile'),
                      ),
                    ),
                    const Gap(8),
                    GradientButton(label: 'Save', onTap: () => context.pop()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
