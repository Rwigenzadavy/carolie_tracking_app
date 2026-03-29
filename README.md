# CarAI — Culturally Relevant Calorie Tracker

A Flutter mobile application that helps users track nutrition using culturally familiar West African foods, powered by Firebase.

---

## Setup Instructions

### Prerequisites
- Flutter SDK ≥ 3.10 (`flutter --version`)
- Dart SDK ≥ 3.10
- Android Studio / Xcode for device emulation
- A Firebase project with **Firestore**, **Firebase Auth**, and **Firebase Storage** enabled

### 1. Clone the repository
```bash
git clone https://github.com/Rwigenzadavy/carolie_tracking_app.git
cd carolie_tracking_app
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Firebase configuration
The `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files are included for the team's Firebase project. If you are connecting a different Firebase project:
1. Download your `google-services.json` → place in `android/app/`
2. Download your `GoogleService-Info.plist` → place in `ios/Runner/`
3. Regenerate `lib/firebase_options.dart` using the FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

### 4. Run the app
```bash
# On a physical device or emulator (NOT web/Chrome)
flutter run
```

> **Note:** Web, desktop, and Chrome builds are not supported. Run on Android or iOS only.

### 5. Deploy Firestore security rules
```bash
firebase deploy --only firestore:rules
```

---

## Features

| Screen | Description |
|---|---|
| **Login / Sign Up** | Email/password and Google sign-in with input validation and email verification |
| **Home** | Real-time calorie tracker with configurable goal, macro breakdown, today's meals |
| **Log Meal** | Search local dishes, scan barcode, or use voice input; saves to Firestore |
| **Learn** | Featured lessons with full detail view, ingredient spotlight, seasonal highlights |
| **Community (Tribe)** | Real-time Firestore feed — post, read community updates |
| **Settings** | Calorie goal, default meal type, dark mode — persisted via SharedPreferences |

---

## Architecture

The project follows **Flutter Clean Architecture** with three layers:

```
lib/
├── src/
│   ├── domain/          # Entities & repository abstractions (pure Dart)
│   │   ├── entities/    # AppUser, MealLog, CommunityPost
│   │   └── repositories/
│   ├── data/            # Firebase + SharedPrefs implementations
│   │   ├── models/      # Firestore serialization models
│   │   └── repositories/
│   └── presentation/    # ChangeNotifier controllers (Provider)
│       └── controllers/ # AuthController, MealLogController, CommunityPostController, PreferencesController
├── screens/             # UI screens
└── widgets/             # Shared UI components
```

**State management:** Provider + ChangeNotifier. All business logic lives in controllers; UI widgets only call controller methods and watch state.

---

## Database Architecture (Firestore)

```
users/{userId}
  ├── id, email, displayName, emailVerified, photoUrl, createdAt, updatedAt
  └── meal_logs/{mealLogId}
        └── userId, mealName, calories, mealType, portion, source, loggedAt, updatedAt

community_posts/{postId}
  └── userId, username, avatar, body, tag, likes, createdAt
```

---

## Firebase Security Rules

Security rules are in `firestore.rules`. Key policies:

- **`/users/{userId}`** — owner-only read/write (`request.auth.uid == userId`)
- **`/users/{userId}/meal_logs/{mealLogId}`** — owner-only CRUD with field-type validation (mealName, mealType, portion, source must be strings; calories must be int)
- **`/community_posts/{postId}`** — any authenticated user can read; create requires `userId == auth.uid` with non-empty body/tag/username validation; update/delete restricted to the post owner

This ensures users can never read or write another user's meal data, and community posts are validated before being written.

---

## Authentication

Two methods implemented:
1. **Email / Password** — with full input validation (email regex, min 8-char password, confirm password match), email verification on signup, and password reset via email
2. **Google Sign-In** — OAuth via `google_sign_in` package

Auth state persists across restarts via Firebase `authStateChanges()` stream.

---

## User Preferences (SharedPreferences)

Three preferences are saved and restored on every cold start:

| Preference | Default | Where used |
|---|---|---|
| Calorie goal | 2100 kcal | Home screen progress bar |
| Default meal type | Lunch | Pre-fills meal log editor |
| Dark mode | Off | `MaterialApp` theme mode |

Access via the **Settings** sheet (tap the profile icon on the home screen).

---

## CRUD Operations

All CRUD operations are backed by Firestore and update the UI in real time via streams:

| Operation | Where |
|---|---|
| **Create** | Log Meal screen → saves meal to Firestore; Community screen → saves post |
| **Read** | Home screen streams today's meals; Community screen streams all posts |
| **Update** | Long-press a meal → Edit sheet → updates Firestore document |
| **Delete** | Long-press a meal → Delete → removes Firestore document |

---

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

- **Unit tests** (`test/auth_validators_test.dart`): 3 tests covering email validation (invalid, valid) and password length
- **Widget tests** (`test/widget_test.dart`): 2 tests covering `InsightCard` rendering and `DishCard` + bottom navigation

---

## Known Limitations & Future Work

- Barcode scanning uses the raw barcode value as the meal name (no product database lookup yet)
- Calorie goal is per-day only; weekly/monthly views are not yet implemented
- Community posts support create and read; edit and delete of posts are not yet exposed in the UI (rules support it)
- The daily insight card is static; future work would rotate tips from Firestore
- Macro breakdown (carbs/protein/fat) is estimated from total calories using fixed ratios, not actual nutritional data

---

## Code Quality

```bash
flutter analyze   # → No issues found
flutter test      # → All tests passed
dart format .     # Format all Dart files
```
