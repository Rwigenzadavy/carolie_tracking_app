import 'dart:async';

import 'package:carolie_tracking_app/src/domain/entities/meal_log.dart';
import 'package:carolie_tracking_app/src/domain/repositories/meal_log_repository.dart';
import 'package:flutter/material.dart';

class MealLogController extends ChangeNotifier {
  MealLogController(this._mealLogRepository);

  final MealLogRepository _mealLogRepository;
  StreamSubscription<List<MealLog>>? _subscription;

  List<MealLog> _mealLogs = const [];
  bool _isLoading = false;
  String? _boundUserId;

  List<MealLog> get mealLogs => _mealLogs;
  bool get isLoading => _isLoading;
  int get totalCalories => _mealLogs.fold(0, (sum, meal) => sum + meal.calories);

  void bindUser(String? userId) {
    if (_boundUserId == userId) {
      return;
    }

    _subscription?.cancel();
    _boundUserId = userId;
    _mealLogs = const [];

    if (userId == null) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _subscription = _mealLogRepository.watchMealLogs(userId).listen(
      (logs) {
        _mealLogs = logs;
        _isLoading = false;
        notifyListeners();
      },
      onError: (_) {
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  Future<void> addMealLog({
    required String userId,
    required String mealName,
    required int calories,
    required String mealType,
    required String portion,
    required String source,
  }) {
    final now = DateTime.now();
    return _mealLogRepository.addMealLog(
      MealLog(
        id: now.microsecondsSinceEpoch.toString(),
        userId: userId,
        mealName: mealName,
        calories: calories,
        mealType: mealType,
        portion: portion,
        source: source,
        loggedAt: now,
        updatedAt: now,
      ),
    );
  }

  Future<void> updateMealLog(MealLog mealLog) {
    return _mealLogRepository.updateMealLog(
      mealLog.copyWith(updatedAt: DateTime.now()),
    );
  }

  Future<void> deleteMealLog(MealLog mealLog) {
    return _mealLogRepository.deleteMealLog(
      userId: mealLog.userId,
      mealLogId: mealLog.id,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
