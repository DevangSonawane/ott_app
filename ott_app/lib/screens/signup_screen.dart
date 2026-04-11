import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../providers/auth_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_decorations.dart';
import '../utils/constants.dart';
import '../widgets/gradient_button.dart';
import '../widgets/top_nav_bar.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final notifier = ref.read(authProvider.notifier);
    final isTablet =
        MediaQuery.of(context).size.width >= AppBreakpoints.tabletMin;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned.fill(
            child: SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isTablet ? 720 : 520),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      children: [
                        Container(
                          decoration: AppDecorations.glassDecoration.copyWith(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.white.withOpacity(0.06),
                            boxShadow: [AppDecorations.accentGlow],
                          ),
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sign up or login to continue',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge
                                    ?.copyWith(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w900,
                                    ),
                              ),
                              const Gap(16),
                              _methodToggle(context, auth, notifier),
                              const Gap(12),
                              if (auth.loginMethod == 'email')
                                _emailSignupForm(context, notifier)
                              else
                                _phoneSignupForm(context, auth, notifier),
                              const Gap(12),
                              Row(
                                children: [
                                  Text(
                                    'Already have an account? ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppColors.textMuted),
                                  ),
                                  InkWell(
                                    onTap: () => context.push('/login'),
                                    child: Text(
                                      'Login',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: AppColors.accent,
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: 6,
                          top: 6,
                          child: IconButton(
                            onPressed: () => context.pop(),
                            icon: const Icon(Icons.close_rounded,
                                color: AppColors.textPrimary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const Positioned(top: 0, left: 0, right: 0, child: TopNavBar()),
        ],
      ),
    );
  }

  Widget _methodToggle(
      BuildContext context, AuthState auth, AuthNotifier notifier) {
    Widget pill(String label, String value) {
      final active = auth.loginMethod == value;
      return Expanded(
        child: InkWell(
          onTap: () => notifier.setLoginMethod(value),
          borderRadius: BorderRadius.circular(999),
          child: AnimatedContainer(
            duration: 200.ms,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: active ? Colors.black : AppColors.textMuted,
                      fontWeight: FontWeight.w800,
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
          pill('Email', 'email'),
          const SizedBox(width: 6),
          pill('Phone', 'phone'),
        ],
      ),
    );
  }

  Widget _emailSignupForm(BuildContext context, AuthNotifier notifier) {
    return Column(
      children: [
        _field(context, controller: _nameController, label: 'Name'),
        const Gap(10),
        _field(context,
            controller: _emailController,
            label: 'Email',
            keyboardType: TextInputType.emailAddress),
        const Gap(10),
        _field(
          context,
          controller: _passwordController,
          label: 'Password',
          obscureText: _obscure,
          suffix: IconButton(
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(
                _obscure
                    ? Icons.visibility_rounded
                    : Icons.visibility_off_rounded,
                color: AppColors.textMuted),
          ),
        ),
        const Gap(12),
        GradientButton(
          label: 'Create Account',
          onTap: notifier.login,
          height: 48,
          borderRadius: 14,
        ),
      ],
    );
  }

  Widget _phoneSignupForm(
      BuildContext context, AuthState auth, AuthNotifier notifier) {
    return Column(
      children: [
        _field(context, controller: _nameController, label: 'Name'),
        const Gap(10),
        _field(
          context,
          controller: _phoneController,
          label: 'Phone number',
          keyboardType: TextInputType.phone,
          prefix: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text('+91',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: AppColors.textPrimary)),
          ),
        ),
        const Gap(12),
        GradientButton(
          label: 'Send OTP',
          onTap: notifier.sendOtp,
          height: 48,
          borderRadius: 14,
        ),
        if (auth.showOtp) ...[
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < 6; i++)
                SizedBox(
                  width: 46,
                  child: TextField(
                    controller: _otpControllers[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: AppColors.textPrimary),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.06),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.borderSubtle),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: AppColors.accent, width: 1.2),
                      ),
                    ),
                    onChanged: (v) {
                      if (v.isNotEmpty && i < 5)
                        FocusScope.of(context).nextFocus();
                    },
                  ),
                ),
            ],
          ),
          const Gap(12),
          GradientButton(
            label: 'Verify OTP',
            onTap: notifier.login,
            height: 48,
            borderRadius: 14,
          ),
        ],
      ],
    );
  }

  Widget _field(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    bool obscureText = false,
    Widget? prefix,
    Widget? suffix,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: Theme.of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(color: AppColors.textMuted),
        filled: true,
        fillColor: Colors.white.withOpacity(0.06),
        prefix: prefix,
        suffixIcon: suffix,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.2),
        ),
      ),
    );
  }
}
