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

## Submission Checklist

- Flutter source code pushed to GitHub
- Branches kept in sync across `development`, `staging`, and `main`
- APK file uploaded to Classroom
- DOCX project summary uploaded to Classroom
- README kept in the repo for setup, grading context, and build instructions
- Release APK built from the project on this machine

## Project Overview

Smart Travel Companion is a Flutter application built for the SMD final assignment. It combines a responsive travel-style interface with live data, local caching, animated transitions, and structured state management.

The app focuses on:

- Clean feature-based architecture
- Riverpod state management
- GoRouter navigation with complex arguments
- Offline support through local caching
- API-driven UI with friendly loading, empty, and error states
- A consistent mobile and web experience

## API Sources

- `https://jsonplaceholder.typicode.com/photos`
- `https://api.open-meteo.com/v1/forecast`

## Key Features

- Home feed with images, favorites, filters, search, and pull-to-refresh
- Detail page with hero animation, weather data, expandable description, and map launch
- Favorites view for saved places
- Settings for theme and preview behavior
- Admin dashboard for testing app states and reviewing usage data
- Responsive layouts for mobile, tablet, and web
- Dark mode support

## Notes

- The app uses cached data when the network is unavailable.
- Admin preview mode can simulate live, empty, offline, and error states.
- Maps integration opens the selected destination in external maps.
- The release APK is available locally at `D:\fahad\SMD_flutter_project\build\app\outputs\flutter-apk\app-release.apk`
