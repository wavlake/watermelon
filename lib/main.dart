import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import 'package:watermelon/screens/add_user_profile_screen.dart';
import 'layout_wrapper.dart';
import 'model/constants.dart';
import 'screens/signing_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/loading_screen.dart';
import 'model/state.dart';
import 'package:flutter/services.dart'; // For `SystemChrome`

void enterFullScreen() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

void exitFullScreen() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: SystemUiOverlay.values);
}

void main() async {
  // init local storage, used by AppState provider
  await GetStorage.init();
  enterFullScreen();
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
      theme: ThemeData(primarySwatch: Colors.pink, fontFamily: 'Roboto'),
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
    var appState = context.watch<AppState>();

    Widget page;
    switch (appState.currentScreen) {
      case Screen.welcome:
        page = const WelcomeScreen();
        break;
      case Screen.addUserProfile:
        page = AddUserProfileScreen(
          appState: appState,
        );
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

    return LayoutWrapper(page: page);
  }
}
