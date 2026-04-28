import 'package:flutter/widgets.dart';

/// Utility helpers around [DateTime]. Weeks are Monday-based to match the
/// design system. The app uses the device's local calendar everywhere.
class KDate {
  const KDate._();

  static const List<String> shortWeekdays = <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  static const List<String> minWeekdays = <String>[
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
    'Su',
  ];

  static const List<String> shortMonths = <String>[
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const List<String> fullMonths = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// Zeroes out hour/minute/second so two days can be compared by identity.
  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  /// The Monday of the week that contains [date].
  static DateTime mondayOfWeek(DateTime date) {
    final d = startOfDay(date);
    // DateTime.weekday: Monday == 1 .. Sunday == 7
    return d.subtract(Duration(days: d.weekday - DateTime.monday));
  }

  /// Seven consecutive days starting from the Monday of [date]'s week.
  static List<DateTime> weekFor(DateTime date) {
    final monday = mondayOfWeek(date);
    return List<DateTime>.generate(7, (i) => monday.add(Duration(days: i)));
  }

  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Number of days in the given month.
  static int daysInMonth(int year, int month) =>
      DateTime(year, month + 1, 0).day;

  /// A stable `yyyy-MM-dd` key for maps and preference storage.
  static String keyFor(DateTime date) {
    final d = startOfDay(date);
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}

/// Semantic helpers that read nicely at call sites.
extension DateTimeKadence on DateTime {
  DateTime get justDate => KDate.startOfDay(this);

  String get shortWeekday => KDate.shortWeekdays[weekday - 1];
  String get shortMonth => KDate.shortMonths[month - 1];
  String get fullMonth => KDate.fullMonths[month - 1];
}

/// Keeps a subtree in sync with wall-clock "today" so views that highlight
/// the current day update when the day rolls over while the app is open.
class TodayScope extends StatefulWidget {
  const TodayScope({required this.child, super.key});

  final Widget child;

  static DateTime of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_TodayInherited>();
    assert(scope != null, 'Wrap the app in TodayScope');
    return scope!.today;
  }

  @override
  State<TodayScope> createState() => _TodayScopeState();
}

class _TodayScopeState extends State<TodayScope> with WidgetsBindingObserver {
  late DateTime _today;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _today = KDate.startOfDay(DateTime.now());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final now = KDate.startOfDay(DateTime.now());
      if (!KDate.isSameDay(now, _today)) setState(() => _today = now);
    }
  }

  @override
  Widget build(BuildContext context) =>
      _TodayInherited(today: _today, child: widget.child);
}

class _TodayInherited extends InheritedWidget {
  const _TodayInherited({required this.today, required super.child});

  final DateTime today;

  @override
  bool updateShouldNotify(_TodayInherited oldWidget) =>
      !KDate.isSameDay(oldWidget.today, today);
}
