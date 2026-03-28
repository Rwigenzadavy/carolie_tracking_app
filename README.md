# Calorie Tracking App

Flutter mobile application for a culturally relevant calorie-tracking experience.

## Current Scope

The repository currently includes:

- Home screen
- Log meal screen
- Login screen
- Signup screen
- Shared bottom navigation
- Widget tests for the implemented calorie-tracking screens

## Tech Stack

- Flutter
- Dart
- Firebase packages included for backend integration
- iOS and macOS CocoaPods configuration

## Setup

1. Install Flutter and confirm it is on your path.
2. Run `flutter pub get`.
3. Open an emulator or connect a physical device.
4. Start the app with `flutter run`.

## Quality Checks

Run these before committing:

- `dart format .`
- `flutter analyze`
- `flutter test`

## Project Structure

- `lib/main.dart`: app entry point
- `lib/src/app.dart`: current calorie-tracker flow bootstrap
- `lib/src/screens/`: Figma-based calorie tracker screens
- `lib/src/theme/`: theme definitions
- `lib/src/widgets/`: shared shell and navigation widgets
- `lib/screens/`: login and signup screens
- `test/`: widget and unit tests
- `docs/`: report, demo, ERD, and submission scaffolding

## Mobile Submission Reminder

This project should be demonstrated as a mobile app. For the assignment, use an emulator or physical phone, not web or desktop builds.

## Current Gaps

Some rubric items still need fuller implementation, especially:

- advanced state management
- Firebase CRUD flows
- authentication wiring
- security rules
- ERD finalization
- final report and video assets
