class MealCopy {
  const MealCopy._();

  static String calories(int value) => '$value cal';

  static String servingCalories(int value) => '~$value cal per serving';

  static String mealTime(String mealType, String time) => '$mealType • $time';
}
