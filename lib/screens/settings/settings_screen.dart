import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../models/activity.dart';
import '../../state/auth_controller.dart';
import '../../state/backup_service.dart';
import '../../state/calendar_service.dart';
import '../../state/locale_controller.dart';
import '../../state/onboarding_controller.dart';
import '../../state/plan_controller.dart';
import '../../state/pro_controller.dart';
import '../../state/sync_service.dart';
import '../../state/theme_controller.dart';
import '../../state/type_color_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../widgets/k_oauth_button.dart';
import '../../widgets/k_type_tile.dart';
import '../../state/activity_db.dart';
import '../../state/goal_controller.dart';
import '../paywall/paywall_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _calendarSync = CalendarService.syncEnabled;
  Set<String> _selectedIds = CalendarService.selectedCalendarIds;
  List<Calendar> _calendars = const [];
  bool _loadingCalendars = false;

  @override
  void initState() {
    super.initState();
    if (_calendarSync) _loadCalendars();
  }

  Future<void> _loadCalendars() async {
    setState(() => _loadingCalendars = true);
    final calendars = await CalendarService.getWritableCalendars();
    if (!mounted) return;
    setState(() {
      _calendars = calendars;
      _loadingCalendars = false;
    });
  }

  Future<void> _toggleCalendarSync(bool value) async {
    if (value) {
      final granted = await CalendarService.requestPermission();
      if (!granted) return;
      await CalendarService.setSyncEnabled(true);
      setState(() => _calendarSync = true);
      await _loadCalendars();
    } else {
      await CalendarService.setSyncEnabled(false);
      await CalendarService.setSelectedCalendarIds({});
      setState(() {
        _calendarSync = false;
        _selectedIds = {};
        _calendars = const [];
      });
    }
  }

  Future<void> _pickCalendars() async {
    if (_calendars.isEmpty) return;
    final colors = context.colors;
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: colors.scrim,
      builder: (ctx) => _CalendarPicker(
        calendars: _calendars,
        selectedIds: _selectedIds,
      ),
    );
    if (result != null && mounted) {
      await CalendarService.setSelectedCalendarIds(result);
      setState(() => _selectedIds = result);
    }
  }

  String _calendarLabel(AppLocalizations loc) {
    if (!_calendarSync) return loc.calendarsOff;
    if (_loadingCalendars) return loc.calendarsLoading;
    if (_selectedIds.isEmpty) return loc.calendarsAll;
    if (_selectedIds.length == 1) {
      final match = _calendars.where((c) => c.id == _selectedIds.first);
      if (match.isNotEmpty) return match.first.name ?? loc.calendarsFallback;
    }
    return loc.calendarsCount(_selectedIds.length);
  }

  Future<void> _exportData() async {
    final plan = context.read<PlanController>();
    final loc = AppLocalizations.of(context)!;
    try {
      await BackupService.exportData(plan.byDate);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.exportFailed)),
      );
    }
  }

  Future<void> _importData() async {
    final activities = await BackupService.pickAndParse();
    if (activities == null || !mounted) return;

    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.bgElevated,
        title: Text(
          loc.importReplaceTitle,
          style: KText.h3.copyWith(color: colors.fgPrimary),
        ),
        content: Text(
          loc.importReplaceBody(activities.length),
          style: KText.body.copyWith(color: colors.fgSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              loc.actionCancel,
              style: KText.button.copyWith(color: colors.fgTertiary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              loc.actionReplace,
              style: KText.button.copyWith(color: const Color(0xFFB5443A)),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final plan = context.read<PlanController>();
    final auth = context.read<AuthController>();
    final fresh = BackupService.reassignIds(activities);
    final grouped = BackupService.groupByDate(fresh);

    await ActivityDb.deleteAll();
    for (final list in grouped.values) {
      await ActivityDb.upsertAll(list);
    }
    plan.replaceAll(grouped);

    if (auth.isSignedIn && plan.userId != null) {
      await SyncService.replaceAllCloud(grouped, plan.userId!);
    } else {
      final prefs = await SharedPreferences.getInstance();
      await SyncService.clearOwner(prefs);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(loc.importedActivities(activities.length))),
    );

    if (CalendarService.syncEnabled) {
      await _offerCalendarSync(fresh, plan);
    }
  }

  Future<void> _offerCalendarSync(
    List<Activity> activities,
    PlanController plan,
  ) async {
    if (!mounted) return;
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final syncToCalendar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.bgElevated,
        title: Text(
          loc.calendarSyncPromptTitle,
          style: KText.h3.copyWith(color: colors.fgPrimary),
        ),
        content: Text(
          loc.calendarSyncPromptBody,
          style: KText.body.copyWith(color: colors.fgSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              loc.actionNoThanks,
              style: KText.button.copyWith(color: colors.fgTertiary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              loc.actionSync,
              style: KText.button.copyWith(color: colors.fgPrimary),
            ),
          ),
        ],
      ),
    );

    if (syncToCalendar != true || !mounted) return;

    final eventIds = await CalendarService.syncImportedBatch(activities);
    plan.patchCalendarEventIds(eventIds);

    if (!mounted) return;
    final synced = eventIds.length;
    final skipped = activities.length - synced;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          skipped > 0
              ? loc.calendarSyncedWithSkipped(synced, skipped)
              : loc.calendarSyncedAll(synced),
        ),
      ),
    );
  }

  void _showGoalPicker(BuildContext context) {
    final colors = context.colors;
    final goalCtrl = context.read<GoalController>();
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: colors.scrim,
      builder: (_) => _GoalPickerSheet(
        current: goalCtrl.goal,
        onSelected: (value) {
          goalCtrl.setGoal(value);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _showTypeColorPicker(BuildContext context) {
    final colors = context.colors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: colors.scrim,
      isScrollControlled: true,
      builder: (_) => const _TypeColorPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = context.watch<ThemeController>();
    final onboarding = context.watch<OnboardingController>();
    final auth = context.watch<AuthController>();
    final goalCtrl = context.watch<GoalController>();
    final localeCtrl = context.watch<LocaleController>();
    final pro = context.watch<ProController>();
    final loc = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KSpace.s4,
        KSpace.s2,
        KSpace.s4,
        KSpace.s16,
      ),
      children: <Widget>[
        _AccountCard(auth: auth, isPro: pro.isPro),
        const SizedBox(height: KSpace.s3),
        _ProCard(onTap: () => PaywallScreen.show(context)),

        // ── App ───────────────────────────────────────────
        _SectionHeader(label: loc.settingsSectionApp),
        _Group(
          rows: <Widget>[
            _ToggleRow(
              icon: LucideIcons.moon,
              iconBg: const Color(0xFF5856D6),
              label: loc.settingsDarkMode,
              value: theme.isDark,
              onChanged: (_) => theme.toggleDark(),
            ),
            _StaticRow(
              icon: LucideIcons.calendarDays,
              iconBg: const Color(0xFFFF9500),
              label: loc.settingsWeekStartsOn,
              value: theme.weekStartsOnSunday
                  ? loc.weekdaySunday
                  : loc.weekdayMonday,
              onTap: () => theme.toggleWeekStart(),
            ),
            _StaticRow(
              icon: LucideIcons.languages,
              iconBg: const Color(0xFF0A84FF),
              label: loc.settingsLanguage,
              value: _languageLabel(loc, localeCtrl),
              onTap: () => _showLanguagePicker(context),
            ),
            _StaticRow(
              icon: LucideIcons.target,
              iconBg: const Color(0xFFFF3B30),
              label: loc.settingsWeeklyGoal,
              value: goalCtrl.hasGoal
                  ? loc.weeklyGoalSessions(goalCtrl.goal!)
                  : loc.weeklyGoalOff,
              onTap: () => _showGoalPicker(context),
            ),
            _AccentColorRow(
              label: loc.settingsThemeColor,
              icon: LucideIcons.palette,
              iconBg: const Color(0xFFFF2D55),
              proBadge: !pro.isPro,
              isPro: pro.isPro,
            ),
            _ToggleRow(
              icon: LucideIcons.calendarSync,
              iconBg: const Color(0xFF34C759),
              label: loc.settingsCalendarSync,
              value: _calendarSync,
              onChanged: _toggleCalendarSync,
            ),
            if (_calendarSync)
              _StaticRow(
                icon: LucideIcons.calendarCheck,
                iconBg: const Color(0xFF30B0C7),
                label: loc.settingsCalendars,
                value: _calendarLabel(loc),
                onTap: _pickCalendars,
              ),
            _StaticRow(
              icon: LucideIcons.paintbrush,
              iconBg: const Color(0xFFAF52DE),
              label: loc.settingsTypeColors,
              value: loc.settingsTypeColorsValue,
              onTap: pro.isPro
                  ? () => _showTypeColorPicker(context)
                  : () => PaywallScreen.show(context),
              isLast: true,
              proBadge: !pro.isPro,
            ),
          ],
        ),

        // ── Data ──────────────────────────────────────────
        _SectionHeader(label: loc.settingsSectionData),
        _Group(
          rows: <Widget>[
            _StaticRow(
              icon: LucideIcons.upload,
              iconBg: const Color(0xFF007AFF),
              label: loc.settingsExportData,
              value: loc.settingsExportValue,
              onTap: _exportData,
            ),
            _StaticRow(
              icon: LucideIcons.download,
              iconBg: const Color(0xFF5856D6),
              label: loc.settingsImportData,
              value: loc.settingsImportValue,
              onTap: _importData,
              isLast: true,
            ),
          ],
        ),

        // ── About ─────────────────────────────────────────
        _SectionHeader(label: loc.settingsSectionAbout),
        _Group(
          rows: <Widget>[
            _StaticRow(
              icon: LucideIcons.refreshCw,
              iconBg: const Color(0xFFFF9500),
              label: loc.settingsRedoOnboarding,
              value: '',
              onTap: () async {
                await onboarding.reset();
              },
            ),
            _StaticRow(
              icon: LucideIcons.shieldCheck,
              iconBg: const Color(0xFF34C759),
              label: loc.settingsPrivacyPolicy,
              value: '',
              onTap: () {},
            ),
            _StaticRow(
              icon: LucideIcons.star,
              iconBg: const Color(0xFFFFCC00),
              label: loc.settingsRateKadence,
              value: '',
              onTap: () => InAppReview.instance.openStoreListing(),
              isLast: true,
            ),
          ],
        ),
        const SizedBox(height: KSpace.s4),
        Text(
          loc.settingsVersion('1.0'),
          textAlign: TextAlign.center,
          style: KText.caption.copyWith(
            fontSize: 11,
            color: colors.fgDisabled,
          ),
        ),
      ],
    );
  }

  String _languageLabel(AppLocalizations loc, LocaleController ctrl) {
    final current = ctrl.locale;
    if (current == null) return loc.languageSystem;
    switch (current.languageCode) {
      case 'en':
        return loc.languageEnglish;
      case 'pt':
        return current.countryCode == 'BR'
            ? loc.languagePortugueseBR
            : loc.languagePortuguese;
      case 'es':
        return loc.languageSpanish;
      case 'fr':
        return loc.languageFrench;
      default:
        return loc.languageSystem;
    }
  }

  void _showLanguagePicker(BuildContext context) {
    final colors = context.colors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: colors.scrim,
      builder: (_) => const _LanguagePickerSheet(),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.rows});

  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgElevated,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(KRadius.lg),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: rows,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(
        left: KSpace.s1,
        top: KSpace.s5,
        bottom: KSpace.s2,
      ),
      child: Text(
        label,
        style: KText.caption.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: colors.fgTertiary,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _RowIcon extends StatelessWidget {
  const _RowIcon({required this.icon, required this.bg});

  final IconData icon;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Icon(icon, size: 16, color: Colors.white),
    );
  }
}

