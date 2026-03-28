import 'package:carolie_tracking_app/src/utils/auth_validators.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthValidators', () {
    test('rejects empty full name', () {
      expect(AuthValidators.fullName(''), 'Enter your full name');
    });

    test('accepts valid full name', () {
      expect(AuthValidators.fullName('Gentil Iradukunda'), isNull);
    });

    test('rejects invalid email', () {
      expect(
        AuthValidators.email('not-an-email'),
        'Enter a valid email address',
      );
    });

    test('accepts valid email', () {
      expect(AuthValidators.email('gentil@example.com'), isNull);
    });

    test('rejects short password', () {
      expect(
        AuthValidators.password('short'),
        'Password must be at least 8 characters',
      );
    });

    test('rejects mismatched confirm password', () {
      expect(
        AuthValidators.confirmPassword('secret123', 'secret456'),
        'Passwords do not match',
      );
    });
  });
}
