class MealLog {
  const MealLog({
    required this.id,
    required this.userId,
    required this.mealName,
    required this.calories,
    required this.mealType,
    required this.loggedAt,
  });

  final String id;
  final String userId;
  final String mealName;
  final int calories;
  final String mealType;
  final DateTime loggedAt;
}
