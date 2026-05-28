# Running Kadence locally

## Prerequisites

- Flutter >= 3.27 / Dart >= 3.5
- A `.env` file at the project root with Supabase credentials (gitignored)

## First-time setup

```bash
flutter pub get
flutter create . --platforms=ios,android   # generates ios/ and android/ folders
```

## Running the app

The shell alias `fr` is defined in `~/.zshrc`:

```bash
alias fr='flutter run --dart-define-from-file=.env'
```

After adding or changing the alias, reload your shell:

```bash
source ~/.zshrc
```

### Default device

```bash
fr
```

If only one device is connected, Flutter picks it automatically. If multiple are connected, it will prompt you to choose.

### Specific device

List available devices first:

```bash
flutter devices
```

Then pass the device ID:

```bash
fr -d <device-id>
```

Examples:

```bash
fr -d iPhone\ 16          # iOS simulator by name
fr -d 00008110-XXXX       # physical iPhone by UDID
fr -d emulator-5554       # Android emulator
fr -d macos               # macOS desktop
fr -d chrome              # web (note: no SQLite persistence on web)
```

### Hot reload vs hot restart

- Press `r` in the terminal for **hot reload** (preserves state).
- Press `R` for **hot restart** (resets state). Required after changing const class constructor shapes.
