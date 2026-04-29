# Kadence — Project Guide for Claude

## What this project is

Kadence is a minimalist Flutter mobile app for planning weekly sports
activities. It implements the "Kadence Design System" — Personality:
Calm, Minimalist, Motivating. Accent color: Forest Sage (#4A7C59).

Screens: 5-step Onboarding, Week View, Month View, Day Detail bottom
sheet, Empty State, Settings.

## Tech stack

- Flutter >= 3.27 / Dart >= 3.5
- Material 3 with a custom `ThemeData` + `ThemeExtension`
- `provider` for state (ChangeNotifier + MultiProvider)
- `shared_preferences` for persistence
- `google_fonts` (Sora, tabular figures)
- `lucide_icons_flutter` for outline icons

## Architecture at a glance

```
lib/
  main.dart               # Initializes prefs + MultiProvider, runs KadenceApp
  app.dart                # MaterialApp + TodayScope + onboarding gate
  theme/                  # Design tokens (colors, spacing, text, theme)
  models/                 # Activity + DayStatus + ActivityType
  state/                  # ChangeNotifier controllers (theme, onboarding, plan)
  utils/date_utils.dart   # KDate helpers + TodayScope (wall-clock refresh)
  widgets/                # Shared primitives (KButton, KInput, KTopBar, etc.)
  screens/
    onboarding/           # 5-step flow
    home/                 # Shell (IndexedStack + bottom nav)
    week/                 # Week view + day card
    month/                # Month grid + selected-day detail
    day_detail/           # Day overview sheet + add/edit form sheet
    empty/                # Empty state
    settings/             # Settings screen
```

## Conventions to follow

- **Theme tokens via extension**: read colors as `context.colors.*`
  (defined on `BuildContext` in `theme/kadence_colors.dart`). Don't pull
  from `Theme.of(context).colorScheme` directly — Kadence has its own
  token family. Spacing: `KSpace.s1..s16`. Radii: `KRadius`. Motion:
  `KMotion`.
- **Text styles**: use `KText.*` (from `theme/kadence_text_styles.dart`)
  rather than `Theme.of(context).textTheme`.
- **Dark/light**: mode swap is a real theme change via
  `ThemeController`. Don't branch on `isDark` inside widgets — add the
  token to both `KadenceColors.light` and `KadenceColors.dark` instead.
- **State**: one `ChangeNotifier` per domain (`theme`, `onboarding`,
  `plan`). Screens read via `context.watch<T>()` / `context.read<T>()`.
- **Dates**: always run user-supplied dates through
  `KDate.startOfDay(...)` before storing or comparing. The plan map is
  keyed by `KDate.keyFor(date)` (YYYY-MM-DD).
- **Today**: read "today" from `TodayScope.of(context)`, not
  `DateTime.now()` directly, so widgets rebuild on app resume / date
  rollover.
- **DayStatus has four values**: `empty | planned | today | done`. There
  is no `rest` — empty days *are* rest days. The dead
  `colors.statusRest*` tokens still live in `kadence_colors.dart` but
  are unused; safe to ignore or delete.
- **Multiple activities per day**: `PlanController` stores
  `Map<String, List<Activity>>` — each date can hold N entries. APIs:
  - `forDate(date) → Activity` returns the *primary* (priority order:
    today > planned > done, then insertion order). Falls back to a
    synthetic empty placeholder.
  - `activitiesFor(date) → List<Activity>` returns all entries.
  - `extrasFor(date) → int` is the count beyond the primary (used for
    "+N more" badges in the week view).
  - `save({date, id?, ...})`: pass `id` to update an existing entry,
    omit it to append a new one.
  - `toggleDone(date, {id})`: toggles a single activity. `id` optional —
    when omitted, the day's primary is toggled.
  - `toggleAllDone(date)`: lockstep flip across every activity on the
    day. If all are done, marks them planned/today; otherwise marks
    them all done. Used by the week view's parent check button so
    "checking the parent" cascades to all children.
- **Parent ↔ child check sync**: the week-view DayCard's check button
  toggles every activity on the day (`toggleAllDone`). The auto-up
  direction (children all done → parent visibly done) works for free
  because `_pickPrimary` ranks `today > planned > done`: done only
  wins when nothing else is left.
- **Status promotion**: an empty day that equals today should render as
  `DayStatus.today`, not `empty`. Stored `planned` activities are also
  surfaced as `today` at read time when the date matches today (see
  `_withSyncedTodayStatus`) — handled inside `PlanController`, callers
  shouldn't reapply this themselves.
- **Recurrence**: defined in `day_detail_sheet.dart` as
  `RecurrenceRule { none, daily, weekly, weekdays, weekends }`. On
  save it `expand`s into a list of dates and the sheet calls
  `plan.save(...)` for each. Recurrence creates independent
  activities — editing one does not propagate to siblings. Hidden
  when the sheet is in edit mode (`_isEditable == true`).
- **Two distinct sheets** in `lib/screens/day_detail/`:
  - `day_overview_sheet.dart` (`showDayOverviewSheet`) — lists every
    activity on a day, with per-row check + edit and an "Add session"
    button at the bottom. Opened by tapping a non-empty day card in
    the week view, or via the "Add" button on the month view's
    selected-day card.
  - `day_detail_sheet.dart` (`showDayDetailSheet`) — the form for
    creating or editing a single activity. Reached from the overview
    sheet's row tap / Add button, and directly from an empty day
    card in the week view (fast path: empty → straight to the form).
- **Shared activity row**: `lib/widgets/k_activity_card.dart` exports
  `KActivityCard` — a bordered tile with name + status chip + meta
  + trailing affordance (check button when `onCheckTap` is provided,
  otherwise a chevron). Used by both `day_overview_sheet.dart` and
  the month view's `selected_day_card.dart`. Don't duplicate this
  layout; extend `KActivityCard` instead.
- **Bottom sheets and the gesture/safe area**: pad the inner
  scrolling content with `MediaQuery.paddingOf(context).bottom` so
  controls don't sit under the Android gesture bar (see
  `day_detail_sheet.dart`). Flutter's `useSafeArea: true` alone is
  inconsistent across versions for the bottom inset.
