import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/kadence_colors.dart';
import '../theme/kadence_spacing.dart';
import '../theme/kadence_text_styles.dart';

enum OAuthProvider { google, apple }

class KOAuthButton extends StatelessWidget {
  const KOAuthButton({
    required this.provider,
    required this.onTap,
    super.key,
  });

  final OAuthProvider provider;
  final VoidCallback onTap;

  String get _label => switch (provider) {
        OAuthProvider.google => 'Continue with Google',
        OAuthProvider.apple => 'Continue with Apple',
      };

  String _assetPath(bool isDark) => switch (provider) {
        OAuthProvider.google => 'assets/icons/google.svg',
        OAuthProvider.apple =>
          isDark ? 'assets/icons/apple_dark.svg' : 'assets/icons/apple_light.svg',
      };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
              SvgPicture.asset(
                _assetPath(isDark),
                width: 18,
                height: 18,
              ),
              const SizedBox(width: KSpace.s3),
              Text(
                _label,
                style: KText.button.copyWith(color: colors.fgPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool get showApple => !kIsWeb && Platform.isIOS;
}
