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

Web build:

```bash
flutter build web --release
```

## Notes

- The app uses cached data when the network is unavailable.
- Admin preview mode can simulate live, empty, offline, and error states.
- Maps integration opens the selected destination in external maps.
- A demo video and release APK can be added to the repository or release artifacts before submission.
