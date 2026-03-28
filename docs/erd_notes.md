# ERD Notes

This draft reflects the current backend structure that is already scaffolded in code.

## Current Collections and Entities

### `users`

- `id` / document id
- `email`
- `displayName`

### `users/{userId}/meal_logs`

- `id` / document id
- `userId`
- `mealName`
- `calories`
- `mealType`
- `loggedAt`

## Relationships

- One `user` can own many `meal_logs`
- Every `meal_log` belongs to one `user`

## Code References

- `lib/src/core/firebase/firebase_collection_names.dart`
- `lib/src/domain/entities/app_user.dart`
- `lib/src/domain/entities/meal_log.dart`
- `lib/src/data/models/app_user_model.dart`
- `lib/src/data/models/meal_log_model.dart`
- `lib/src/data/repositories/firebase_meal_log_repository.dart`

## ERD Alignment Check Before Submission

- Keep collection names exactly as `users` and `meal_logs`
- Keep field names exactly aligned with the model `toMap()` methods
- Add any new collections to this file as soon as they are introduced
- Export the final ERD as an image or PDF and include it in the report package