- **Hit testing for nested tap targets**: when an interactive control
  (e.g. the check-button circle in `day_card.dart`) sits inside a row
  that itself is `InkWell`-tappable, use `Material + InkWell` on both,
  not a `GestureDetector` for the inner element. Mixed
  GestureDetector/InkWell can let the outer tap win.
- **Icons**: Lucide names are camelCase in `lucide_icons_flutter`
  (`LucideIcons.chevronLeft`). If the package version differs, the
  compile error will be obvious — adjust casing.

## Commands

```bash
flutter pub get                     # install deps
flutter create . --platforms=ios,android  # generate platform folders (first run only)
flutter run                         # run on a connected device / simulator
flutter test                        # run unit + widget tests
flutter analyze                     # lint
```

Lint config lives in `analysis_options.yaml`. We deliberately kept it
light (flutter_lints + strict-casts + avoid_print) — don't add opinion
rules like `prefer_const_constructors` or `require_trailing_commas`
without discussion.

## Things to be careful about

- **`Color.withValues(alpha:)` needs Flutter 3.27+.** If you see
  "method not found" errors, check the Flutter version, not the code.
- **Platform folders aren't committed.** First-time setup requires
  `flutter create . --platforms=ios,android` to generate `ios/` and
  `android/` scaffolding.
- **Sample data is seeded** in `PlanController._seed()` so the app
  never looks empty on first launch. Replace with real persistence
  when you add a backend.
- **Onboarding gate** lives in `_AppGate` (`lib/app.dart`) — it watches
  `OnboardingController.isCompleted`. Resetting the gate for manual
  testing: call `OnboardingController.reset()` or clear the
  `kadence.onboarding.*` keys from SharedPreferences.
- **Bottom sheet keyboard handling** uses `AnimatedPadding` with
  `MediaQuery.viewInsetsOf(context).bottom`. Don't wrap the sheet in
  `SingleChildScrollView` at the top level — the inner list handles
  scrolling.
- **Week view navigation**: `WeekView` is a `StatefulWidget` whose
  state class is exported (`WeekViewState`) so the parent shell can
  reach it via a `GlobalKey<WeekViewState>` and call `jumpToToday()`.
  The "Today" button in `KTopBar` from `home_screen.dart` is wired
  this way. `_cursor` is a date *inside* the displayed week — null
  means "show today's week".
- **Hot reload vs hot restart**: changing a const class's constructor
  shape (renaming/adding/removing fields) is rejected by hot reload
  with "Const class cannot remove fields". Press `R` (capital — hot
  restart) instead of `r` after that kind of edit.

## Not done yet

- No app icons / launcher assets.
- No real backend — all data is in-memory via `PlanController` with
  SharedPreferences only being used for theme + onboarding flags.
- No localization — copy is hardcoded English.
- No integration tests; only one smoke test in `test/widget_test.dart`.
