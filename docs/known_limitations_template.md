# Known Limitations and Future Work

## Known Limitations

- The active app entry point currently demonstrates the calorie-tracker Home and Log Meal flow; login and signup screens are implemented but not yet wired into the main navigation flow.
- Firebase authentication and meal-log repositories are scaffolded in code, but production CRUD and authentication flows are not yet connected to the UI.
- Advanced state management and full clean-architecture separation are only partially started.
- Responsive verification still needs to be repeated on the exact device sizes used in the final demo.

## Future Work

- Connect login and signup forms to Firebase Authentication
- Add complete Create, Read, Update, and Delete flows for meal tracking data
- Add SharedPreferences-backed user settings and persistence
- Replace local screen switching with a scalable state-management solution
- Increase widget and unit test coverage across authentication and backend flows
