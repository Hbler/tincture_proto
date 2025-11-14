import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tincture_proto/l10n/app_localizations.dart';
import 'package:tincture_proto/models/game_state.dart';
import 'package:tincture_proto/screens/home_scr.dart';
import 'package:tincture_proto/services/feedback.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await FeedbackService().initialize();

  runApp(const TinctureProtoApp());
}

class TinctureProtoApp extends StatelessWidget {
  const TinctureProtoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameState(),
      child: Consumer<GameState>(
        builder: (context, gameState, _) {
          return MaterialApp(
            title: 'Tincture Proto',
            debugShowCheckedModeBanner: false,

            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('en'), Locale('pt')],
            locale: gameState.currentLocale,

            theme: ThemeData(
              useMaterial3: true,
              // bg from game state
              scaffoldBackgroundColor: gameState.bgColor,
              // typography w/ google fonts
              textTheme: GoogleFonts.ibmPlexSansTextTheme(
                Theme.of(context).textTheme,
              ),
              // primary color from game state
              colorScheme: ColorScheme.fromSeed(
                seedColor: gameState.mainColor,
                brightness: Brightness.light,
              ),
              // app bar theme
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                elevation: 0,
                titleTextStyle: TextStyle(
                  fontFamily: 'Optima',
                  fontSize: 36,
                  color: Colors.white,
                ),
              ),
              // button theme
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            home: const HomeScreen(), // not yet implemented;
          );
        },
      ),
    );
  }
}
