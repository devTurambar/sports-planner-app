# Kadence — Project Guide for Claude

## What this project is

Kadence is a minimalist Flutter mobile app for planning weekly sports
activities. It implements the "Kadence Design System" — Personality:
Calm, Minimalist, Motivating. Default accent color: Coral (#FF7A45
dark / #E85F2C light), user-configurable via Settings.

Screens: 3-step Onboarding, Week View, Month View, Day Detail bottom
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
- `flutter_svg` for brand logo assets (Google, Apple)
- `share_plus` + `file_picker` for export/import backup
- No external charting library — stats heatmap is built with custom widgets

## Architecture at a glance

```
lib/
  main.dart               # Initializes prefs + DB, awaits PlanController, runs KadenceApp
  app.dart                # MaterialApp + TodayScope + onboarding gate
  theme/                  # Design tokens (colors, spacing, text, theme)
  models/                 # Activity + DayStatus + ActivityType
  state/                  # ChangeNotifier controllers (theme, onboarding, plan, type_color, goal, tip) + ActivityDb + BackupService
  utils/date_utils.dart   # KDate helpers + TodayScope (wall-clock refresh)
  widgets/                # Shared primitives (KButton, KInput, KTopBar, etc.)
  screens/
    onboarding/           # 3-step flow (welcome, calendar sync, data backup)
    home/                 # Shell (IndexedStack + bottom nav)
    week/                 # Week view + day card
    month/                # Month grid + selected-day detail
    day_detail/           # Day overview sheet + add/edit form sheet
      widgets/            # Extracted form widgets (type selector, pickers, etc.)
    empty/                # Empty state
    stats/                # Stats screen (KPIs + heatmap + type breakdown + pro stats)
      widgets/            # Pro stat widgets (personal records, charts, insights, etc.)
    paywall/              # Paywall screen (pricing tiers + feature list)
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
- **Week start day**: user-configurable (Monday or Sunday), persisted
  as `kadence.week_start_day` in SharedPreferences via
  `ThemeController.weekStartDay`. Use `KDate.startOfWeek(date, startDay)`
  and `KDate.weekFor(date, startDay)` instead of the legacy
  `KDate.mondayOfWeek(date)`. Read the setting from
  `context.watch<ThemeController>().weekStartDay` in UI code.
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
  - **Theme color** (labeled "Theme color" in Settings, internally
    called accent color): fixed per-user (not dynamic per screen).
    Read via `TypeColorController.accentTint(colors)`. Used for the
    FAB, bottom nav active tab, top bar underline, and toggle accents.
    Default is Coral (#FF7A45 dark / #E85F2C light). Users can change
    it in Settings via the theme color row.
  - **Settings UI**: the Settings screen has a "Theme color" row
    with 7 inline palette dots, and a "Type colors" row that opens a
    bottom sheet listing all 21 activity types with 7 swatches each.
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
- **Activity IDs**: locally generated as sequential `a1`, `a2`, …
  via `PlanController._nextId()` (counter `_idSeed`). Imported
  activities get fresh IDs prefixed with `i` (e.g.
  `i17163840001234_0`) via `BackupService.reassignIds()` to avoid
  PK collisions in the shared Supabase `activities` table. The
  `_idSeed` is recomputed from the current data set on
  `replaceAll()` — it only tracks the `aNN` format, so imported
  `i`-prefixed IDs don't interfere with the counter.
- **Activity fields**: `Activity` has `name`, `type` (`ActivityType?`),
  `subType` (`String?`), `timeOfDay` (`String?`, stored as `"HH:mm"`
  24-hour format), `duration` (`String?`, stored as `"N min"` e.g.
  `"45 min"`), `notes`, and `calendarEventId`. There is no `intensity`
  field. The `meta` getter formats as `"time · duration"`. The
  `typeLabel` getter returns `subType` when type is `other` and
  `subType` is set, otherwise `type.label`.
- **Sub-types (the "More…" system)**: `ActivityType` has 21 core
  values (run, trailRun, hike, walk, cycle, mtb, swim, gym, yoga,
  hiit, row, ski, surf, climb, tennis, padel, dance, combat,
  elliptical, other). When the user taps the "More…" chip (which
  is `ActivityType.other` under the hood), a searchable bottom sheet
  (`sub_type_sheet.dart`) opens with ~40 additional Strava-derived
  sport types (Alpine Ski, Crossfit, Golf, Pilates, Volleyball, etc.).
  The selected name is stored in `Activity.subType`. All sub-typed
  activities use `ActivityType.other` for color/icon resolution but
  display their specific sub-type label in stats, heatmap breakdowns,
  and the type selector chip. Stats widgets group by `(type, subType)`
  so sub-types appear as separate entries in breakdowns.
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
- **Double-tap to toggle done**: double-tapping a `KActivityCard` or
  a `DayCard` fires the same handler as the check button
  (`onCheckTap`). On a `DayCard` this is `toggleAllDone`; on a
  `KActivityCard` it toggles the individual activity. Future dates
  are silently ignored (enforced in `PlanController`).
- **Long-press to delete**: every tappable activity surface also
  supports `onLongPress` → confirmation dialog → delete.
  - **Single activity**: long-press a `KActivityCard` in the day
    overview sheet or the month view's `SelectedDayCard`. Calls
    `plan.delete(date:, id:)`.
  - **Entire day**: long-press a `DayCard` in the week view, a
    `MonthDayCell` in the month grid, or the `SelectedDayCard` header.
    Calls `plan.clear(date)`. Only active when the day has activities.
  - All delete dialogs share the same style: `AlertDialog` with
    `bgElevated` background, red (#B5443A) "Delete" button, and a
    `mounted` guard before acting on the async result.
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
- **Brand logos**: Google and Apple logos are SVG assets in
  `assets/icons/` rendered via `flutter_svg`. Apple has separate
  `apple_dark.svg` (white) and `apple_light.svg` (black) variants
  selected by theme brightness.
- **OAuth buttons**: `KOAuthButton` (`lib/widgets/k_oauth_button.dart`)
  is the single shared widget for Google/Apple sign-in across all
  screens (onboarding, settings sheet, login screen). Uses real brand
  SVG logos. `KOAuthButton.showApple` returns `true` only on iOS —
  Android shows Google-only. Always use this widget for sign-in
  buttons; don't recreate inline.
- **Export/Import**: `BackupService` (`lib/state/backup_service.dart`)
  handles JSON serialization of activities. Export writes a temp file
  (`kadence-backup-YYYY-MM-DD.json`) and opens the system share sheet
  via `share_plus`. Import uses `file_picker` filtered to `.json`,
  validates structure, and replaces all local data via
  `PlanController.replaceAll()` + `ActivityDb`. If signed in, also
  pushes to Supabase via `SyncService.pushAll()`. JSON format:
  `{ version: 1, exported_at: ISO8601, activities: [...] }`. Settings
  screen has "Export data" and "Import data" rows in their own group.
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
  `activities` table (schema version 4). `PlanController` is created
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
  `MonthView` follows the same pattern — `MonthViewState` is public,
  with its own `jumpToToday()`.
- **Title-tap navigation**: tapping the `KTopBar` title on the week
  or month tabs calls `jumpToToday()` on the respective view, jumping
  back to the current week/month. Wired via `KTopBar.onTitleTap`
  callback in `home_screen.dart`. Stats and settings tabs pass `null`
  (no action).
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
- ✅ Editing an activity updates its calendar event. If the activity
  has no linked event yet (created before sync was enabled),
  `updateEvent` creates one and persists the new `calendarEventId`
  back via `_syncUpdatedEvent`.
- ✅ `_syncNewEvent` and `_syncUpdatedEvent` push the patched
  `calendarEventId` to Supabase after updating local state. This
  ensures cloud rows have the correct calendar reference so that
  activities synced back from cloud (e.g. after account switching)
  can still delete their linked device calendar events.
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
  Columns: `id` (text, PK), `user_id` (uuid, FK → auth.users),
  `date`, `status`, `name`, `type`, `sub_type`, `duration`,
  `time_of_day`, `notes`, `calendar_event_id`, `created_at`, `updated_at`
  (auto-bumped via trigger). Index on `(user_id, date)`. RLS: full
  CRUD scoped to own `user_id`.
  - **PK is `id` alone** (not composite with `user_id`). Local IDs
    are sequential (`a1`, `a2`, …, generated by
    `PlanController._nextId()`). Because PK is shared across all
    users, two users can't have rows with the same `id`. This is
    why `BackupService.reassignIds()` must generate fresh IDs on
    import — without it, upserting imported activities would hit a
    primary key collision with the exporter's existing cloud rows.
    Supabase treats the upsert as an update on the existing row,
    but RLS (Row Level Security — Postgres rules that restrict each
    user to their own rows) blocks the write, so the upsert fails
    silently.
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
- ✅ `LoginScreen` (`lib/screens/auth/login_screen.dart`): uses
  `KOAuthButton` with real brand logos, Kadence design tokens.
  Apple button shown only on iOS.
- ✅ Auth is optional — no gate. Users sign in from Settings or the
  3rd onboarding step. App is fully usable without an account.
- ✅ Deep link URL scheme (`io.supabase.kadence://login-callback/`)
  configured in iOS `Info.plist` and Android `AndroidManifest.xml`.
- ✅ Settings: prominent account card at top (avatar + name + sign out
  when signed in; "Sign in to sync" CTA when signed out). Sign-in
  opens a bottom sheet with Google/Apple buttons.
- ✅ Onboarding: 3rd step ("Keep your data safe") presents two
  equal-weight cards — Manual backup (first) with "Continue without
  account" button, and Cloud sync (second) with Google/Apple sign-in.
  No "Skip" — the manual path is the positive non-login option.
  Auto-advances to the app when OAuth sign-in succeeds.
- ✅ Sign out row added to settings screen.

#### Sync layer (done)
- ✅ `SyncService` (`lib/state/sync_service.dart`): offline-first
  sync with ownership tracking and last-write-wins.
- ✅ **Ownership tag** (`kadence.last_synced_user_id` in
  SharedPreferences): tracks which user's data lives locally. Set
  after every successful sync. **Not affected by sign-out** — signing
  out preserves local data and the tag. Cleared explicitly only by
  import-while-signed-out (so next sign-in pushes the imported data
  instead of discarding it).
- ✅ **Three sign-in scenarios** (`syncOnSignIn`):
  - `LocalDataOwner.none` (tag is null — first-time sign-in, or
    cleared by import): push all local to cloud, fetch cloud, merge
    with last-write-wins. Sets owner.
  - `LocalDataOwner.sameUser` (tag matches signing-in user): flush
    pending deletes, fetch cloud, merge local + cloud with
    last-write-wins, push local-only activities. No data loss.
  - `LocalDataOwner.differentUser` (tag is a different user): wipe
    local data entirely (`ActivityDb.deleteAll()`), fetch the
    signing-in user's cloud data, load it. Old local data is
    discarded (it belonged to someone else). Sets owner.
- ✅ **Last-write-wins merge** (`_mergeLastWriteWins`): keyed by
  activity `id`. If both local and cloud have the same ID, cloud
  wins (authoritative `updated_at`). Local-only and cloud-only
  activities are both kept.
- ✅ **Pending deletes**: when a user deletes an activity while signed
  out, the ID is queued in `kadence.pending_deletes` (SharedPrefs).
  On next sign-in with the same user, these are flushed to cloud
  before merging.
- ✅ `PlanController` pushes every mutation (save/toggle/delete) to
  cloud when signed in. Fire-and-forget for offline resilience.
- ✅ `AuthController` triggers full sync on sign-in. Exposes
  `isSyncing` flag. Sign-out clears `userId` on PlanController but
  does **not** clear local data or the ownership tag.
- ✅ **`user_id` is a cloud-only column** — not stored in the local
  Activity model or in export files. `_toCloud()` stamps the current
  signed-in user's ID on every row pushed to Supabase. Imported
  activities from another account get re-stamped with the importing
  user's ID when pushed.

#### TODO
- **TODO**: enroll in Apple Developer Program ($99/yr) to configure
  Apple Sign-In (Services ID, return URL, Sign in with Apple
  capability in Xcode).
- **TODO**: add native Google Sign-In (Android/iOS client IDs) for
  one-tap sign-in instead of browser redirect.
- Required foundation for Strava integration (need a backend to
  securely store OAuth tokens and handle callbacks).

### In-app review prompt (done)
- ✅ `in_app_review` package added. Uses StoreKit (iOS) and Google
  Play In-App Review API (Android) — native OS dialogs.
- ✅ `ReviewService` (`lib/state/review_service.dart`): static
  singleton initialized in `main.dart` with SharedPreferences.
- **Eligibility** (all must be true before prompting):
  - App installed 5+ days ago (`kadence.first_launch` timestamp).
  - 3+ activities saved (counted from `PlanController`).
  - Not dismissed 3 times already (`kadence.review_dismiss_count`).
  - Cooldown since last prompt has elapsed (`kadence.review_last_asked`).
- **Cooldown schedule**:
  - After 1st prompt: 30-day cooldown.
  - After 2nd prompt: 90-day cooldown.
  - After 3rd prompt: never again.
- **Trigger**: called after saving a new activity, `toggleDone`, and
  `toggleAllDone` in `PlanController`. Fire-and-forget — checks
  eligibility synchronously, then calls `requestReview()` only if
  `isAvailable()` returns true.
- **OS-level throttle on top**: Apple caps to 3 prompts per 365 days
  per Apple ID; Google has its own undocumented quota. The OS may
  silently skip the dialog even when our eligibility passes. There is
  no callback to know if the user reviewed or dismissed — our app
  treats every prompt as a "dismiss" for counting purposes.
- ✅ **Manual "Rate Kadence" row** in Settings opens the store listing
  via `InAppReview.instance.openStoreListing()` — no eligibility
  checks, always available. This is separate from the automatic
  in-app review prompt.

### Contextual tutorials (done)
- ✅ `TipController` (`lib/state/tip_controller.dart`): ChangeNotifier
  backed by SharedPreferences (`kadence.tip.*` keys). Tracks which
  tutorials have been seen and whether the user has created their
  first activity (`kadence.tip.first_activity_created`).
- ✅ `KTutorialOverlay` (`lib/widgets/k_tip_banner.dart`): full-screen
  overlay with animated gesture illustrations, title + subtitle text,
  and "Tap anywhere to continue" dismiss. Five gesture types:
  - `swipe` — finger dot sliding left/right with trail dots.
  - `doubleTap` — finger bouncing twice with ripple rings + "×2"
    badge.
  - `longPress` — finger pressing down with a progress arc ring.
  - `tap` — single tap with ripple expansion.
  - `titleTap` — full-screen layout (not the standard animation box).
    A clone of the real title pill starts at the KTopBar position
    (top-left) and slides down to center; a finger dot rises from
    below to meet it. On contact: tap press, accent glow + ripple,
    then both return. Uses `animationHint` to show the correct title
    text (e.g. "This week" vs "May 2025").
- **Trigger rules** (all tips show once per install, persisted):
  - **Swipe tip** (`TipKey.weekSwipe`): first time the week view
    is displayed, immediately after onboarding.
  - **Double-tap tip** (`TipKey.doubleTap`): shown only after the
    user creates their first activity and returns to the week view.
    Triggered by `TipController.onActivityCreated()` called from
    `day_detail_sheet.dart` on new activity save.
  - **Long-press tip** (`TipKey.longPress`): chains immediately
    after dismissing the double-tap tip.
  - **Stats filter tip** (`TipKey.statsFilter`): first time the
    stats tab is active (`StatsView.isActive`) with 2+ activity
    types logged.
  - **Week title-nav tip** (`TipKey.weekTitleNav`): first time the
    user swipes away from the current week. Uses `titleTap` gesture
    to show the title clone sliding from the real KTopBar position.
  - **Month title-nav tip** (`TipKey.monthTitleNav`): same as above
    but for the month view. `animationHint` is set to the current
    month + year so the clone shows the correct title text.
- **IndexedStack visibility**: `StatsView` receives `isActive` from
  `HomeScreen` to avoid firing its overlay while the tab is hidden
  in the `IndexedStack`.
- Tips are shown via `KTutorialOverlay.show()` which inserts an
  `OverlayEntry`. Each tip is gated by `tips.shouldShow(key)` and
  guarded by a local `bool` flag in the widget state to prevent
  re-firing on rebuild.

### Export/Import backup (done)
- ✅ `BackupService` (`lib/state/backup_service.dart`): JSON
  serialization with version metadata.
- ✅ Export via system share sheet (`share_plus`). Filename:
  `kadence-backup-YYYY-MM-DD.json`. Format:
  `{ version: 1, exported_at: ISO8601, activities: [...] }`.
  Export contains no `user_id` — activities are account-agnostic.
- ✅ Import via file picker (`file_picker`, `.json` filter).
  **Destructive replace** with confirmation dialog ("Replace all
  data?"). On confirm:
  1. `BackupService.reassignIds()` — generates new unique IDs for
     every imported activity. IDs use a timestamp+random prefix
     (`i<ms><rand>_<index>`) to avoid primary key collisions with
     the exporter's cloud rows. Without this, Supabase would try
     to update the exporter's existing rows (same PK), but RLS
     (Row Level Security) blocks the write since the rows belong
     to a different user — the upsert fails silently.
     `calendarEventId` is also cleared since it references the
     exporter's device calendar.
  2. `ActivityDb.deleteAll()` — wipes all local SQLite data.
  3. Inserts imported activities into local DB.
  4. `plan.replaceAll(grouped)` — replaces in-memory data.
  5. **If signed in**: `SyncService.replaceAllCloud()` — deletes
     all of the user's cloud rows, then upserts the imported set
     (stamped with current `user_id`). This ensures stale cloud
     activities not in the import are removed.
  6. **If signed out**: `SyncService.clearOwner()` — resets the
     ownership tag to null. This way, the next sign-in hits the
     `LocalDataOwner.none` path and pushes the imported data to
     cloud instead of discarding it as "different user's data."
- ✅ Settings screen: "Export data" / "Import data" rows in a
  dedicated group between calendar sync and type colors.
- ✅ **Calendar sync on import**: if calendar sync is enabled, a
  "Sync to calendar?" dialog appears after import. If accepted,
  `CalendarService.syncImportedBatch()` iterates all imported
  activities, queries existing calendar events on each day, and
  skips any that already have a matching event (same title + start
  time). New events are created and their IDs are patched back
  onto the activities via `PlanController.patchCalendarEventIds()`.
  The snackbar reports how many were synced vs skipped.
- **Key invariant**: after import, local data is the source of
  truth. Cloud is either immediately replaced (signed in) or will
  be pushed on next sign-in (signed out). The ownership tag is
  always consistent with the imported state.

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

### Monetization — Kadence Pro (in progress)

Freemium model. Core app is fully usable for free; premium features
are gated behind a one-time or subscription purchase ("Kadence Pro").

#### Pricing tiers
- **Android**: Monthly €0.99, Annual €4.99, Lifetime €12.99
- **iOS**: Monthly €1.49, Annual €7.99, Lifetime €19.99
- iOS prices are higher because Apple users tend to spend more on
  apps, and Apple's 30% cut is steeper (15% via Small Business
  Program). Google also takes 30% (15% automatic on first $1M/yr).
- Prices can be increased in the future via App Store Connect /
  Google Play Console — existing subscribers keep their locked-in
  price, new subscribers see the new price.

#### Free features
- Core views (week, month, day detail)
- Basic stats: 3 KPIs, 26-week heatmap, type breakdown
- Export/import backup
- Calendar sync
- Weekly goals & progress rings (core motivational loop)
- Most stat widgets (see free/premium split below)

#### Premium features (5 pillars)
1. **Date filtering on stats** — filter all graphs and data by
   custom date range. Becomes very powerful with historical data.
2. **Advanced stats** — full-year heatmap, insights/nudges,
   shareable recap cards, weekly patterns (see premium stat widgets
   below).
3. **Cloud sync** — Supabase-backed. Peace of mind, cross-device.
4. **Custom colors** — custom type colors + theme color picker.
5. **Strava integration** — the killer feature. Two directions:
   - **Import history**: sync all past Strava activities into
     Kadence. Instantly populates the stats screen with years of
     data — heatmaps light up, streaks appear, insights become
     meaningful. This is the "wow" moment that justifies the
     purchase.
   - **Auto-mark done**: when a Strava activity is recorded,
     auto-mark the matching planned session as done (or create it
     if it wasn't planned).
   - **Write to Strava**: optionally send manual activities to
     Strava when marked done.

#### Free vs premium stat widget split
**Free stat widgets** (generous free tier to drive adoption):
- Personal records (best streak, best week, best day)
- Weekly activity chart (12-week bars)
- Best day of week (7 bars)
- Completion rate (arc ring)
- Monthly trends (12-month bars)
- Activity variety (types per week)
- Longest gap (break between sessions)
- Month vs month (current vs previous)
- Most consistent (top 5 types by completion)
- Year in review (annual summary)

**Premium stat widgets** (shine with historical/Strava data):
- Full-year heatmap — dramatically better with Strava import
- Insights / nudges — smarter with more history
- Shareable recap cards — social/vanity, impressive with real data
- Weekly patterns — power-user depth (type × weekday heatmap)

#### Paywall screen (done)
- ✅ `PaywallScreen` (`lib/screens/paywall/paywall_screen.dart`):
  back arrow + "Kadence Pro" title, 3 pricing tier cards
  (Monthly/Annual/Lifetime) with radio selection, restore purchase
  link, 6 feature rows with colored icons, "Continue" CTA pinned
  at bottom. Annual pre-selected.
- Purchase handlers are **stubbed** (`_handlePurchase` /
  `_restorePurchases`) — no real purchase infrastructure yet.
- Prices hardcoded as Android tier for now.
- Navigated to from the `_ProCard` widget in Settings.

#### Weekly goals (done)
- ✅ `GoalController` (`lib/state/goal_controller.dart`): simple
  ChangeNotifier persisting weekly goal to SharedPreferences key
  `kadence.weekly_goal`. Getter `goal` (int?), `hasGoal`,
  `setGoal(int?)` clamped 1–14.
- ✅ Registered as `ChangeNotifierProvider` in `main.dart`.
- ✅ Settings screen: "Weekly goal" row opens `_GoalPickerSheet`
  bottom sheet with options [Off, 2, 3, 4, 5, 6, 7].
- ✅ Week view: `_WeekSummaryCard` shows `_GoalRing` (44×44
  progress ring with percentage or check icon) when a goal is set.
  The main text always shows `done/planned` with "sessions done ·
  X% on track" below it. When a goal is set, a second smaller line
  appears underneath: `done/goal weekly goal`. The ring and the
  session count are intentionally separate — the ring tracks goal
  progress, the big text tracks actual planned sessions.

#### Pro stat widgets (done — visual review pending)
All live in `lib/screens/stats/widgets/` and use the shared
`ProStatCard` wrapper. Data comes from `StatsData`
(`lib/screens/stats/stats_data.dart`), a public class extracted
from the formerly private `_StatsData`.

Built widgets (11 chart-based + 3 experiential):
- `personal_records.dart` — best streak, best week, best day
- `weekly_activity_chart.dart` — Strava-style 12-week bar chart
- `best_day_of_week.dart` — 7 vertical bars for weekdays
- `completion_rate.dart` — arc ring with planned/done/missed
- `monthly_trends.dart` — 12-month bar chart
- `activity_variety.dart` — types per week (12 weeks)
- `longest_gap.dart` — longest break between sessions
- `month_vs_month.dart` — current vs previous month comparison
- `most_consistent.dart` — top 5 types by completion rate
- `weekly_patterns.dart` — mini heatmap per type (top 6 × 7 days)
- `year_in_review.dart` — annual summary card
- `full_year_heatmap.dart` — GitHub-style full-year heatmap,
  scrollable, color-coded by activity type
- `insights.dart` — up to 4 dynamic text insights from a pool of
  5 (favorite day, month trend, variety, streak, best month ever)
- `shareable_recap.dart` — monthly/yearly share cards with gradient
  accent header, motivational headline, top activity badge, stats
  grid with icons, mini heatmap strip, streak badge. Uses
  `RepaintBoundary` + `toImage` for PNG export via `share_plus`.
  Accent color resolved from `TypeColorController` so the card
  matches the user's chosen theme color.

All stat widgets currently appear below a "Pro Stats" divider in
`stats_view.dart`. They are **not gated yet** — visible to all
users. The free/premium split above is the plan; gating will be
implemented when purchase infrastructure is wired up.

#### TODO
- **TODO**: move free stat widgets above the "Pro Stats" divider
  (or remove the divider and only show locks on premium ones).
- **TODO**: add pro badges/locks on premium stat widgets and
  premium features (custom colors, cloud sync, date filtering)
  so free users see a preview with a lock icon + "Upgrade" tap.
- **TODO**: wire up purchase infrastructure (RevenueCat or
  `in_app_purchase`) to replace stubbed handlers in PaywallScreen.
- **TODO**: build `ProController` (or similar) that checks
  entitlements and gates premium features.
- **TODO**: implement date filtering UI for stats (date range
  picker that scopes all graphs to a custom period).
- **TODO**: build Strava integration — OAuth flow, history import,
  auto-mark done, optional write-back. Requires backend for
  secure token storage.
