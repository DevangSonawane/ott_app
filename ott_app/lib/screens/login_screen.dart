import 'dart:math';

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

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  bool _obscure = true;

  @override
  void dispose() {
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
              child: Padding(
                padding: const EdgeInsets.only(top: 78),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: isTablet ? 760 : 380),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Stack(
                        children: [
                          Container(
                            decoration: AppDecorations.glassDecoration.copyWith(
                              borderRadius: BorderRadius.circular(18),
                              color: Colors.white.withOpacity(0.06),
                              boxShadow: [AppDecorations.accentGlow],
                            ),
                            padding: const EdgeInsets.all(14),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Login or sign up to continue',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(
                                          color: AppColors.textPrimary,
                                          fontWeight: FontWeight.w900,
                                        ),
                                  ),
                                  const Gap(6),
                                  Text(
                                    'Scan QR code or enter phone number to login',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppColors.textMuted),
                                  ),
                                  const Gap(12),
                                  isTablet
                                      ? Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                                child: _qrSection(context)),
                                            const SizedBox(width: 18),
                                            _orDivider(context, vertical: true),
                                            const SizedBox(width: 18),
                                            Expanded(
                                                child: _formSection(
                                                    context, auth, notifier)),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            _qrSection(context),
                                            const Gap(12),
                                            _orDivider(context,
                                                vertical: false),
                                            const Gap(12),
                                            _formSection(
                                                context, auth, notifier),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          )
                              .animate()
                              .fadeIn(duration: 220.ms)
                              .scaleXY(begin: 0.98, end: 1),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Material(
                              color: Colors.black.withOpacity(0.28),
                              shape: const CircleBorder(),
                              child: IconButton(
                                onPressed: () {
                                  final router = GoRouter.of(context);
                                  if (router.canPop()) {
                                    router.pop();
                                  } else {
                                    context.go('/');
                                  }
                                },
                                icon: const Icon(Icons.close_rounded,
                                    color: AppColors.textPrimary),
                                iconSize: 20,
                                padding: const EdgeInsets.all(10),
                                constraints: const BoxConstraints(
                                    minWidth: 40, minHeight: 40),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _qrSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 128,
          height: 128,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: CustomPaint(painter: _FakeQrPainter()),
          ),
        ),
        const Gap(10),
        Text(
          'Use Camera App to Scan QR',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
        ),
        const Gap(6),
        Text(
          'Click on the link generated to redirect to Camcine mobile app',
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _orDivider(BuildContext context, {required bool vertical}) {
    final line = Container(
        color: AppColors.borderSubtle,
        width: vertical ? 1 : double.infinity,
        height: vertical ? double.infinity : 1);
    final label = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Text('OR',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.textMuted, fontWeight: FontWeight.w800)),
    );
    if (vertical) {
      return SizedBox(
        height: 180,
        child: Stack(
          alignment: Alignment.center,
          children: [line, label],
        ),
      );
    }
    return Stack(
      alignment: Alignment.center,
      children: [line, label],
    );
  }

  Widget _formSection(
      BuildContext context, AuthState auth, AuthNotifier notifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _methodToggle(context, auth, notifier),
        const Gap(12),
        if (auth.loginMethod == 'email')
          _emailForm(context, notifier)
        else
          _phoneForm(context, auth, notifier),
        const Gap(14),
        _dividerText(context, 'OR SIGN IN WITH'),
        const Gap(10),
        OutlinedButton.icon(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.borderSubtle),
            foregroundColor: AppColors.textPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
          icon: const Icon(Icons.g_mobiledata_rounded),
          label: const Text('Continue with Google'),
        ),
        const Gap(12),
        Row(
          children: [
            Text(
              "Don't have an account? ",
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.textMuted),
            ),
            InkWell(
              onTap: () => context.push('/signup'),
              child: Text(
                'Sign Up',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
          ],
        ),
      ],
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

  Widget _emailForm(BuildContext context, AuthNotifier notifier) {
    return Column(
      children: [
        _field(
          context,
          controller: _emailController,
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
        ),
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
        const Gap(8),
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {},
            child: Text(
              'Forgot Password?',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: AppColors.accent),
            ),
          ),
        ),
        const Gap(12),
        GradientButton(
          label: 'Login with Email',
          onTap: notifier.login,
          height: 48,
          borderRadius: 14,
        ),
      ],
    );
  }

  Widget _phoneForm(
      BuildContext context, AuthState auth, AuthNotifier notifier) {
    return Column(
      children: [
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
                      if (v.isNotEmpty && i < 5) {
                        FocusScope.of(context).nextFocus();
                      }
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

  Widget _dividerText(BuildContext context, String text) {
    return Row(
      children: [
        Expanded(child: Container(height: 1, color: AppColors.borderSubtle)),
        const SizedBox(width: 10),
        Text(text,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(color: AppColors.textMuted)),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: AppColors.borderSubtle)),
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
        prefixIcon: prefix == null ? null : null,
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

class _FakeQrPainter extends CustomPainter {
  const _FakeQrPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final corner = size.shortestSide * 0.26;

    void cornerSquare(Offset origin) {
      final r = Rect.fromLTWH(origin.dx, origin.dy, corner, corner);
      canvas.drawRect(r, paint);
      canvas.drawRect(r.deflate(corner * 0.18), Paint()..color = Colors.white);
      canvas.drawRect(r.deflate(corner * 0.34), paint);
    }

    cornerSquare(Offset.zero);
    cornerSquare(Offset(size.width - corner, 0));
    cornerSquare(Offset(0, size.height - corner));

    final rng = Random(42);
    final cell = size.width / 21;
    for (var y = 0; y < 21; y++) {
      for (var x = 0; x < 21; x++) {
        final inCorner =
            (x < 7 && y < 7) || (x > 13 && y < 7) || (x < 7 && y > 13);
        if (inCorner) continue;
        if (rng.nextDouble() < 0.22) {
          canvas.drawRect(
              Rect.fromLTWH(x * cell, y * cell, cell * 0.9, cell * 0.9), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
