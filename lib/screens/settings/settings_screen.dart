import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';

import '../../models/activity.dart';
import '../../state/auth_controller.dart';
import '../../state/backup_service.dart';
import '../../state/calendar_service.dart';
import '../../state/onboarding_controller.dart';
import '../../state/plan_controller.dart';
import '../../state/sync_service.dart';
import '../../state/theme_controller.dart';
import '../../state/type_color_controller.dart';
import '../../theme/kadence_colors.dart';
import '../../theme/kadence_spacing.dart';
import '../../theme/kadence_text_styles.dart';
import '../../widgets/k_oauth_button.dart';
import '../../widgets/k_type_tile.dart';
import '../../state/activity_db.dart';

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

  String get _calendarLabel {
    if (!_calendarSync) return 'Off';
    if (_loadingCalendars) return '…';
    if (_selectedIds.isEmpty) return 'All calendars';
    if (_selectedIds.length == 1) {
      final match = _calendars.where((c) => c.id == _selectedIds.first);
      if (match.isNotEmpty) return match.first.name ?? 'Calendar';
    }
    return '${_selectedIds.length} calendars';
  }

  Future<void> _exportData() async {
    final plan = context.read<PlanController>();
    try {
      await BackupService.exportData(plan.byDate);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Export failed')),
      );
    }
  }

  Future<void> _importData() async {
    final activities = await BackupService.pickAndParse();
    if (activities == null || !mounted) return;

    final colors = context.colors;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.bgElevated,
        title: Text(
          'Replace all data?',
          style: KText.h3.copyWith(color: colors.fgPrimary),
        ),
        content: Text(
          'This will replace all your current data with the imported data (${activities.length} activities).',
          style: KText.body.copyWith(color: colors.fgSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: KText.button.copyWith(color: colors.fgTertiary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Replace',
              style: KText.button.copyWith(color: const Color(0xFFB5443A)),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final plan = context.read<PlanController>();
    final auth = context.read<AuthController>();
    final grouped = BackupService.groupByDate(activities);

    await ActivityDb.deleteAll();
    for (final list in grouped.values) {
      await ActivityDb.upsertAll(list);
    }
    plan.replaceAll(grouped);

    if (auth.isSignedIn && plan.userId != null) {
      await SyncService.pushAll(grouped, plan.userId!);
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Imported ${activities.length} activities')),
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

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        KSpace.s4,
        KSpace.s2,
        KSpace.s4,
        KSpace.s16,
      ),
      children: <Widget>[
        _AccountCard(auth: auth),
        const SizedBox(height: KSpace.s3),
        _Group(
          rows: <Widget>[
            _ToggleRow(
              label: 'Dark mode',
              value: theme.isDark,
              onChanged: (_) => theme.toggleDark(),
            ),
            _StaticRow(
              label: 'Default view',
              value: 'Week',
              onTap: () {},
            ),
            _StaticRow(
              label: 'Week starts on',
              value: theme.weekStartsOnSunday ? 'Sunday' : 'Monday',
              onTap: () => theme.toggleWeekStart(),
            ),
            _StaticRow(
              label: 'Reminders',
              value: onboarding.remindersEnabled ? 'On' : 'Off',
              onTap: () => onboarding.setReminders(
                enabled: !onboarding.remindersEnabled,
              ),
            ),
            const _AccentColorRow(label: 'Theme color', isLast: true),
          ],
        ),
        const SizedBox(height: KSpace.s3),
        _Group(
          rows: <Widget>[
            _ToggleRow(
              label: 'Calendar sync',
              value: _calendarSync,
              onChanged: _toggleCalendarSync,
            ),
            if (_calendarSync)
              _StaticRow(
                label: 'Calendars',
                value: _calendarLabel,
                onTap: _pickCalendars,
                isLast: true,
              ),
            if (!_calendarSync)
              const SizedBox.shrink(),
          ],
        ),
        const SizedBox(height: KSpace.s3),
        _Group(
          rows: <Widget>[
            _StaticRow(
              label: 'Export data',
              value: 'Share',
              onTap: _exportData,
            ),
            _StaticRow(
              label: 'Import data',
              value: 'Load',
              onTap: _importData,
              isLast: true,
            ),
          ],
        ),
        const SizedBox(height: KSpace.s3),
        _Group(
          rows: <Widget>[
            _StaticRow(
              label: 'Type colors',
              value: 'Customize',
              onTap: () => _showTypeColorPicker(context),
              isLast: true,
            ),
          ],
        ),
        const SizedBox(height: KSpace.s3),
        _Group(
          rows: <Widget>[
            _StaticRow(
              label: 'Redo onboarding',
              value: 'Start',
              onTap: () async {
                await onboarding.reset();
              },
              isLast: true,
            ),
          ],
        ),
        const SizedBox(height: KSpace.s4),
        Text(
          'Kadence · v1.0',
          textAlign: TextAlign.center,
          style: KText.caption.copyWith(
            fontSize: 11,
            color: colors.fgDisabled,
          ),
        ),
      ],
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

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

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
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool isLast;

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
              Expanded(
                child: Text(
                  label,
                  style: KText.body.copyWith(color: colors.fgPrimary),
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
                    'Choose calendars',
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
                    'Done',
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
                if (i == 0) {
                  return _CalendarRow(
                    label: 'All calendars',
                    icon: LucideIcons.layers,
                    isChecked: _isAll,
                    onTap: _toggleAll,
                  );
                }
                final cal = widget.calendars[i - 1];
                final id = cal.id ?? '';
                return _CalendarRow(
                  label: cal.name ?? 'Calendar',
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
  const _AccountCard({required this.auth});

  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

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
                    auth.displayName ?? 'Signed in',
                    style: KText.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colors.fgPrimary,
                    ),
                  ),
                  Text(
                    'Syncing enabled',
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
                    'Sign out',
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
        onTap: () => _showSignInSheet(context),
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
                    Text(
                      'Sign in to sync',
                      style: KText.body.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colors.fgPrimary,
                      ),
                    ),
                    Text(
                      'Back up and access your data anywhere',
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
              'Sign in to sync',
              style: KText.h3.copyWith(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: colors.fgPrimary,
              ),
            ),
            const SizedBox(height: KSpace.s2),
            Text(
              'Back up your data and access it from any device.',
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
                    'Type colors',
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
                      'Reset all',
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
              type.label,
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

class _AccentColorRow extends StatelessWidget {
  const _AccentColorRow({this.label = 'Accent color', this.isLast = false});

  final String label;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final controller = context.watch<TypeColorController>();
    final currentIdx = controller.accentIndex;

    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(color: colors.borderSubtle, width: 1),
              ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: KSpace.s4, vertical: 13),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              label,
              style: KText.body.copyWith(color: colors.fgPrimary),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(TypeColorController.paletteSize, (idx) {
              final swatch = colors.paletteColor(idx);
              final selected = currentIdx == idx;
              return GestureDetector(
                onTap: () => controller.setAccent(idx),
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
