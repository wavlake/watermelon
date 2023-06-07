import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'model/constants.dart';
import 'screens/signing_screen.dart';
import 'screens/userProfile/user_profile_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/loading_screen.dart';
import 'model/state.dart';

void main() async {
  // init local storage, used by AppState provider
  await GetStorage.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AppState(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'dispute',
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  @override
  State<_MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var appState = context.watch<AppState>();

    Widget page;
    switch (appState.currentScreen) {
      case Screen.welcome:
        page = const WelcomeScreen();
        break;
      case Screen.userProfile:
        page = const UserProfileScreen();
        break;
      case Screen.signing:
        page = const SigningScreen();
        break;
      case Screen.scanner:
        page = const ScannerScreen();
        break;
      case Screen.loading:
        page = const LoadingScreen();
        break;
      default:
        throw UnimplementedError('no widget for ${appState.currentScreen}');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
    var mainArea = ColoredBox(
      color: colorScheme.surfaceVariant,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: page,
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SafeArea(child: mainArea);
        },
      ),
    );
  }
}
