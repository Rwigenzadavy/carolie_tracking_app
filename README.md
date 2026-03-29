# CarAI — Culturally Relevant Calorie Tracker

A Flutter mobile application that helps users track nutrition using culturally familiar foods from Nigeria and Rwanda, powered by Firebase.

**GitHub Repository:** https://github.com/Rwigenzadavy/carolie_tracking_app

---

## Demo Video

[![CarAI Demo Video](https://img.youtube.com/vi/Y1hegDC3h5E/maxresdefault.jpg)](https://youtu.be/Y1hegDC3h5E)

**Watch the full demo:** https://youtu.be/Y1hegDC3h5E

The demo covers:
- Cold-start launch and both authentication flows (Email/Password + Google Sign-In)
- Full navigation through every screen
- CRUD operations with Firebase Console visible in real time
- SharedPreferences settings persisting across app restart
- Input validation and error handling

---

## Setup Instructions

### Prerequisites
- Flutter SDK ≥ 3.10 (`flutter --version`)
- Dart SDK ≥ 3.10
- Android Studio or Xcode for device emulation / physical device
- Firebase CLI (`npm install -g firebase-tools`)

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
The `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) files are already included for the team's Firebase project (`carolie-app`). If connecting a different Firebase project:
1. Download your `google-services.json` → place in `android/app/`
2. Download your `GoogleService-Info.plist` → place in `ios/Runner/`
3. Regenerate `lib/firebase_options.dart`:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

### 4. Deploy Firestore security rules & indexes
```bash
firebase deploy --only firestore:rules,firestore:indexes
```

### 5. Run the app
```bash
# Physical device or emulator — NOT web/Chrome/desktop
flutter run
```

> **Important:** Web, desktop, and Chrome builds are not supported. This is a mobile application; run on Android or iOS only.

---

## Implemented Features

| Screen | Functionality |
|---|---|
| **Login** | Email/password sign-in, Google Sign-In, password reset, input validation, error messages |
| **Sign Up** | Account creation with display name, email verification, Google Sign-In |
| **Home** | Real-time calorie progress bar, macro breakdown, today's meal list, settings sheet |
| **Log Meal** | Browse Nigerian & Rwandan preset dishes, search, barcode scan, voice input, log to Firestore |
| **Learn** | Featured lessons (Jollof Rice, Isombe, Brochettes, Tiger Nuts, Macronutrients), ingredient spotlight, seasonal highlights from both cultures |
| **Community (Tribe)** | Real-time post feed, create posts with group tag, like posts — all synced to Firestore |
| **Settings** | Calorie goal, default meal type, dark mode — saved and restored via SharedPreferences |

---

## Architecture

The project follows **Flutter Clean Architecture** with strict separation into three layers:

```
lib/
├── src/
│   ├── domain/              # Pure Dart — no Flutter/Firebase dependencies
│   │   ├── entities/        # AppUser, MealLog, CommunityPost
│   │   └── repositories/    # Abstract interfaces
│   ├── data/                # Firebase + SharedPreferences implementations
│   │   ├── models/          # Firestore serialization (fromMap / toMap)
│   │   └── repositories/    # FirebaseAuthRepository, FirebaseMealLogRepository,
│   │                        # FirebaseCommunityPostRepository, SharedPrefsPreferencesRepository
│   └── presentation/
│       └── controllers/     # AuthController, MealLogController,
│                            # CommunityPostController, PreferencesController
├── screens/                 # UI screens (stateless where possible)
├── widgets/                 # Shared UI components (AppShell, MealLogEditorSheet)
└── theme/                   # AppTheme, AppColors
```

**State management:** Provider + ChangeNotifier. All business logic lives in controllers; UI widgets only call controller methods and observe state. No `setState` for shared state.

---

## Database Architecture (ERD → Firestore)

### Entity-Relationship Overview

```
AppUser (1) ────< MealLog (many)
AppUser (1) ────< CommunityPost (many)
```

### Firestore Collections

```
users/{userId}
  id            : String   (Firebase Auth UID — primary key)
  email         : String
  displayName   : String
  emailVerified : Boolean
  photoUrl      : String?
  createdAt     : Timestamp
  updatedAt     : Timestamp

  meal_logs/{mealLogId}        ← sub-collection, owner-scoped
    id          : String       (microsecond timestamp — primary key)
    userId      : String       (foreign key → users.id)
    mealName    : String
    calories    : Integer
    mealType    : String       (Breakfast | Lunch | Dinner | Snack)
    portion     : String
    source      : String       (manual | barcode | voice)
    loggedAt    : Timestamp
    updatedAt   : Timestamp

community_posts/{postId}       ← top-level collection
  id            : String       (microsecond timestamp — primary key)
  userId        : String       (foreign key → users.id)
  username      : String
  avatar        : String       (emoji avatar)
  body          : String
  tag           : String       (Nigerian Wellness | Rwanda Wellness | Fitness & Nutrition | …)
  likes         : Integer
  createdAt     : Timestamp
```

All field names in Firestore match the model `toMap()` keys exactly.

---

## Firebase Security Rules

Rules are defined in `firestore.rules` and deployed via the Firebase CLI.

```
/users/{userId}
  → read, create, update: owner only (request.auth.uid == userId)

/users/{userId}/meal_logs/{mealLogId}
  → read, delete: owner only
  → create, update: owner only + field validation:
      userId must equal auth.uid
      mealName, mealType, portion, source must be strings
      calories must be an integer

/community_posts/{postId}
  → read: any authenticated user
  → create: authenticated user, userId == auth.uid,
            body.size() > 0, tag and username must be strings
  → update (likes only): any authenticated user may increment the likes field
  → update (full): post owner only
  → delete: post owner only
```

**Design rationale:**
- Meal logs are stored as a sub-collection under each user, so Firestore path-level rules naturally prevent cross-user access without complex query restrictions.
- Community posts enforce `userId == auth.uid` on create to prevent impersonation.
- The `likes` field uses a targeted `affectedKeys().hasOnly(['likes'])` rule so any authenticated user can like a post without being able to modify the body, tag, or other fields.

---

## Authentication

Two methods implemented:

| Method | Details |
|---|---|
| **Email / Password** | Full input validation (email regex, min 8-char password, confirm-match), email verification sent on signup, password reset via email, friendly error sheet for invalid credentials |
| **Google Sign-In** | OAuth via `google_sign_in` package, account linked to Firestore user document on first login |

Additional security features:
- Auth state persists across restarts via Firebase `authStateChanges()` stream
- Email verification status refreshed on app resume via `WidgetsBindingObserver` + `user.reload()`
- Input validators reject blank or malformed entries before any network call

---

## CRUD Operations

All operations are backed by Firestore and update the UI in real time via snapshot streams.

| Operation | Meal Logs | Community Posts |
|---|---|---|
| **Create** | Log Meal screen → saves to `users/{uid}/meal_logs` | Community screen FAB → saves to `community_posts` |
| **Read** | Home screen streams today's meals filtered by date range | Community screen streams latest 50 posts ordered by `createdAt` |
| **Update** | Long-press meal card → edit sheet → updates Firestore document | Tap ❤️ on any post → increments `likes` via `FieldValue.increment` |
| **Delete** | Long-press meal card → delete → removes Firestore document | Supported by security rules; UI delete button for own posts |

---

## User Preferences (SharedPreferences)

Three preferences persist across cold starts:

| Key | Type | Default | Where Used |
|---|---|---|---|
| `calorie_goal` | int | 2100 kcal | Home screen progress ring and "X kcal left" label |
| `default_meal_type` | String | Lunch | Pre-fills the meal type dropdown in the log editor |
| `is_dark_mode` | bool | false | `MaterialApp` `themeMode` — persists theme across restarts |

Access via the **Settings** sheet (tap the profile icon on the Home screen). All three are loaded at app startup before `runApp()` is called.

---

## Testing

```bash
# Run all tests
flutter test

# Run with coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

| Test file | Type | Tests | What is covered |
|---|---|---|---|
| `test/auth_validators_test.dart` | Unit | 3 | Email regex (invalid + valid), password minimum length |
| `test/widget_test.dart` | Widget | 2 | `InsightCard` renders correct text; `DishCard` renders title and bottom nav is present |

All tests pass with `flutter test`.

---

## Code Quality

```bash
flutter analyze   # No issues found
dart format .     # All files formatted
flutter test      # All tests pass
```

`flutter analyze` screenshot is included in the PDF report.

---

## Known Limitations & Future Work

- **Barcode scanning** uses the raw barcode string as the meal name — no external product/nutrition database lookup is integrated yet.
- **Calorie view** is daily only; weekly and monthly trend charts are not yet implemented.
- **Community post deletion** is enforced by Firestore security rules and the backend is ready, but a delete button in the UI for the post owner is not yet exposed.
- **Macro breakdown** (carbs / protein / fat) is estimated from total calories using fixed ratios rather than per-dish nutritional data.
- **Barcode and voice input** accept any string — future work would validate against a food database API (e.g., Open Food Facts).
- **Likes** are not de-duplicated per user; a user can like the same post more than once. A sub-collection of `likes/{userId}` would solve this in a future iteration.
- **Offline support** — Firestore offline persistence is enabled by default but the UI does not yet surface a "you are offline" indicator.

---

## Group Contribution Tracker

[Group Contribution Tracker](https://docs.google.com/spreadsheets/d/your-tracker-link-here)

> Replace the link above with your team's actual Google Sheets contribution tracker before submission.
