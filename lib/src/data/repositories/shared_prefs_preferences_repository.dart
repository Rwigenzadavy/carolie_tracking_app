import 'package:carolie_tracking_app/src/domain/repositories/preferences_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsPreferencesRepository implements PreferencesRepository {
  static const _calorieGoalKey = 'calorie_goal';
  static const _defaultMealTypeKey = 'default_meal_type';
  static const _isDarkModeKey = 'is_dark_mode';

  @override
  Future<int> getCalorieGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_calorieGoalKey) ?? 2100;
  }

  @override
  Future<void> setCalorieGoal(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_calorieGoalKey, value);
  }

  @override
  Future<String> getDefaultMealType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_defaultMealTypeKey) ?? 'Lunch';
  }

  @override
  Future<void> setDefaultMealType(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_defaultMealTypeKey, value);
  }

  @override
  Future<bool> getIsDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false;
  }

  @override
  Future<void> setIsDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, value);
  }
}
