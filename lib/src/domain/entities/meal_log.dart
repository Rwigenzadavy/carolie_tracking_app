class MealLog {
  const MealLog({
    required this.id,
    required this.userId,
    required this.mealName,
    required this.calories,
    required this.mealType,
    required this.portion,
    required this.source,
    required this.loggedAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String mealName;
  final int calories;
  final String mealType;
  final String portion;
  final String source;
  final DateTime loggedAt;
  final DateTime updatedAt;

  MealLog copyWith({
    String? id,
    String? userId,
    String? mealName,
    int? calories,
    String? mealType,
    String? portion,
    String? source,
    DateTime? loggedAt,
    DateTime? updatedAt,
  }) {
    return MealLog(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      mealName: mealName ?? this.mealName,
      calories: calories ?? this.calories,
      mealType: mealType ?? this.mealType,
      portion: portion ?? this.portion,
      source: source ?? this.source,
      loggedAt: loggedAt ?? this.loggedAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
