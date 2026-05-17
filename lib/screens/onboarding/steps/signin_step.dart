import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../state/auth_controller.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../widgets/k_button.dart';
import '../widgets/progress_dots.dart';

/// Optional sign-in step shown after the week preview. The user can
/// sign in with Google/Apple or skip to use the app offline-only.
class SignInStep extends StatelessWidget {
  const SignInStep({required this.onSkip, super.key});

  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final auth = context.read<AuthController>();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, KSpace.s8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: colors.accentLight,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    LucideIcons.cloudUpload,
                    size: 26,
                    color: colors.accent,
                  ),
                ),
                const SizedBox(height: KSpace.s5),
                Text(
                  'Back up your data',
                  textAlign: TextAlign.center,
                  style: KText.h2.copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: colors.fgPrimary,
                    letterSpacing: -0.44,
                  ),
                ),
                const SizedBox(height: KSpace.s1 + 2),
                Text(
                  'Sign in to sync your sessions across devices. '
                  'You can always do this later in Settings.',
                  textAlign: TextAlign.center,
                  style: KText.bodySm.copyWith(
                    color: colors.fgSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: KSpace.s8),
                _OAuthButton(
                  label: 'Continue with Google',
                  icon: LucideIcons.globe,
                  onTap: () => auth.signInWithGoogle(),
                ),
                const SizedBox(height: KSpace.s3),
                _OAuthButton(
                  label: 'Continue with Apple',
                  icon: LucideIcons.apple,
                  onTap: () => auth.signInWithApple(),
                ),
              ],
            ),
          ),
          const ProgressDots(total: 6, current: 5),
          const SizedBox(height: KSpace.s1 + 2),
          KButton(
            label: 'Skip for now',
            variant: KButtonVariant.ghost,
            onPressed: onSkip,
          ),
        ],
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
          padding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: KSpace.s4,
          ),
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
