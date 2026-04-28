# Kadence

A minimalist Flutter mobile app for planning weekly sports activities.

Calm, focused, and motivating — Kadence lets you plan, track, and
reflect on your week of training without the noise of a full fitness
tracker.

## Features

- **Weekly planner** with day cards (name, type, duration, intensity,
  notes)
- **Month overview** with a 7-column grid and selectable day detail
- **Day detail sheet** to add / edit / mark done / rest
- **Onboarding** — sport, training days, notifications (5 steps)
- **Light & dark mode** with a true theme swap
- **Status indicators** that don't rely on color alone (dot / ring /
  dash / accent square) for accessibility

## Tech stack

- Flutter ≥ 3.27 / Dart ≥ 3.5
- Material 3 + custom `ThemeExtension`
- `provider` for state
- `shared_preferences` for persistence
- `google_fonts` (Sora)
- `lucide_icons_flutter` for icons

## Getting started

### 1. Install Flutter

Flutter isn't bundled with the repo — install it from
<https://docs.flutter.dev/get-started/install>. Version ≥ 3.27 is
required.

Verify with:

```bash
flutter --version
flutter doctor
```

### 2. Generate platform folders (first time only)

The repo contains only the Dart source — no `ios/` or `android/`
folders yet. Generate them in place:

```bash
cd /Users/raphaeltomaz/Documents/Projects/sportsapp
flutter create . --platforms=ios,android
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run

All commands run from the project root:

```bash
cd /Users/raphaeltomaz/Documents/Projects/sportsapp
flutter devices          # list currently detected devices
flutter run              # picks the only device, or prompts if several
```

To target a specific device, pass `-d <id>` (the ID comes from
`flutter devices`) or one of the aliases below.

#### Web (Chrome)

No extra setup. Opens a new Chrome window.

```bash
flutter run -d chrome
```

#### macOS desktop

No extra setup. Opens as a native Mac window.

```bash
flutter run -d macos
```

#### iOS Simulator

Requires the full Xcode app (App Store, ~10 GB) and CocoaPods.

```bash
# one-time setup
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
brew install cocoapods

# open a simulator, then run
open -a Simulator
flutter run                 # or: flutter run -d "iPhone 15"
```

#### iOS physical device

Same Xcode + CocoaPods setup as above. Additionally:

1. Plug the iPhone into the Mac via USB.
2. On the phone, **Trust This Computer** when prompted.
3. Open `ios/Runner.xcworkspace` in Xcode once and set a signing team
   (**Runner target → Signing & Capabilities → Team**).
4. `flutter run` — Flutter picks up the device.

Free Apple IDs work but the app expires after 7 days.

#### Android emulator

Requires Android Studio (or at least the Android SDK + an AVD).

1. Open Android Studio → **Device Manager** → create a virtual device.
2. Start the emulator (play button in Device Manager).
3. Then:

```bash
flutter emulators            # lists configured emulators
flutter run                  # picks the running emulator
```

#### Android physical device

1. **Enable Developer Options** on the phone: Settings → About phone →
   tap *Build number* 7 times.
2. **Enable USB debugging**: Settings → Developer options → USB
   debugging → ON.
3. On Samsung phones, **turn off Auto Blocker** (Settings → Security
   and privacy → Auto Blocker) — it blocks USB debugging by default.
4. Plug the phone into the Mac via USB.
5. When the phone asks "Allow USB debugging from this computer?" tap
   **Allow** (tick "Always allow").
6. Verify and run:

```bash
flutter devices              # your phone should appear
flutter run                  # builds APK, installs, launches
```

First build is slow (downloads Gradle, NDK, dependencies). Subsequent
runs use hot reload — press `r` in the terminal to rebuild in place,
`R` for a full restart, `q` to quit.

### 5. Test

```bash
flutter test
flutter analyze
```

## Project layout

```
lib/
  main.dart               # Entry point, sets up providers
  app.dart                # MaterialApp + onboarding gate
  theme/                  # Design tokens (colors, spacing, text)
  models/                 # Activity + enums
  state/                  # Provider controllers
  utils/                  # Date helpers + TodayScope
  widgets/                # Shared UI primitives (KButton, KTopBar…)
  screens/
    onboarding/           # 5-step onboarding
    home/                 # Scaffold with bottom nav
    week/                 # Week view
    month/                # Month view
    day_detail/           # Bottom sheet editor
    empty/                # Empty state
    settings/             # Settings
```

See [`CLAUDE.md`](./CLAUDE.md) for internal conventions and gotchas.

## Data persistence

Currently, only theme preference and onboarding completion are
persisted (via `shared_preferences`). Activity data is seeded
in-memory in `PlanController._seed()` — swap for a real backend or
local DB (Isar, Drift, SQLite) when ready.

## License

Private / unpublished.
