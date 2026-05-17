# Kadence — Project Guide for Claude

## What this project is

Kadence is a minimalist Flutter mobile app for planning weekly sports
activities. It implements the "Kadence Design System" — Personality:
Calm, Minimalist, Motivating. Default accent color: Coral (#FF7A45
dark / #E85F2C light), user-configurable via Settings.

Screens: 5-step Onboarding, Week View, Month View, Day Detail bottom
sheet, Empty State, Stats, Settings.

## Tech stack

- Flutter >= 3.27 / Dart >= 3.5
- Material 3 with a custom `ThemeData` + `ThemeExtension`
- `provider` for state (ChangeNotifier + MultiProvider)
- `shared_preferences` for theme + onboarding flags
- `sqflite` for local activity persistence (SQLite)
- `path` for database path resolution
- `google_fonts` (Sora, tabular figures)
- `lucide_icons_flutter` for outline icons
- No external charting library — stats heatmap is built with custom widgets

## Architecture at a glance

```
lib/
  main.dart               # Initializes prefs + DB, awaits PlanController, runs KadenceApp
  app.dart                # MaterialApp + TodayScope + onboarding gate
  theme/                  # Design tokens (colors, spacing, text, theme)
  models/                 # Activity + DayStatus + ActivityType
  state/                  # ChangeNotifier controllers (theme, onboarding, plan, type_color) + ActivityDb
  utils/date_utils.dart   # KDate helpers + TodayScope (wall-clock refresh)
  widgets/                # Shared primitives (KButton, KInput, KTopBar, etc.)
  screens/
    onboarding/           # 5-step flow
    home/                 # Shell (IndexedStack + bottom nav)
    week/                 # Week view + day card
    month/                # Month grid + selected-day detail
    day_detail/           # Day overview sheet + add/edit form sheet
      widgets/            # Extracted form widgets (type selector, pickers, etc.)
    empty/                # Empty state
    stats/                # Stats screen (KPIs + heatmap + type breakdown)
    settings/             # Settings screen
```

## Code structure & good practices

- **Keep files small**: no Dart file should exceed ~400 lines. When a
  file grows beyond that, extract self-contained widgets, helpers, or
  models into their own files. A screen file should contain only the
  screen's state and layout — supporting widgets belong in a `widgets/`
  subfolder (e.g. `screens/day_detail/widgets/`).
- **Extract early**: if a widget has its own state, distinct
  responsibility, or is reused in more than one place, it belongs in
  its own file. Don't wait for the file to get large — extract as you
  write. Private `_Foo` widgets are fine for tiny helpers; anything
  over ~60 lines or with its own callbacks should be public and
  extracted.
- **Shared widgets go in `lib/widgets/`**: prefixed with `k_` (e.g.
  `k_button.dart`, `k_activity_card.dart`). Screen-specific widgets
  go in the screen's `widgets/` subfolder.
- **One responsibility per file**: a model file defines the model. A
  controller file defines the controller. Don't mix UI and business
  logic in the same file.
- **Name files after their primary export**: `type_selector.dart`
  exports `TypeSelector`, `duration_picker.dart` exports
  `DurationPickerField` + `DurationPickerSheet`, etc.
- **Avoid duplication**: before writing a widget, check if a similar
  one already exists in `lib/widgets/` or a screen's `widgets/`
  subfolder. Extend or compose existing widgets rather than
  copy-pasting. If two files have the same private widget, extract it
  into a shared file.
- **Prefer composition over configuration**: rather than adding many
  boolean flags to one widget, create focused variants or compose
  smaller pieces.

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
  `plan`, `type_color`). Screens read via `context.watch<T>()` /
  `context.read<T>()`.
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
- **Per-type color system**: `TypeColorController`
  (`lib/state/type_color_controller.dart`) manages user-customizable
  colors for each activity type plus a global accent color. It stores
  per-type overrides as a palette index (0–6) in SharedPreferences
  (`kadence.type_colors`). The accent color is also a palette index
  (`kadence.accent_color`, default 0 = Coral).
  - **7-color palette**: Coral(0), Blue(1), Rose(2), Purple(3),
    Teal(4), Green(5), Amber(6). Each has light+dark tint/bg pairs
    defined in `KadenceColors.paletteColor(int)`.
  - **Resolving type colors**: use `context.typeColor(type)` (a
    `BuildContext` extension in `kadence_colors.dart`). This checks
    `TypeColorController` for a user override first, then falls back
    to the type's default palette color. **Never** call
    `colors.typeColors(type)` directly — always go through the
    extension so overrides are respected.
  - **Accent color**: fixed per-user (not dynamic per screen). Read
    via `TypeColorController.accentTint(colors)`. Used for the FAB,
    bottom nav active tab, top bar underline, and toggle accents.
    Default is Coral (#FF7A45 dark / #E85F2C light). Users can change
    it in Settings via the accent color row.
  - **Settings UI**: the Settings screen has an "Accent color" row
    with 7 inline palette dots, and a "Type colors" row that opens a
    bottom sheet listing all 19 activity types with 7 swatches each.
- **Multiple activities per day**: `PlanController` stores
  `Map<String, List<Activity>>` — each date can hold N entries. APIs:
  - `forDate(date) → Activity` returns the *primary* (priority order:
    today > planned > done, then insertion order). Falls back to a
    synthetic empty placeholder.
  - `activitiesFor(date) → List<Activity>` returns all entries.
  - `allActivities() → Iterable<Activity>` flat iteration across every
    date. Used by the stats screen for whole-history aggregates. No
    guaranteed order.
  - `extrasFor(date) → int` is the count beyond the primary (used for
    "+N more" badges in the week view).
  - `save({date, id?, name, type?, duration?, timeOfDay?, notes?})`:
    pass `id` to update an existing entry, omit it to append a new one.
  - `toggleDone(date, {id})`: toggles a single activity. `id` optional —
    when omitted, the day's primary is toggled. **Silently ignored for
    future dates** — activities can only be marked done on or before
    today.
  - `toggleAllDone(date)`: lockstep flip across every activity on the
    day. If all are done, marks them planned/today; otherwise marks
    them all done. Used by the week view's parent check button so
    "checking the parent" cascades to all children. **Also blocked for
    future dates.**
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
- **Activity fields**: `Activity` has `name`, `type` (`ActivityType?`),
  `timeOfDay` (`String?`, stored as `"HH:mm"` 24-hour format),
  `duration` (`String?`, stored as `"N min"` e.g. `"45 min"`), `notes`,
  and `calendarEventId`. There is no `intensity` field. The `meta`
  getter formats as `"time · duration"`.
- **Time display is always 12-hour AM/PM**. Even though `timeOfDay`
  is stored internally as 24-hour `"HH:mm"`, all UI surfaces call
  `formattedMeta(false)` which converts to 12h format via `_to12h`.
  The time picker field (`time_picker_field.dart`) also forces 12h
  display regardless of device locale.
- **Form fields in `day_detail_sheet.dart`**: Activity name is a text
  input. Type is a chip selector with **no default** (starts null;
  tapping a selected chip deselects it). Time opens
  `showTimePicker` and always displays in 12h AM/PM format. Duration
  opens a `CupertinoPicker` bottom sheet with hour (0–4) and minute
  (0–55, 5-min steps) wheels. Both Time and Duration are optional and
  show a tappable field with clear (×) button when filled.
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
  layout; extend `KActivityCard` instead. The meta row is rendered
  inside `Visibility(maintainSize: true)` so cards in a list stack at
  equal height even when time/duration are absent — don't collapse it
  back to a conditional `if (meta != null)`.
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
- **Week view always shows the day grid** — there is no full-screen
  empty state. Even with zero activities, the week nav arrows, stat
  tiles (showing 0/0/0%), and all seven day rows are rendered so the
  user can navigate to any week and tap any day to add a session.
- **Empty day text is context-aware**: past empty days display "Rest
  day", today and future empty days display "No session"
  (`day_card.dart` reads `TodayScope` to decide).
- **Week + month stat tiles** (`Done` / `Planned` / `On track`) count
  *every* activity across the visible period, not one primary per
  day. `Planned` is a *static total* of all sessions (done or not) —
  it does not shrink as activities are completed. `On track =
  done / planned`. Computed inline in `week_view.dart` and
  `month_view.dart` by iterating `plan.activitiesFor(d)` over the
  date range.
- **Bottom nav has four tabs**: `HomeTab { week, month, stats,
  settings }` (`lib/widgets/k_bottom_nav.dart`). The order matches
  the `IndexedStack` children in `home_screen.dart` — keep them in
  sync. The FAB hides on both `stats` and `settings` (read-only
  tabs).
- **Stats screen**: `lib/screens/stats/stats_view.dart` is read-only
  and recomputes from `PlanController` on every build (no caching).
  Layout: 2 KPI tiles (Total sessions, Week streak), a **26-week
  activity heatmap** (custom widget, no charting library), and a "By
  activity" type breakdown with `LinearProgressIndicator` bars.
  - **Heatmap**: a grid of small day cells spanning 26 weeks. Each
    cell's color reflects the activity type done that day. Cells with
    only planned (not-done) activities are shown **dimmed** (35% blend
    toward `bgCard`). The heatmap **ends at today** — no future day
    cells are rendered. Scrollable horizontally, anchored to today
    (rightmost).
  - **Type filter**: tapping an activity type in the breakdown filters
    the heatmap to highlight only that type's cells.
  - Streak rule: count consecutive completed weeks ending at the most
    recent completed week; the current week is *excluded* (not reset)
    when it has zero done sessions so far.
  - **Done-only for KPIs**: Total sessions and streak count only
    `DayStatus.done` activities. The heatmap shows both done
    (full color) and planned (dimmed) so users can see their schedule.
  - `_StatsData` pre-computes day cells with separate `doneCount` and
    `plannedCount` per cell, plus all-time type breakdowns.
  - Empty state shown when `totalSessions == 0` and no planned
    activities exist.

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
- **Local persistence via SQLite**: `ActivityDb`
  (`lib/state/activity_db.dart`) wraps `sqflite` with a single
  `activities` table (schema version 3). `PlanController` is created
  via an async factory (`PlanController.create()`) that loads from the
  DB at startup and fire-and-forgets writes on every mutation. **On web**,
  `sqflite` is not supported — `ActivityDb` detects `kIsWeb` and
  no-ops all calls, so the app runs in-memory (no persistence across
  refreshes). On native (iOS/Android/macOS) data persists to disk.
- **No seed data**: the app starts empty. First-time users see the
  empty week grid and can add their own sessions.
- **Default theme is dark mode**. `ThemeController` falls back to
  `ThemeMode.dark` when no preference is saved (not `ThemeMode.system`).
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
- No localization — copy is hardcoded English.
- No integration tests; only one smoke test in `test/widget_test.dart`.

## Roadmap

### Calendar sync (done — polish remaining)
- ✅ `device_calendar` plugin wired up (CalendarKit / CalendarProvider).
- ✅ Runtime permissions, calendar picker, create/update/delete events.
- ✅ Default syncs to all writable calendars; user can pick a specific
  one. Event IDs stored as JSON map on `Activity.calendarEventId`.
- ✅ Deleting an activity in the app also deletes the calendar event
  (app is source of truth). Calendar events use `Activity.timeOfDay`
  for the start time (falls back to 08:00 when unset).
- **TODO**: multi-select calendar picker (checkboxes instead of
  single-select / all).
- **TODO**: consider optional "keep on calendar?" prompt when deleting
  an activity that has a linked calendar event.

### Authentication + cloud sync (in progress)
- Supabase chosen as backend. Project ref: `hpkapuvemjzjdjdrqrio`.
  Project settings: Data API enabled, auto-expose new tables disabled,
  automatic RLS enabled.
- Auth providers: Google + Apple Sign-In. Google OAuth configured
  (web client ID in Supabase). Apple pending developer enrollment.
- Supabase credentials stored in `.env` (gitignored), loaded via
  `--dart-define-from-file=.env`. Shell alias `fr` defined in
  `~/.zshrc` for convenience (`flutter run --dart-define-from-file=.env`).

#### Database schema (done)
- ✅ `profiles` table: auto-created on signup via trigger on
  `auth.users`. Columns: `id` (uuid, PK, FK → auth.users),
  `display_name`, `avatar_url`, `created_at`. RLS: users read/update
  own row only.
- ✅ `activities` table: mirrors local SQLite schema + cloud fields.
  Columns: `id` (text, PK — matches local UUIDs), `user_id` (uuid,
  FK → auth.users), `date`, `status`, `name`, `type`, `duration`,
  `time_of_day`, `notes`, `calendar_event_id`, `created_at`,
  `updated_at` (auto-bumped via trigger). Index on
  `(user_id, date)`. RLS: full CRUD scoped to own `user_id`.
- ✅ `handle_new_user()` trigger populates `profiles` from Google/Apple
  metadata (`full_name`, `avatar_url`) on signup.
- ✅ `update_updated_at()` trigger auto-sets `updated_at` on every
  activity update — used by last-write-wins sync.

#### Flutter auth layer (done)
- ✅ `supabase_flutter` package added.
- ✅ `AuthController` (`lib/state/auth_controller.dart`): wraps
  Supabase auth client, listens to `onAuthStateChange`, exposes
  `isSignedIn`, `user`, `displayName`, `signInWithGoogle()`,
  `signInWithApple()`, `signOut()`.
- ✅ `LoginScreen` (`lib/screens/auth/login_screen.dart`): Google +
  Apple sign-in buttons, Kadence design tokens.
- ✅ Auth is optional — no gate. Users sign in from Settings or the
  6th onboarding step. App is fully usable without an account.
- ✅ Deep link URL scheme (`io.supabase.kadence://login-callback/`)
  configured in iOS `Info.plist` and Android `AndroidManifest.xml`.
- ✅ Settings: prominent account card at top (avatar + name + sign out
  when signed in; "Sign in to sync" CTA when signed out). Sign-in
  opens a bottom sheet with Google/Apple buttons.
- ✅ Onboarding: 6th step offers sign-in with "Skip for now" option.
- ✅ Sign out row added to settings screen.

#### Sync layer (done)
- ✅ `SyncService` (`lib/state/sync_service.dart`): offline-first
  sync with ownership tracking and last-write-wins.
- ✅ Ownership via `kadence.last_synced_user_id` in SharedPreferences.
  Three sign-in scenarios:
  - No owner (offline data) → push local to cloud, merge.
  - Same user → merge local + cloud, push local-only.
  - Different user → discard local, pull cloud only.
- ✅ `PlanController` pushes every mutation (save/toggle/delete) to
  cloud when signed in. Fire-and-forget for offline resilience.
- ✅ `AuthController` triggers full sync on sign-in, clears owner on
  sign-out. Exposes `isSyncing` flag.

#### TODO
- **TODO**: enroll in Apple Developer Program ($99/yr) to configure
  Apple Sign-In (Services ID, return URL, Sign in with Apple
  capability in Xcode).
- **TODO**: add native Google Sign-In (Android/iOS client IDs) for
  one-tap sign-in instead of browser redirect.
- Required foundation for Strava integration (need a backend to
  securely store OAuth tokens and handle callbacks).

### Strava integration (after auth)
- **Read from Strava**: poll for completed Strava activities via
  `GET /api/v3/athlete/activities`. Match by date + activity type
  against planned sessions and auto-mark them as done.
- **Write to Strava**: when a manual activity is marked done, offer
  an optional "Send to Strava" action. Creates a manual entry via
  `POST /api/v3/activities` (name, type, start time, duration).
- Both directions require Strava OAuth2 (`activity:read_all` +
  `activity:write` scopes). User authorizes once; refresh token
  stored locally.
- Garmin Connect has no public API for individual devs — most Garmin
  users sync to Strava anyway, so Strava covers the majority of
  devices (Garmin, Apple Watch, Polar, Wahoo, etc.).
