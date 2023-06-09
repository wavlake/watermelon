# watermelon

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Trouble running on an iOS simulator or test device?

Try these steps before debugging:
```bash
flutter clean
flutter pub get
cd ios
rm -rf Pods/
pod install
```

## Build an Android release

First follow these steps to setup a keystore/signing files https://docs.flutter.dev/deployment/android, you should only need to do this step once.

1. Update the `version` value in the project's `pubspec.yaml` file. St the very least, increment the `versionCode` by one.
    1. This will result in the `versionName` and `versionCode` being updated in `android/local.properties`.
    1. `versionName` is the version shown to users, while `versionCode` is "a positive integer used as an internal version number. This number helps determine whether one version is more recent than another, with higher numbers indicating more recent versions."
    1. In `pubspec.yaml`, `version: 1.0.4+21` would translate to `versionName=1.0.4` and `versionCode=21`.
1. Run the build command, which will produce a build here `build/app/outputs/bundle/release/app-release.aab`

    ```bash
    flutter build appbundle
    ```

1. Upload the build to the App bundle explorer in [Google Play Console](https://play.google.com/console)
