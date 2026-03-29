import 'package:carolie_tracking_app/src/utils/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthValidators', () {
    test('rejects invalid email', () {
      expect(
        AuthValidators.email('not-an-email'),
        'Enter a valid email address',
      );
    });

    test('accepts valid email', () {
      expect(AuthValidators.email('team@example.com'), isNull);
    });

    test('rejects short password', () {
      expect(
        AuthValidators.password('short'),
        'Password must be at least 8 characters',
      );
    });
  });
}
