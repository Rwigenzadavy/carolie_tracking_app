import 'package:carolie_tracking_app/src/domain/entities/meal_log.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MealLogModel extends MealLog {
  const MealLogModel({
    required super.id,
    required super.userId,
    required super.mealName,
    required super.calories,
    required super.mealType,
    required super.portion,
    required super.source,
    required super.loggedAt,
    required super.updatedAt,
  });

  factory MealLogModel.fromEntity(MealLog mealLog) {
    return MealLogModel(
      id: mealLog.id,
      userId: mealLog.userId,
      mealName: mealLog.mealName,
      calories: mealLog.calories,
      mealType: mealLog.mealType,
      portion: mealLog.portion,
      source: mealLog.source,
      loggedAt: mealLog.loggedAt,
      updatedAt: mealLog.updatedAt,
    );
  }

  factory MealLogModel.fromMap(Map<String, dynamic> map, String id) {
    DateTime parseDate(dynamic value) {
      if (value is Timestamp) {
        return value.toDate();
      }
      if (value is String) {
        return DateTime.tryParse(value) ?? DateTime.now();
      }
      return DateTime.now();
    }

    return MealLogModel(
      id: id,
      userId: map['userId'] as String? ?? '',
      mealName: map['mealName'] as String? ?? '',
      calories: (map['calories'] as num?)?.toInt() ?? 0,
      mealType: map['mealType'] as String? ?? 'Meal',
      portion: map['portion'] as String? ?? '1 serving',
      source: map['source'] as String? ?? 'manual',
      loggedAt: parseDate(map['loggedAt']),
      updatedAt: parseDate(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mealName': mealName,
      'calories': calories,
      'mealType': mealType,
      'portion': portion,
      'source': source,
      'loggedAt': Timestamp.fromDate(loggedAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
