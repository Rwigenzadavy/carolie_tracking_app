# Calorie Tracking App

Flutter mobile application for a culturally relevant calorie-tracking experience.

Repository: [github.com/Rwigenzadavy/carolie_tracking_app](https://github.com/Rwigenzadavy/carolie_tracking_app)

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

The app currently boots into the calorie-tracker flow implemented from Figma. Login and signup screens are also present in the codebase and are ready for Firebase wiring.

## Quality Checks

Run these before committing:

- `dart format .`
- `flutter analyze`
- `flutter test`

Current branch validation status:

- `flutter analyze`: passing
- `flutter test`: passing

## Project Structure

- `lib/main.dart`: app entry point
- `lib/src/app.dart`: current calorie-tracker flow bootstrap
- `lib/src/screens/`: Figma-based calorie tracker screens
- `lib/src/domain/`: future app entities and repository contracts
- `lib/src/data/`: Firebase-ready models and repository implementations
- `lib/src/core/`: shared backend constants
- `lib/src/theme/`: theme definitions
- `lib/src/utils/`: copy and validation helpers
- `lib/src/widgets/`: shared shell and navigation widgets
- `lib/screens/`: login and signup screens
- `test/`: widget and unit tests
- `docs/`: report, demo, ERD, and submission scaffolding

## Documentation Pack

The `docs/` folder already contains working draft material for submission:

- `docs/report_outline.md`: report draft content and structure
- `docs/submission_checklist.md`: current completion status
- `docs/demo_checklist.md`: demo plan for recording
- `docs/erd_notes.md`: current schema draft based on the codebase
- `docs/firebase_security_rules_notes.md`: report-ready draft rules notes
- `docs/group_contribution_tracker_template.md`: filled contribution tracker draft from Git history
- `docs/known_limitations_template.md`: current limitations and future work

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

## Backend Prep Added

To make backend implementation safer later without disrupting the current UI flow, this branch now includes:

- auth validation helpers for login and signup flows
- repository interfaces for auth and meal logs
- Firebase-backed repository scaffolding for auth and meal logs
- simple domain entities and data models for users and meal logs

These files are intentionally not wired into the live app flow yet, so the current screens keep working while the backend layer is prepared incrementally.

## Current Auth UI Behavior

- Login and signup forms validate user input before submission
- Success feedback is shown with a `SnackBar`
- Firebase authentication is scaffolded in the data/domain layers, but not yet connected to the active app flow
