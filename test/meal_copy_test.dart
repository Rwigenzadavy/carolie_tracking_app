import 'package:carolie_tracking_app/src/utils/meal_copy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MealCopy', () {
    test('formats calories for meal cards', () {
      expect(MealCopy.calories(320), '320 cal');
    });

    test('formats serving calories for log meal cards', () {
      expect(MealCopy.servingCalories(450), '~450 cal per serving');
    });

    test('formats meal type and time labels', () {
      expect(
        MealCopy.mealTime('Breakfast', '08:30 AM'),
        'Breakfast • 08:30 AM',
      );
    });
  });
}
