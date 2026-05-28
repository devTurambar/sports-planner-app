import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../state/auth_controller.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../widgets/k_oauth_button.dart';
import '../widgets/progress_dots.dart';

class SignInStep extends StatefulWidget {
  const SignInStep({required this.onSkip, super.key});

  final VoidCallback onSkip;

  @override
  State<SignInStep> createState() => _SignInStepState();
}

class _SignInStepState extends State<SignInStep> {
  bool _advanced = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final auth = context.watch<AuthController>();

    if (auth.isSignedIn && !_advanced) {
      _advanced = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => widget.onSkip());
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, KSpace.s6),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                        LucideIcons.shieldCheck,
                        size: 26,
                        color: colors.accent,
                      ),
                    ),
                    const SizedBox(height: KSpace.s5),
                    Text(
                      loc.onboardingSignInTitle,
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
                      loc.onboardingSignInBody,
                      textAlign: TextAlign.center,
                      style: KText.bodySm.copyWith(
                        color: colors.fgSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: KSpace.s6),
                    _OptionCard(
                      icon: LucideIcons.hardDriveDownload,
                      title: loc.onboardingManualTitle,
                      description: loc.onboardingManualBody,
                      action: _ManualAction(onTap: widget.onSkip),
                    ),
                    const SizedBox(height: KSpace.s3),
                    _OptionCard(
                      icon: LucideIcons.cloud,
                      title: loc.onboardingCloudTitle,
                      description: loc.onboardingCloudBody,
                      action: _CloudActions(auth: auth),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const ProgressDots(total: 3, current: 2),
        ],
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.action,
  });

  final IconData icon;
  final String title;
  final String description;
  final Widget action;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(KSpace.s4),
      decoration: BoxDecoration(
        color: colors.bgElevated,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(KRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Icon(icon, size: 16, color: colors.fgSecondary),
              const SizedBox(width: KSpace.s2),
              Text(
                title,
                style: KText.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colors.fgPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: KSpace.s2),
          Text(
            description,
            style: KText.bodySm.copyWith(
              color: colors.fgTertiary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: KSpace.s4),
          action,
        ],
      ),
    );
  }
}

class _ManualAction extends StatelessWidget {
  const _ManualAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(KRadius.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: colors.bgSubtle,
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(KRadius.lg),
          ),
          alignment: Alignment.center,
          child: Text(
            loc.onboardingContinueWithoutAccount,
            style: KText.button.copyWith(color: colors.fgPrimary),
          ),
        ),
      ),
    );
  }
}

class _CloudActions extends StatelessWidget {
  const _CloudActions({required this.auth});

  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
      ],
    );
  }
}
