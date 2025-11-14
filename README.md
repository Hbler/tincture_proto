# Tincture Proto

A color matching puzzle game built with Flutter - a port and evolution of the original "Color Me Uncertain" JavaScript web game to mobile and desktop platforms.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat&logo=dart&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green)

## 📱 About

**Tincture Proto** is a fast-paced color matching game where players must identify which tile matches the lead color displayed. With multiple difficulty levels and game modes, it challenges both perception and speed. The name "Tincture" refers to the alchemical concept of color essence, fitting the game's mystical theme and progression system.

### Original Version
This Flutter implementation is a port and thematic evolution of the [original web-based game "Color Me Uncertain"](https://github.com/hbler/color-me-uncertain) built with vanilla JavaScript, HTML, and CSS.

## 🎮 Gameplay

1. **Select your preferences:**
   - **Color Mode:** Prismatic (completely different colors) or Spectral (similar hues)
   - **Difficulty:** Apprentice (6 tiles), Adept (8 tiles), Alchemist (12 tiles), or Artifex (36 tiles - unlocks at 100 points)

2. **Start the game** and a lead color will be displayed

3. **Click the matching tile** from the distillation matrix
   - Correct match: Earn points and the chroma phial disappears
   - Wrong match: Lose points

4. **Complete the round** by matching all tiles

5. **Progress through rounds** and watch your score climb!

## ✨ Features

### Core Gameplay
- ✅ **4 Difficulty Levels** - From apprentice to artifex challenge
- ✅ **2 Color Modes** - Prismatic colors or spectral variations
- ✅ **Progressive Difficulty** - Unlock Artifex mode at 100 points
- ✅ **Round System** - Track your progress through multiple rounds
- ✅ **Score Tracking** - Points won, points lost, and time taken per round

### Technical Features
- ✅ **Bilingual Support** - English and Portuguese (PT-BR) with in-app language switching
- ✅ **Persistent Language Preference** - Uses SharedPreferences to remember language choice
- ✅ **Responsive Design** - Adapts to desktop, tablet, and mobile screens
- ✅ **State Management** - Using Provider for reactive UI
- ✅ **Custom Typography** - Google Fonts (IBM Plex Sans) + Custom fonts (Optima, OCR A)
- ✅ **Dynamic Theming** - Background and UI colors change with the game
- ✅ **Smooth Animations** - Fade transitions and responsive interactions

### Thematic Elements
- **Chroma Phials** - Color tiles represented as alchemical vessels
- **Distillation Matrix** - The game board where colors are matched
- **Lead Color** - The target color to match (alchemical transformation concept)
- **Progression Titles** - Apprentice → Adept → Alchemist → Artifex

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                      # App entry point
├── l10n/                          # Internationalization
│   ├── app_en.arb                # English translations
│   ├── app_pt.arb                # Portuguese translations
│   └── app_localizations.dart    # Generated localization class
├── models/                        # Data models
│   ├── difficulty.dart           # Difficulty levels and settings
│   ├── tile.dart                 # Game tile model
│   ├── round.dart                # Round tracking and summaries
│   └── game_state.dart           # Main game state (Provider)
├── services/                      # Business logic
│   └── color_gen.dart            # Color generation algorithms
├── screens/                       # UI screens
│   └── home_scr.dart             # Main game screen
└── widgets/                       # Reusable components
    ├── controls_panel.dart       # Game controls sidebar
    ├── distillation_matrix.dart  # Game board layout
    ├── chroma_phial.dart         # Individual clickable tile
    ├── lead_color.dart           # Main color indicator
    ├── instructions_modal.dart   # Instructions dialog
    ├── round_summary.dart        # Round completion overlay
    └── language_selector.dart    # Language switcher widget
```

### Design Patterns
- **Provider** - State management with `ChangeNotifier`
- **Factory Pattern** - Difficulty level instantiation
- **Responsive Layout** - `LayoutBuilder` for adaptive UI
- **Separation of Concerns** - Models, Services, UI layers
- **Single Screen Architecture** - Game flow via state changes and overlays
- **Persistent Storage** - SharedPreferences for language preference

## 🛠️ Tech Stack

- **Flutter 3.8+** - UI framework
- **Dart 3.8+** - Programming language
- **Provider 6.1+** - State management
- **Google Fonts 6.3+** - Typography (IBM Plex Sans)
- **Flutter Intl 0.20+** - Internationalization (i18n)
- **SharedPreferences 2.5+** - Local data persistence
- **Custom Fonts** - Optima (headers), OCR A (UI elements)

## 📦 Getting Started

### Prerequisites
- Flutter SDK 3.8 or higher
- Dart SDK 3.8 or higher

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/tincture-proto.git
   cd tincture-proto
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate localization files**
   ```bash
   flutter gen-l10n
   ```
   (This usually happens automatically with `pub get`)

4. **Run the app**
   ```bash
   # Desktop
   flutter run -d macos   # or windows, linux
   
   # Mobile
   flutter run -d ios     # or android
   
   # Web
   flutter run -d chrome
   ```

## 🎯 Development Status

### ✅ Completed
- Core game mechanics and logic
- All difficulty levels (Apprentice, Adept, Alchemist, Artifex)
- Both color modes (Prismatic, Spectral)
- Round system with time tracking
- Points system (winning/losing)
- Bilingual support (EN/PT-BR)
- Persistent language preference
- Responsive layout (desktop + mobile)
- Instructions modal
- Round summary overlay
- Language switching
- Thematic rebranding and terminology
- Custom typography integration
- Sound effects (correct/wrong feedback)
- Haptic feedback

### 🚧 Known Issues
- Some rendering bugs to be addressed
- Minor UI/UX refinements needed

### 📋 Roadmap
- [ ] Fix rendering issues
- [ ] Implement persistent high scores
- [ ] Add statistics/leaderboard screen
- [ ] Add welcome/menu screen with navigation
- [ ] Add settings screen
- [ ] Implement ads integration
- [ ] Add in-app purchases/micro-transactions
- [ ] Add social sharing features
- [ ] Add achievements system
- [ ] Implement daily challenges
- [ ] Publish to App Store and Google Play

## 🎨 Thematic Design

The game employs an alchemical theme throughout:

- **Tincture** - An alchemical term for a colored solution or essence
- **Chroma Phials** - The colored tiles represented as alchemical vessels
- **Distillation Matrix** - The game board where color essences are refined
- **Lead Color** - The base color to transmute (matching alchemical transformation)
- **Progression System** - Apprentice → Adept → Alchemist → Artifex (master craftsman)
- **Color Modes** - Prismatic (refracted light) vs Spectral (a segment of the color spectrum)

## 🎓 Learning Objectives

This project was developed as a learning exercise to master:
- Flutter state management (Provider pattern)
- Responsive UI design with `LayoutBuilder`
- Flutter internationalization (intl package)
- Local data persistence (SharedPreferences)
- Color manipulation and HSL color space
- Game loop and state transitions
- Cross-platform development
- Custom font integration
- Thematic UI/UX design

The single-screen architecture was chosen intentionally to focus on state management before adding navigation complexity in future iterations.

## 🤝 Contributing

This is a learning project, but suggestions and feedback are welcome! Feel free to:
- Report bugs via GitHub Issues
- Suggest features or improvements
- Submit pull requests

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👤 Author

**Hugo Bler**
- LinkedIn: [@hbler](https://www.linkedin.com/in/hbler/)
- GitHub: [@hbler](https://github.com/hbler)

## 🙏 Acknowledgments

- Original web version: [Color Me Uncertain](https://github.com/hbler/color-me-uncertain)
- HSL to RGB conversion algorithm from [Axon Flux](http://axonflux.com/handy-rgb-to-hsl-and-rgb-to-hsv-color-model-c) (in original web version)
- Flutter community for excellent documentation and examples
- Alchemical terminology inspiration for thematic elements

---

**Note:** This is an active development project. The game is playable but still being refined and enhanced. The "Proto" designation indicates this is a prototype for a more evolved version with additional features and monetization. Check back for updates!