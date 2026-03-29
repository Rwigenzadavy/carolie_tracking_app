import 'package:carolie_tracking_app/src/domain/repositories/preferences_repository.dart';
import 'package:flutter/material.dart';

class PreferencesController extends ChangeNotifier {
  PreferencesController(this._repository);

  final PreferencesRepository _repository;

  int _calorieGoal = 2100;
  String _defaultMealType = 'Lunch';
  bool _isDarkMode = false;

  int get calorieGoal => _calorieGoal;
  String get defaultMealType => _defaultMealType;
  bool get isDarkMode => _isDarkMode;

  Future<void> load() async {
    _calorieGoal = await _repository.getCalorieGoal();
    _defaultMealType = await _repository.getDefaultMealType();
    _isDarkMode = await _repository.getIsDarkMode();
    notifyListeners();
  }

  Future<void> setCalorieGoal(int value) async {
    await _repository.setCalorieGoal(value);
    _calorieGoal = value;
    notifyListeners();
  }

  Future<void> setDefaultMealType(String value) async {
    await _repository.setDefaultMealType(value);
    _defaultMealType = value;
    notifyListeners();
  }

  Future<void> setIsDarkMode(bool value) async {
    await _repository.setIsDarkMode(value);
    _isDarkMode = value;
    notifyListeners();
  }
}
