# Final Report Outline

This file is a project-specific draft, not an empty template.

## 1. Project Overview

- App purpose: a culturally relevant calorie-tracking mobile application
- Implemented design source: Figma-based Home, Log Meal, Login, and Signup screens
- Current target experience: mobile-first Flutter app with nutrition tracking flows

## 2. Repository and Setup

- Repository: [github.com/Rwigenzadavy/carolie_tracking_app](https://github.com/Rwigenzadavy/carolie_tracking_app)
- Setup steps:
  - run `flutter pub get`
  - launch an emulator or connect a physical device
  - run `flutter run`
- Quality checks:
  - run `dart format .`
  - run `flutter analyze`
  - run `flutter test`

## 3. Front-End Implementation

- Implemented screens:
  - Home
  - Log Meal
  - Login
  - Signup
- Shared UI work:
  - bottom navigation shell
  - theme setup
  - Figma asset integration
  - form validation on auth screens

## 4. Back-End Implementation

- Firebase packages are included in the project
- Current code scaffolds:
  - auth repository contract and Firebase auth repository
  - meal log repository contract and Firestore repository
  - user and meal-log entities/models
- Current schema draft:
  - `users`
  - `users/{userId}/meal_logs`

## 5. Security Rules

- Planned rule model is owner-scoped access
- Suggested rule basis is documented in `docs/firebase_security_rules_notes.md`
- Final report should include the exact deployed rules text

## 6. Testing and Quality Assurance

- Widget tests exist for the calorie-tracker screens
- Unit tests exist for auth validation helpers
- Current local checks pass:
  - `flutter analyze`
  - `flutter test`

## 7. Team Contributions

- Contribution draft is documented in `docs/group_contribution_tracker_template.md`
- Git history currently shows work from Christian Tonny, Rwigenzadavy, Dominion Yusuf, and Gentil Iradukunda

## 8. Known Limitations and Future Work

- See `docs/known_limitations_template.md` for the current write-up

## 9. References and Disclosure

- Cite any non-original written material used in the final PDF
- Disclose any AI assistance in the methodology section or a footnote
- Include Figma and Firebase references if they are discussed directly in the report
