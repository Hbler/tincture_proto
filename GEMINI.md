# Project: Tincture Proto

## Project Overview

Tincture Proto is a color-matching puzzle game built with Flutter. It is a port and evolution of the original JavaScript web game "Color Me Uncertain". The game challenges players to identify which tile matches a lead color, with multiple difficulty levels and game modes. The game has an alchemical theme.

The application is structured with a clear separation of concerns, using a single-screen architecture that relies on state changes and overlays for game flow. It supports English and Portuguese languages and persists the user's language preference.

## Building and Running

To build and run this project, you need to have the Flutter SDK (3.8 or higher) and Dart SDK (3.8 or higher) installed.

1.  **Clone the repository:**
    ```bash
    git clone <repository-url>
    cd tincture_proto
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Generate localization files:**
    ```bash
    flutter gen-l10n
    ```

4.  **Run the app:**
    *   **Desktop:** `flutter run -d macos` (or `windows`, `linux`)
    *   **Mobile:** `flutter run -d ios` (or `android`)
    *   **Web:** `flutter run -d chrome`

5.  **Run Tests:**
    ```bash
    flutter test
    ```

## Development Conventions

*   **State Management:** The project uses the `provider` package for state management. The core game logic and state are managed in the `GameState` class, which is a `ChangeNotifier`.
*   **Internationalization (i18n):** The app supports English and Portuguese. Translations are managed using the `flutter_localizations` and `intl` packages. The localization files are in `lib/l10n`.
*   **Persistence:** The `shared_preferences` package is used to store the user's language preference locally.
*   **Styling:** The app uses a combination of Google Fonts (`IBM Plex Sans`) and custom fonts (`Optima`, `OCR`). The theme is dynamic, with colors changing based on the game state.
*   **Architecture:** The project follows a clean architecture with a clear separation of concerns:
    *   `lib/models`: Contains the data models for the application (`GameState`, `Difficulty`, `Round`, `Tile`).
    *   `lib/screens`: Contains the UI screens of the application (`home_scr.dart`).
    *   `lib/services`: Contains the business logic, such as the color generation algorithm (`color_gen.dart`).
    *   `lib/widgets`: Contains reusable UI components.
*   **Testing:** The project uses a combination of unit and widget tests to ensure code quality.
    *   **Tools:** The `flutter_test` package is used for writing tests, and `mockito` is used for creating mock objects for dependencies. The `build_runner` package is used to generate the mock files.
    *   **Strategy:**
        *   **Unit Tests:** Used for testing individual classes and functions in the `lib/models` and `lib/services` directories.
        *   **Widget Tests:** Used for testing individual widgets in the `lib/widgets` and `lib/screens` directories.
    *   **Location:** All test files are located in the `test` directory, mirroring the structure of the `lib` directory.
    *   **Running Tests:** To run all tests, use the `flutter test` command. To run a specific test file, use `flutter test <path_to_test_file>`.
    *   **Mocks:** To generate mock files after adding or changing mocks, run `flutter pub run build_runner build --delete-conflicting-outputs`.
