import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../state/auth_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Scaffold(
      backgroundColor: colors.bgBase,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: KSpace.pageGutter),
          child: Column(
            children: [
              const Spacer(flex: 3),
              Icon(
                LucideIcons.activity,
                size: 48,
                color: colors.accent,
              ),
              const SizedBox(height: KSpace.s4),
              Text(
                'Kadence',
                style: KText.h1.copyWith(color: colors.fgPrimary),
              ),
              const SizedBox(height: KSpace.s2),
              Text(
                'Plan your week. Move your body.',
                style: KText.body.copyWith(color: colors.fgTertiary),
              ),
              const Spacer(flex: 2),
              _OAuthButton(
                label: 'Continue with Google',
                icon: LucideIcons.globe,
                onTap: () => context.read<AuthController>().signInWithGoogle(),
              ),
              const SizedBox(height: KSpace.s3),
              _OAuthButton(
                label: 'Continue with Apple',
                icon: LucideIcons.apple,
                onTap: () => context.read<AuthController>().signInWithApple(),
              ),
              const Spacer(flex: 1),
              Text(
                'By continuing you agree to our Terms of Service',
                style: KText.caption.copyWith(color: colors.fgDisabled),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: KSpace.s6),
            ],
          ),
        ),
      ),
    );
  }
}

class _OAuthButton extends StatelessWidget {
  const _OAuthButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KRadius.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: KSpace.s4),
          decoration: BoxDecoration(
            color: colors.bgElevated,
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(KRadius.lg),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: colors.fgPrimary),
              const SizedBox(width: KSpace.s3),
              Text(
                label,
                style: KText.button.copyWith(color: colors.fgPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
