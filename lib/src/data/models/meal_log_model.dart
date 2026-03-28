import 'package:carolie_tracking_app/src/domain/entities/meal_log.dart';

class MealLogModel extends MealLog {
  const MealLogModel({
    required super.id,
    required super.userId,
    required super.mealName,
    required super.calories,
    required super.mealType,
    required super.loggedAt,
  });

  factory MealLogModel.fromMap(Map<String, dynamic> map, String id) {
    return MealLogModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      mealName: map['mealName'] as String? ?? '',
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      mealType: map['mealType'] as String? ?? '',
      loggedAt:
          DateTime.tryParse(map['loggedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  factory MealLogModel.fromEntity(MealLog entity) {
    return MealLogModel(
      id: entity.id,
      userId: entity.userId,
      mealName: entity.mealName,
      calories: entity.calories,
      mealType: entity.mealType,
      loggedAt: entity.loggedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mealName': mealName,
      'calories': calories,
      'mealType': mealType,
      'loggedAt': loggedAt.toIso8601String(),
    };
  }
}