class _ProBadge extends StatelessWidget {
  const _ProBadge();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(left: 6),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
      decoration: BoxDecoration(
        color: colors.accent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(KRadius.full),
      ),
      child: Text(
        loc.proBadge,
        style: KText.caption.copyWith(
          fontSize: 9,
          fontWeight: FontWeight.w700,
          color: colors.accent,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
    this.icon,
    this.iconBg,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData? icon;
  final Color? iconBg;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: colors.borderSubtle, width: 1),
        ),
      ),
      padding:
          const EdgeInsets.symmetric(horizontal: KSpace.s4, vertical: 13),
      child: Row(
        children: <Widget>[
          if (icon != null) ...[
            _RowIcon(icon: icon!, bg: iconBg ?? colors.fgTertiary),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: KText.body.copyWith(color: colors.fgPrimary),
            ),
          ),
          _Toggle(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _StaticRow extends StatelessWidget {
  const _StaticRow({
    required this.label,
    required this.value,
    required this.onTap,
    this.isLast = false,
    this.icon,
    this.iconBg,
    this.proBadge = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isLast;
  final IconData? icon;
  final Color? iconBg;
  final bool proBadge;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            border: isLast
                ? null
                : Border(
                    bottom:
                        BorderSide(color: colors.borderSubtle, width: 1),
                  ),
          ),
          padding: const EdgeInsets.symmetric(
              horizontal: KSpace.s4, vertical: 13),
          child: Row(
            children: <Widget>[
              if (icon != null) ...[
                _RowIcon(icon: icon!, bg: iconBg ?? colors.fgTertiary),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Row(
                  children: [
                    Text(
                      label,
                      style: KText.body.copyWith(color: colors.fgPrimary),
                    ),
                    if (proBadge) const _ProBadge(),
                  ],
                ),
              ),
              Text(
                value,
                style:
                    KText.bodySm.copyWith(color: colors.fgTertiary, fontSize: 14),
              ),
              const SizedBox(width: 4),
              Icon(
                LucideIcons.chevronRight,
                size: 14,
                color: colors.fgTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CalendarPicker extends StatefulWidget {
  const _CalendarPicker({
    required this.calendars,
    required this.selectedIds,
  });

  final List<Calendar> calendars;
  final Set<String> selectedIds;

  @override
  State<_CalendarPicker> createState() => _CalendarPickerState();
}

class _CalendarPickerState extends State<_CalendarPicker> {
  late Set<String> _selected = Set<String>.from(widget.selectedIds);

  bool get _isAll => _selected.isEmpty;

  void _toggleAll() {
    setState(() => _selected = {});
  }

  void _toggle(String id) {
    setState(() {
      if (_selected.contains(id)) {
        _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(KRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(KRadius.full),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.calendarsChooseTitle,
                    style: KText.h3.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: colors.fgPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(_selected),
                  child: Text(
                    AppLocalizations.of(context)!.actionDone,
                    style: KText.bodySm.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.accent,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.borderSubtle),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: KSpace.s4 + bottomSafe),
              itemCount: widget.calendars.length + 1,
              itemBuilder: (ctx, i) {
                final loc = AppLocalizations.of(ctx)!;
                if (i == 0) {
                  return _CalendarRow(
                    label: loc.calendarsAll,
                    icon: LucideIcons.layers,
                    isChecked: _isAll,
                    onTap: _toggleAll,
                  );
                }
                final cal = widget.calendars[i - 1];
                final id = cal.id ?? '';
                return _CalendarRow(
                  label: cal.name ?? loc.calendarsFallback,
                  subtitle: cal.accountName,
                  color: Color(cal.color ?? 0xFF4A7C59),
                  isChecked: _isAll || _selected.contains(id),
                  onTap: () => _toggle(id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarRow extends StatelessWidget {
  const _CalendarRow({
    required this.label,
    required this.isChecked,
    required this.onTap,
    this.subtitle,
    this.icon,
    this.color,
  });

  final String label;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final bool isChecked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: <Widget>[
              if (icon != null)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(icon, size: 14, color: colors.fgSecondary),
                ),
              if (color != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      style: KText.body.copyWith(
                        color: colors.fgPrimary,
                        fontWeight:
                            isChecked ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Text(
                        subtitle!,
                        style: KText.caption.copyWith(
                          fontSize: 11,
                          color: colors.fgTertiary,
                        ),
                      ),
                  ],
                ),
              ),
              _Checkbox(checked: isChecked),
            ],
          ),
        ),
      ),
    );
  }
}

class _Checkbox extends StatelessWidget {
  const _Checkbox({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return AnimatedContainer(
      duration: KMotion.fast,
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: checked ? colors.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: checked ? colors.accent : colors.border,
          width: 1.5,
        ),
      ),
      child: checked
          ? Icon(LucideIcons.check, size: 13, color: colors.fgInverse)
          : null,
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: KMotion.base,
        width: 44,
        height: 26,
        decoration: BoxDecoration(
          color: value ? colors.accent : colors.border,
          borderRadius: BorderRadius.circular(KRadius.full),
        ),
        padding: const EdgeInsets.all(3),
        child: AnimatedAlign(
          duration: KMotion.base,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          curve: Curves.easeOutCubic,
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.auth, required this.isPro});

  final AuthController auth;
  final bool isPro;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;

    if (auth.isSignedIn) {
      return Container(
        padding: const EdgeInsets.all(KSpace.s4),
        decoration: BoxDecoration(
          color: colors.bgElevated,
          border: Border.all(color: colors.border),
          borderRadius: BorderRadius.circular(KRadius.lg),
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 20,
              backgroundColor: colors.accentLight,
              backgroundImage: auth.avatarUrl != null
                  ? NetworkImage(auth.avatarUrl!)
                  : null,
              child: auth.avatarUrl == null
                  ? Icon(LucideIcons.user, size: 18, color: colors.accent)
                  : null,
            ),
            const SizedBox(width: KSpace.s3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    auth.displayName ?? loc.accountSignedInFallback,
                    style: KText.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.fgPrimary,
                    ),
                  ),
                  Text(
                    loc.accountSyncingEnabled,
                    style: KText.caption.copyWith(color: colors.fgTertiary),
                  ),
                ],
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => auth.signOut(),
                borderRadius: BorderRadius.circular(KRadius.md),
                child: Padding(
                  padding: const EdgeInsets.all(KSpace.s2),
                  child: Text(
                    loc.accountSignOut,
                    style: KText.bodySm.copyWith(
                      color: colors.fgTertiary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isPro
            ? () => _showSignInSheet(context)
            : () => PaywallScreen.show(context),
        borderRadius: BorderRadius.circular(KRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(KSpace.s4),
          decoration: BoxDecoration(
            color: colors.bgElevated,
            border: Border.all(color: colors.border),
            borderRadius: BorderRadius.circular(KRadius.lg),
          ),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                radius: 20,
                backgroundColor: colors.accentLight,
                child: Icon(LucideIcons.cloudUpload, size: 18, color: colors.accent),
              ),
              const SizedBox(width: KSpace.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            loc.accountSignInToSync,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: KText.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.fgPrimary,
                            ),
                          ),
                        ),
                        if (!isPro) const _ProBadge(),
                      ],
                    ),
                    Text(
                      loc.accountSignInSubtitle,
                      style: KText.caption.copyWith(color: colors.fgTertiary),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 16, color: colors.fgTertiary),
            ],
          ),
        ),
      ),
    );
  }

  void _showSignInSheet(BuildContext context) {
    final colors = context.colors;
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: colors.scrim,
      builder: (_) => const _SignInSheet(),
    );
  }
}

