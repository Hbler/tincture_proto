import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Tincture Proto'**
  String get appTitle;

  /// Instructions header
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @instructionsColorMode.
  ///
  /// In en, this message translates to:
  /// **'Choose the color mode:'**
  String get instructionsColorMode;

  /// No description provided for @instructionsColorModePrismatic.
  ///
  /// In en, this message translates to:
  /// **'prismatic (aleatory colors) or'**
  String get instructionsColorModePrismatic;

  /// No description provided for @instructionsColorModeSpectral.
  ///
  /// In en, this message translates to:
  /// **'spectral (similar colors);'**
  String get instructionsColorModeSpectral;

  /// No description provided for @instructionsDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Choose the difficulty:'**
  String get instructionsDifficulty;

  /// No description provided for @instructionsDifficultyApprentice.
  ///
  /// In en, this message translates to:
  /// **'apprentice (6 tiles),'**
  String get instructionsDifficultyApprentice;

  /// No description provided for @instructionsDifficultyAdept.
  ///
  /// In en, this message translates to:
  /// **'adept (8 tiles),'**
  String get instructionsDifficultyAdept;

  /// No description provided for @instructionsDifficultyAlchemist.
  ///
  /// In en, this message translates to:
  /// **'alchemist (12 tiles)...'**
  String get instructionsDifficultyAlchemist;

  /// No description provided for @instructionsStart.
  ///
  /// In en, this message translates to:
  /// **'And finally start a game and find, among the tiles on the board, the color that matches the main one! Things might get a bit... extreme, if you get enough points'**
  String get instructionsStart;

  /// Color mode selection label
  ///
  /// In en, this message translates to:
  /// **'Color Mode'**
  String get colorMode;

  /// Difficulty selection label
  ///
  /// In en, this message translates to:
  /// **'Choose Difficulty'**
  String get chooseDifficulty;

  /// Apprentice difficulty level
  ///
  /// In en, this message translates to:
  /// **'Apprentice'**
  String get difficultyApprentice;

  /// Adept difficulty level
  ///
  /// In en, this message translates to:
  /// **'Adept'**
  String get difficultyAdept;

  /// Alchemist difficulty level
  ///
  /// In en, this message translates to:
  /// **'Alchemist'**
  String get difficultyAlchemist;

  /// Artifex difficulty level
  ///
  /// In en, this message translates to:
  /// **'Artifex'**
  String get difficultyArtifex;

  /// Prismatic color mode
  ///
  /// In en, this message translates to:
  /// **'Prismatic (random)'**
  String get colorModePrismatic;

  /// Spectral color mode
  ///
  /// In en, this message translates to:
  /// **'Spectral (mono)'**
  String get colorModeSpectral;

  /// Button to start the game
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// Button to start a new game
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// Button to proceed to next round
  ///
  /// In en, this message translates to:
  /// **'Next Round'**
  String get nextRound;

  /// Button to reset the game
  ///
  /// In en, this message translates to:
  /// **'Reset Game'**
  String get resetGame;

  /// Points label
  ///
  /// In en, this message translates to:
  /// **'Points'**
  String get points;

  /// Round label
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get round;

  /// Round summary section title
  ///
  /// In en, this message translates to:
  /// **'Round Summary:'**
  String get roundSummaryTitle;

  /// End of round message
  ///
  /// In en, this message translates to:
  /// **'End of Round {roundNumber}'**
  String endOfRound(String roundNumber);

  /// Current score display
  ///
  /// In en, this message translates to:
  /// **'Current Score: {points} Points'**
  String currentScore(int points);

  /// Points won in round
  ///
  /// In en, this message translates to:
  /// **'Points Won: {points}'**
  String pointsWon(int points);

  /// Points lost in round
  ///
  /// In en, this message translates to:
  /// **'Points Lost: {points}'**
  String pointsLost(int points);

  /// Time taken to complete round
  ///
  /// In en, this message translates to:
  /// **'You took {time} to finish it.'**
  String timeTaken(String time);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
