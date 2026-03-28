# Firebase Security Rules Notes

This is the current report-ready draft based on the backend structure already present in the codebase.

## Current Intended Access Model

- Each authenticated user should only read and write their own user document
- Each authenticated user should only read and write meal logs inside `users/{userId}/meal_logs`
- Cross-user access should be denied
- Public reads should remain disabled unless the team explicitly adds a public collection later

## Draft Firestore Rules

```txt
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, create, update, delete: if request.auth != null
        && request.auth.uid == userId;

      match /meal_logs/{mealLogId} {
        allow read, create, update, delete: if request.auth != null
          && request.auth.uid == userId;
      }
    }
  }
}
```

## Report Talking Points

- Access is owner-scoped with `request.auth.uid == userId`
- User profile data is not exposed to other authenticated users
- Nested meal-log documents inherit the same owner-based restriction
- The app should avoid broad authenticated-user-wide rules
- If validation rules are added later, they should verify required fields such as `mealName`, `calories`, and `loggedAt`

## Final Verification Before Submission

- Confirm the deployed Firebase rules match this document
- Confirm the collection paths in Firebase match the ERD and repository code
- Update this file if the team adds more collections or admin paths
