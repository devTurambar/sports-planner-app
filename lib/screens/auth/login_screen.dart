import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../state/auth_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../widgets/k_oauth_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final auth = context.read<AuthController>();
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
              KOAuthButton(
                provider: OAuthProvider.google,
                onTap: () => auth.signInWithGoogle(),
              ),
              if (KOAuthButton.showApple) ...[
                const SizedBox(height: KSpace.s3),
                KOAuthButton(
                  provider: OAuthProvider.apple,
                  onTap: () => auth.signInWithApple(),
                ),
              ],
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
