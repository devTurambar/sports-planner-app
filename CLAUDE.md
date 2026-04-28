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
    day_detail/           # Modal bottom sheet for editing a day
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
- **Status promotion**: an empty day that equals today should render as
  `DayStatus.today`, not `empty`. This is handled in `PlanController`
  and in Month grid cell build logic.
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

## Not done yet

- No app icons / launcher assets.
- No real backend — all data is in-memory via `PlanController` with
  SharedPreferences only being used for theme + onboarding flags.
- No localization — copy is hardcoded English.
- No integration tests; only one smoke test in `test/widget_test.dart`.
