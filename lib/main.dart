import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_storage/get_storage.dart';
import '/screens/userProfile/add_user_profile_screen.dart';
import 'screens/userProfile/edit_profile_screen.dart';
import 'screens/userProfile/profile_picker.dart';
import 'model/constants.dart';
import 'screens/signing_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/scanner_screen.dart';
import 'screens/loading_screen.dart';
import 'model/state.dart';
import 'package:flutter/services.dart'; // For `SystemChrome`

// https://dartling.dev/toggle-full-screen-mode-in-flutter#heading-types-of-full-screen-modes
void enterFullScreen() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

// this is not used
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
      theme: ThemeData(
        // Define the default brightness and colors.
        primaryColor: WavlakeColors.orange,
        secondaryHeaderColor: WavlakeColors.mint,
        cardColor: WavlakeColors.orange,
        buttonTheme: const ButtonThemeData(
          buttonColor: WavlakeColors.mint,
          textTheme: ButtonTextTheme.normal,
        ),
        splashColor: WavlakeColors.mint,
        // Define the default font family.
        fontFamily: 'Poppins',
        colorScheme: const ColorScheme.dark(
          primary: WavlakeColors.pink,
          secondary: WavlakeColors.mint,
          background: WavlakeColors.black,
          surface: WavlakeColors.black,
          onPrimary: WavlakeColors.black,
          onSecondary: WavlakeColors.black,
          onBackground: WavlakeColors.black,
          onSurface: WavlakeColors.black,
        ),
        inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: WavlakeColors.purple)),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: WavlakeColors.pink))),
        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: const TextTheme(
          displayLarge: TextStyle(
              fontSize: 72.0,
              fontWeight: FontWeight.bold,
              color: WavlakeColors.mint),
          titleLarge: TextStyle(
              fontSize: 36.0,
              fontStyle: FontStyle.italic,
              color: WavlakeColors.orange),
          bodyMedium: TextStyle(
              fontSize: 14.0, fontFamily: 'Hind', color: WavlakeColors.pink),
        ),
      ),
      debugShowCheckedModeBanner: false,
      title: 'watermelon',
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  @override
  State<_MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  bool showProfilePicker = false;

  void closeProfilePicker() {
    setState(() {
      showProfilePicker = false;
    });
  }

  void openProfilePicker() {
    setState(() {
      showProfilePicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var appState = context.watch<AppState>();

    bool shouldShowProfilePicker = showProfilePicker &&
        shouldShowProfileSwitchButton[appState.currentScreen]!;

    Widget page;
    switch (appState.currentScreen) {
      case Screen.welcome:
        page = const WelcomeScreen();
        break;
      case Screen.addUserProfile:
        page = AddUserProfileScreen(
          closeProfilePicker: closeProfilePicker,
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
      case Screen.editUserProfile:
        page = const EditProfileScreen();
        break;
      default:
        throw UnimplementedError('no widget for ${appState.currentScreen}');
    }

    return Scaffold(
      backgroundColor: WavlakeColors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // This is the main parent widget of each screen
              SafeArea(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // page is a dynamic widget that changes based on currentScreen
                      page,
                      // Should this screen show the switch profile button?
                      ...shouldShowProfileSwitchButton[appState.currentScreen]!
                          ? [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 20.0),
                                child: TextButton(
                                    onPressed: () {
                                      openProfilePicker();
                                    },
                                    child: const Text("Switch profile")),
                              )
                            ]
                          : [],
                    ],
                  ),
                ),
              ),
              // The stack widget lets us display the profile picker on top of the page widget
              // if showProfilePicker is true, we spread the contents of the array below "...[]"
              if (shouldShowProfilePicker) ...[
                // This is the dark overlay that covers the page when the profile picker is open
                Opacity(
                  opacity: 0.4,
                  child: InkWell(
                    onTap: closeProfilePicker,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration:
                          const BoxDecoration(color: WavlakeColors.black),
                    ),
                  ),
                ),
                // this is the profile picker shown at the bottom of the screen
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: WavlakeColors.lightBlack,
                            border: Border(
                                top: BorderSide(
                                    color: colorScheme.secondary, width: 2.0))),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: SafeArea(
                            child: ProfilePicker(
                              closeProfilePicker: closeProfilePicker,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
