import 'package:carolie_tracking_app/src/domain/entities/meal_log.dart';

abstract class MealLogRepository {
  Stream<List<MealLog>> watchMealLogs(String userId);

  Future<void> addMealLog(MealLog mealLog);

  Future<void> updateMealLog(MealLog mealLog);

  Future<void> deleteMealLog({
    required String userId,
    required String mealLogId,
  });
}
