# Smart Travel Companion

Flutter advanced application for the SMD final assignment.

## What It Does

- Fetches place data from `jsonplaceholder.typicode.com/photos`
- Fetches live weather from `api.open-meteo.com`
- Shows a responsive home feed, detail page, favorites page, settings, and admin dashboard
- Supports offline cache, pull-to-refresh, search debounce, filters, and animated transitions
- Uses Riverpod for structured state management and GoRouter for named navigation
- Includes a web admin panel and a mobile admin area in the same codebase

## Branch Workflow

- `development` for active feature work
- `staging` for validation and pre-release checks
- `main` for the release-ready version

Recommended flow:

1. Build in `development`
2. Merge into `staging` for final verification
3. Merge into `main` for submission

## Screens

- Home
- Detail
- Favorites
- Settings
- Admin dashboard
- Offline and empty/error states

## Architecture

- Presentation: feature-based screens and reusable widgets
- State: Riverpod `StateNotifier` controllers
- Data: repository layer with HTTP clients and Hive cache
- Routing: GoRouter with named routes and complex object passing
- Theming: light and dark custom themes

## Testing

Run the test suite:

```bash
flutter test
```

Run static analysis:

```bash
flutter analyze
```

## Run Locally

```bash
flutter pub get
flutter run
```

Web admin panel:

```bash
flutter run -d chrome
```

## Build

APK:

```bash
flutter build apk --release
```

Local APK path after a release build:

```text
D:\fahad\SMD_flutter_project\build\app\outputs\flutter-apk\app-release.apk
```

Web build:

```bash
flutter build web --release
```

## Demo Video

Suggested short demo flow:

1. Open the app and show the branded splash screen.
2. Walk through the home screen, search, filters, refresh, and favorites.
3. Open a place detail page to show hero animation, weather, expandable text, and map launch.
4. Switch to offline or empty preview mode from the admin panel to show error handling and cached data.
5. Open the settings screen and show dark mode, preview mode, and cache controls.
6. End by showing the admin dashboard with metrics and activity logs.

Suggested length: 60 to 90 seconds.

## Submission Checklist

- Flutter source code pushed to GitHub
- APK file uploaded to Classroom
- DOCX project summary uploaded to Classroom
- README kept in the repo for setup and grading context

## Notes

- The app uses cached data when the network is unavailable.
- Admin preview mode can simulate live, empty, offline, and error states.
- Maps integration opens the selected destination in external maps.
- A demo video and release APK can be added to the repository or release artifacts before submission.
