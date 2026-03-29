abstract class PreferencesRepository {
  Future<int> getCalorieGoal();
  Future<void> setCalorieGoal(int value);
  Future<String> getDefaultMealType();
  Future<void> setDefaultMealType(String value);
  Future<bool> getIsDarkMode();
  Future<void> setIsDarkMode(bool value);
}