class _SignInSheet extends StatelessWidget {
  const _SignInSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final auth = context.read<AuthController>();
    final loc = AppLocalizations.of(context)!;
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
              loc.accountSignInToSync,
              style: KText.h3.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.fgPrimary,
              ),
            ),
            const SizedBox(height: KSpace.s2),
            Text(
              loc.signInSheetSubtitle,
              style: KText.bodySm.copyWith(color: colors.fgTertiary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: KSpace.s6),
            KOAuthButton(
              provider: OAuthProvider.google,
              onTap: () {
                Navigator.of(context).pop();
                auth.signInWithGoogle();
              },
            ),
            if (KOAuthButton.showApple) ...[
              const SizedBox(height: KSpace.s3),
              KOAuthButton(
                provider: OAuthProvider.apple,
                onTap: () {
                  Navigator.of(context).pop();
                  auth.signInWithApple();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TypeColorPickerSheet extends StatelessWidget {
  const _TypeColorPickerSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final controller = context.watch<TypeColorController>();
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.75,
      ),
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(KRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(KRadius.full),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 8),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.settingsTypeColors,
                    style: KText.h3.copyWith(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: colors.fgPrimary,
                    ),
                  ),
                ),
                if (controller.overrides.isNotEmpty)
                  TextButton(
                    onPressed: controller.resetAll,
                    child: Text(
                      AppLocalizations.of(context)!.typeColorsResetAll,
                      style: KText.bodySm.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.fgTertiary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.borderSubtle),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: KSpace.s4 + bottomSafe),
              itemCount: ActivityType.values.length,
              itemBuilder: (ctx, i) {
                final type = ActivityType.values[i];
                return _TypeColorRow(type: type);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeColorRow extends StatelessWidget {
  const _TypeColorRow({required this.type});

  final ActivityType type;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final controller = context.watch<TypeColorController>();
    final currentIdx = controller.indexFor(type);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: <Widget>[
          KTypeTile(type: type, size: 32, iconSize: 15),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              type.localized(AppLocalizations.of(context)!),
              style: KText.body.copyWith(color: colors.fgPrimary),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(TypeColorController.paletteSize, (idx) {
              final swatch = colors.paletteColor(idx);
              final selected = currentIdx == idx ||
                  (currentIdx == null &&
                      KadenceColors.defaultIndexFor(type) == idx);
              return GestureDetector(
                onTap: () => controller.setColor(type, idx),
                child: Container(
                  width: 22,
                  height: 22,
                  margin: const EdgeInsets.only(left: 6),
                  decoration: BoxDecoration(
                    color: swatch.tint,
                    shape: BoxShape.circle,
                    border: selected
                        ? Border.all(color: colors.fgPrimary, width: 2)
                        : null,
                  ),
                  child: selected
                      ? Icon(LucideIcons.check, size: 11, color: colors.bgBase)
                      : null,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ProCard extends StatelessWidget {
  const _ProCard({required this.onTap});

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
          padding: const EdgeInsets.all(KSpace.s4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                colors.accent.withValues(alpha: 0.15),
                colors.accent.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: colors.accent.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(KRadius.lg),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(KRadius.md),
                ),
                child: Icon(
                  LucideIcons.crown,
                  size: 20,
                  color: colors.accent,
                ),
              ),
              const SizedBox(width: KSpace.s3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Kadence ',
                            style: KText.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.fgPrimary,
                            ),
                          ),
                          TextSpan(
                            text: 'Pro',
                            style: KText.body.copyWith(
                              fontWeight: FontWeight.w600,
                              color: colors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context)!.proCardSubtitle,
                      style: KText.caption.copyWith(color: colors.fgTertiary),
                    ),
                  ],
                ),
              ),
              Icon(LucideIcons.chevronRight, size: 16, color: colors.accent),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalPickerSheet extends StatelessWidget {
  const _GoalPickerSheet({
    required this.current,
    required this.onSelected,
  });

  final int? current;
  final ValueChanged<int?> onSelected;

  static const _options = [0, 2, 3, 4, 5, 6, 7];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;
    return Container(
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(KRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(KRadius.full),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              AppLocalizations.of(context)!.settingsWeeklyGoal,
              style: KText.h3.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.fgPrimary,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              AppLocalizations.of(context)!.weeklyGoalPrompt,
              style: KText.bodySm.copyWith(color: colors.fgTertiary),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: KSpace.s4),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, KSpace.s4 + bottomSafe),
            child: Wrap(
              spacing: KSpace.s2,
              runSpacing: KSpace.s2,
              children: _options.map((n) {
                final isOff = n == 0;
                final selected = isOff ? current == null : current == n;
                final loc = AppLocalizations.of(context)!;
                return GestureDetector(
                  onTap: () => onSelected(isOff ? null : n),
                  child: AnimatedContainer(
                    duration: KMotion.fast,
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: selected
                          ? colors.accent.withValues(alpha: 0.12)
                          : colors.bgSubtle,
                      borderRadius: BorderRadius.circular(KRadius.lg),
                      border: Border.all(
                        color: selected ? colors.accent : colors.border,
                        width: selected ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        isOff ? loc.weeklyGoalOff : '$n',
                        style: KText.body.copyWith(
                          fontWeight: FontWeight.w700,
                          color: selected ? colors.accent : colors.fgPrimary,
                          fontSize: isOff ? 14 : 18,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _AccentColorRow extends StatelessWidget {
  const _AccentColorRow({
    required this.label,
    this.icon,
    this.iconBg,
    this.proBadge = false,
    this.isPro = true,
  });

  final String label;
  final IconData? icon;
  final Color? iconBg;
  final bool proBadge;
  final bool isPro;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final controller = context.watch<TypeColorController>();
    final swatch = colors.paletteColor(controller.accentIndex);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isPro
            ? () => _showAccentColorSheet(context)
            : () => PaywallScreen.show(context),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: colors.borderSubtle, width: 1),
            ),
          ),
          padding:
              const EdgeInsets.symmetric(horizontal: KSpace.s4, vertical: 13),
          child: Row(
            children: <Widget>[
              if (icon != null) ...[
                _RowIcon(icon: icon!, bg: iconBg ?? colors.fgTertiary),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Row(
                  children: [
                    Text(
                      label,
                      style: KText.body.copyWith(color: colors.fgPrimary),
                    ),
                    if (proBadge) const _ProBadge(),
                  ],
                ),
              ),
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  color: swatch.tint,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                LucideIcons.chevronRight,
                size: 14,
                color: colors.fgTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAccentColorSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AccentColorSheet(),
    );
  }
}

class _AccentColorSheet extends StatelessWidget {
  const _AccentColorSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final controller = context.watch<TypeColorController>();
    final currentIdx = controller.accentIndex;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    return Container(
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(KRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(KRadius.full),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              AppLocalizations.of(context)!.settingsThemeColor,
              style: KText.h3.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.fgPrimary,
              ),
            ),
          ),
          Divider(height: 1, color: colors.borderSubtle),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomSafe),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(TypeColorController.paletteSize, (idx) {
                final swatch = colors.paletteColor(idx);
                final selected = currentIdx == idx;
                return GestureDetector(
                  onTap: () => controller.setAccent(idx),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: swatch.tint,
                      shape: BoxShape.circle,
                      border: selected
                          ? Border.all(color: colors.fgPrimary, width: 2.5)
                          : null,
                    ),
                    child: selected
                        ? Icon(LucideIcons.check,
                            size: 16, color: colors.bgBase)
                        : null,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguagePickerSheet extends StatelessWidget {
  const _LanguagePickerSheet();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loc = AppLocalizations.of(context)!;
    final controller = context.watch<LocaleController>();
    final current = controller.locale;
    final bottomSafe = MediaQuery.paddingOf(context).bottom;

    final options = <_LanguageOption>[
      _LanguageOption(locale: null, label: loc.languageSystem),
      _LanguageOption(locale: const Locale('en'), label: loc.languageEnglish),
      _LanguageOption(
        locale: const Locale('pt'),
        label: loc.languagePortuguese,
      ),
      _LanguageOption(
        locale: const Locale('pt', 'BR'),
        label: loc.languagePortugueseBR,
      ),
      _LanguageOption(locale: const Locale('es'), label: loc.languageSpanish),
      _LanguageOption(locale: const Locale('fr'), label: loc.languageFrench),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colors.bgElevated,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(KRadius.xl),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 10),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: colors.border,
              borderRadius: BorderRadius.circular(KRadius.full),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              loc.settingsLanguage,
              style: KText.h3.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.fgPrimary,
              ),
            ),
          ),
          Divider(height: 1, color: colors.borderSubtle),
          Padding(
            padding: EdgeInsets.only(bottom: KSpace.s2 + bottomSafe),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: options.map((opt) {
                final selected = opt.locale == null
                    ? current == null
                    : current?.languageCode == opt.locale!.languageCode &&
                        current?.countryCode == opt.locale!.countryCode;
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      controller.setLocale(opt.locale);
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              opt.label,
                              style: KText.body.copyWith(
                                color: colors.fgPrimary,
                                fontWeight: selected
                                    ? FontWeight.w600
                                    : FontWeight.w400,
                              ),
                            ),
                          ),
                          if (selected)
                            Icon(LucideIcons.check,
                                size: 18, color: colors.accent),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageOption {
  const _LanguageOption({required this.locale, required this.label});
  final Locale? locale;
  final String label;
}
