# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Tincture Proto is a color-matching puzzle game built with Flutter, porting the original "Color Me Uncertain" JavaScript web game to mobile and desktop. Players match colored tiles (chroma phials) to a lead color in a distillation matrix, with alchemical theming throughout.

## Commands

### Development
```bash
# Install dependencies
flutter pub get

# Generate localization files (auto-runs with pub get)
flutter gen-l10n

# Generate mock files for tests
flutter pub run build_runner build --delete-conflicting-outputs

# Run the app
flutter run -d macos     # Desktop (macOS/windows/linux)
flutter run -d ios       # iOS simulator/device
flutter run -d android   # Android emulator/device
flutter run -d chrome    # Web browser
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/models/game_state_test.dart

# Run tests with coverage
flutter test --coverage
```

### Build
```bash
# Build for release
flutter build macos      # macOS app
flutter build ios        # iOS app
flutter build apk        # Android APK
flutter build web        # Web app
```

## Architecture

### State Management (Provider Pattern)
The app uses a single `GameState` class (`lib/models/game_state.dart`) that extends `ChangeNotifier` to manage all game state:
- Game mode/difficulty settings
- Tile generation and matching logic
- Points tracking (won/lost per round, total)
- Round progression and history
- UI colors (mainColor, bgColor, uiColor) - dynamically updated based on current lead tile
- Language preference (persisted via SharedPreferences)

The `GameState` is provided at the app root in `main.dart` and consumed by widgets via `Consumer<GameState>` or `Provider.of<GameState>()`.

### Color Generation System
`ColorGenerator` (`lib/services/color_gen.dart`) implements two color generation modes:
- **Prismatic**: Completely different hues (H: 0-360°, S: 20-100%, L: 40-60%)
- **Spectral**: Similar hues within a single color family (predefined hue ranges for red, yellow, green, cyan, blue, magenta)

Colors are generated in HSL space then converted to RGB via Flutter's `HSLColor.toColor()`. The generator also provides `getLighter()` and `getDarker()` utilities for creating background/UI colors.

### Difficulty System
`Difficulty` class (`lib/models/difficulty.dart`) uses factory pattern:
- **Apprentice**: 6 tiles, 2 points/tile, 150px tile size
- **Adept**: 8 tiles, 3 points/tile, 130px tile size
- **Alchemist**: 12 tiles, 4 points/tile, 105px tile size
- **Artifex**: 36 tiles, 1 point/tile, 45px tile size (unlocks at 100 total points)

Each difficulty level controls tile count, point value, and rendered tile size for responsive layout.

### Game Flow
1. User selects color mode (prismatic/spectral) and difficulty via `controls_panel.dart`
2. `GameState.startGame()` generates initial round via `_generateNewRound()`
3. Round generation creates tiles using `ColorGenerator`, then randomly selects one as the lead color
4. User taps tiles via `chroma_phial.dart` → triggers `GameState.onTileTap()`
5. On match: tile marked as matched, points added, new lead color selected
6. On wrong match: points deducted (if sufficient points exist)
7. Round completes when all tiles matched → `Round` object saved to history
8. `round_summary.dart` overlay shows round stats (points won/lost, time taken)
9. User proceeds to next round or resets game

### Internationalization (i18n)
- Supports English (en) and Portuguese (pt-BR)
- ARB files in `lib/l10n/` (app_en.arb, app_pt.arb)
- Generated `AppLocalizations` class used via `AppLocalizations.of(context)`
- Language preference persisted to SharedPreferences and loaded at app startup
- Language switched via `language_selector.dart` widget

### Feedback System
`FeedbackService` (`lib/services/feedback.dart`) is a singleton providing:
- Audio feedback via `audioplayers` package (correct.mp3, wrong.mp3)
- Haptic feedback via `vibration` package (different durations/amplitudes for correct vs wrong)
- Initialized in `main()` before app runs
- Called in widget layer when user taps tiles

### Single-Screen Architecture
The app uses a single screen (`home_scr.dart`) with state-based rendering:
- No navigation/routing (intentional design choice for learning focus)
- Overlays for modals: `instructions_modal.dart`, `round_summary.dart`
- All game flow via state changes in `GameState`
- Future versions may add multi-screen navigation for menus/settings

### Responsive Layout
- Uses `LayoutBuilder` to adapt to different screen sizes
- Tile sizes defined per difficulty level in `Difficulty.tileSize`
- `distillation_matrix.dart` uses `GridView` with dynamic cross-axis count
- Portrait-only orientation locked in `main.dart`

## Testing Strategy

The test suite uses `flutter_test` for unit/widget tests and `mockito` for mocking:
- **Unit tests**: Core logic in models and services (GameState, ColorGenerator, Difficulty, Round, Tile)
- **Widget tests**: Individual widgets (chroma_phial, controls_panel, distillation_matrix, etc.)
- **Mocks**: Generated via `build_runner` from `@GenerateMocks` annotations
- Test files mirror `lib/` structure in `test/` directory

When modifying mocked dependencies, regenerate mocks with:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Key Files

- `lib/main.dart`: App entry point, Provider setup, theme configuration, FeedbackService initialization
- `lib/models/game_state.dart`: Central state management, game logic, points/round tracking
- `lib/services/color_gen.dart`: Color generation algorithm (prismatic/spectral modes)
- `lib/services/feedback.dart`: Audio/haptic feedback singleton
- `lib/models/difficulty.dart`: Difficulty levels with factory pattern
- `lib/widgets/chroma_phial.dart`: Individual clickable tile with SVG icon variations
- `lib/widgets/distillation_matrix.dart`: Game board GridView layout
- `lib/widgets/controls_panel.dart`: Game controls sidebar (start, reset, mode/difficulty selection)
- `lib/l10n/*.arb`: Translation files for English and Portuguese

## Assets

### Fonts
- **Google Fonts**: IBM Plex Sans (body text) - loaded via `google_fonts` package
- **Custom fonts**:
  - Optima (headers, app bar) - `assets/fonts/Optima/Optima-Bold.otf`
  - OCR (UI elements) - `assets/fonts/OCR/OCR-Regular.otf`

### Icons
SVG tile icons in `assets/icons/`:
- bottle_a.svg, bottle_b.svg
- conical_a.svg, conical_b.svg
- rounded_a.svg, rounded_b.svg

Randomly selected per tile for visual variety.

### Sounds
Audio assets in `assets/sounds/`:
- correct.mp3: Correct match feedback
- wrong.mp3: Wrong match feedback
- tap_a.mp3, tap_b.mp3: Tap sounds (not yet implemented)

## Known Issues

- Artifex unlock condition placement (currently triggers on wrong answer instead of at 100 points achievement)
- Minor rendering bugs
- Some UI/UX refinements needed

## Development Notes

- The app locks to portrait orientation (`main.dart` sets `DeviceOrientation.portraitUp/Down`)
- Theme colors (scaffold background, app bar, buttons) dynamically update based on `GameState.bgColor/mainColor/uiColor`
- `GameState` can be injected with `SharedPreferences` for testing (constructor parameter)
- Round history stored in `Map<int, Round>` keyed by round number
- Time tracking starts at `_generateNewRound()` and completes in `_finishRound()`
