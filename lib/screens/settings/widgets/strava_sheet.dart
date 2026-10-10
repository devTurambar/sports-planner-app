import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../../state/strava_service.dart';
import '../../../theme/kadence_colors.dart';
import '../../../theme/kadence_spacing.dart';
import '../../../theme/kadence_text_styles.dart';
import '../../../widgets/k_button.dart';

/// Strava's brand orange — required for the "Connect with Strava" button.
const stravaOrange = Color(0xFFFC4C02);

Future<void> showStravaSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: context.colors.scrim,
    builder: (_) => const StravaSheet(),
  );
}

/// Connect / sync / disconnect Strava. Watches [StravaService] so it
/// updates live when the OAuth callback lands and the import runs.
class StravaSheet extends StatelessWidget {
  const StravaSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final strava = context.watch<StravaService>();
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(KRadius.xl),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 16, 20, KSpace.s4 + bottomSafe),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(KRadius.full),
              ),
            ),
            const SizedBox(height: KSpace.s4),
            Text(
              loc.settingsStrava,
              style: KText.h3.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.fgPrimary,
              ),
            ),
            const SizedBox(height: KSpace.s2),
            Text(
              loc.stravaSheetBody,
              style: KText.bodySm.copyWith(color: colors.fgTertiary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KSpace.s4),
            _StatusLine(strava: strava),
            const SizedBox(height: KSpace.s6),
            if (!strava.isConnected)
              _ConnectButton(
                label: loc.stravaConnectButton,
                onTap: strava.isImporting ? null : strava.startAuth,
              )
            else ...[
              KButton(
                label: loc.stravaSyncNow,
                onPressed: strava.isImporting ? null : () => strava.sync(),
              ),
              const SizedBox(height: KSpace.s2),
              KButton(
                label: loc.stravaDisconnect,
                variant: KButtonVariant.ghost,
                onPressed: strava.isImporting ? null : strava.disconnect,
              ),
            ],
            const SizedBox(height: KSpace.s3),
            Text(
              loc.stravaPoweredBy,
              style: KText.caption.copyWith(
                fontSize: 11,
                color: colors.fgDisabled,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Syncing spinner, last result, or error — whichever is most recent.
class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.strava});

  final StravaService strava;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final style = KText.bodySm.copyWith(color: colors.fgSecondary);

    if (strava.isImporting) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: stravaOrange,
            ),
          ),
          const SizedBox(width: KSpace.s2),
          Text(loc.stravaSyncing, style: style),
        ],
      );
    }

    final result = strava.lastResult;
    final lines = <String>[];
    if (result != null && result.hasError) {
      lines.add(_errorText(loc, result.error!));
    } else if (result != null) {
      lines.add(loc.stravaResultAdded(result.added));
      if (result.matched > 0) lines.add(loc.stravaResultMatched(result.matched));
    }
    final last = strava.lastSync;
    if (strava.isConnected) {
      final localeName = Localizations.localeOf(context).toLanguageTag();
      lines.add(last == null
          ? loc.stravaNeverSynced
          : loc.stravaLastSync(
              DateFormat.MMMd(localeName).add_jm().format(last)));
    }

    return Column(
      children: <Widget>[
        for (final l in lines)
          Text(l, style: style, textAlign: TextAlign.center),
      ],
    );
  }

  static String _errorText(AppLocalizations loc, StravaError e) {
    switch (e) {
      case StravaError.denied:
        return loc.stravaErrorDenied;
      case StravaError.scope:
        return loc.stravaErrorScope;
      case StravaError.notSignedIn:
        return loc.stravaSignInRequired;
      case StravaError.rateLimited:
        return loc.stravaErrorRateLimited;
      case StravaError.failed:
        return loc.stravaErrorFailed;
    }
  }
}

class _ConnectButton extends StatelessWidget {
  const _ConnectButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Material(
        color: onTap == null ? context.colors.fgDisabled : stravaOrange,
        borderRadius: BorderRadius.circular(KRadius.md),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(KRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: KText.button.copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
