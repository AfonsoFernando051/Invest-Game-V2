# Petrimonium

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Configuring the backend URL

`ApiConstants.baseUrl` (`lib/core/constants/api_constants.dart`) defaults to
`http://localhost:8081`, which works for the iOS Simulator and Flutter Web but
**not** the Android emulator (which needs `10.0.2.2` to reach your machine's
localhost). Override it per run/build with `--dart-define` instead of editing
source:

```sh
# Android emulator, pointing at a locally running backend
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8081

# Pointing at a staging/prod deployment
flutter build apk --dart-define=API_BASE_URL=https://api.example.com
```

## Linux desktop builds

`flutter_secure_storage` (used to store the auth token) needs the system
package `libsecret-1` to build its Linux desktop backend — it isn't bundled
with the Flutter SDK. Android/iOS/Web builds are unaffected; this is only
needed if you're building/running the `linux` target locally:

```sh
sudo apt-get install libsecret-1-dev
```
