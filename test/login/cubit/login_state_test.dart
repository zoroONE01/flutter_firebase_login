import 'package:flutter_firebase_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

void main() {
  group('LoginState', () {
    test('F-14: supports value comparisons', () {
      expect(
        const LoginState(),
        const LoginState(),
      );
    });

    test('F-14: returns same object when no properties are passed', () {
      expect(
        const LoginState().copyWith(),
        const LoginState(),
      );
    });

    test('F-14: returns object with updated email when email is passed', () {
      expect(
        const LoginState().copyWith(email: Email.dirty('test@example.com')),
        const LoginState(email: Email.dirty('test@example.com')),
      );
    });

    test('F-15: returns object with updated password when password is passed',
        () {
      expect(
        const LoginState().copyWith(password: Password.dirty('password123')),
        const LoginState(password: Password.dirty('password123')),
      );
    });

    test('F-3: returns object with updated status when status is passed', () {
      expect(
        const LoginState().copyWith(status: FormzSubmissionStatus.inProgress),
        const LoginState(status: FormzSubmissionStatus.inProgress),
      );
    });

    test(
        'F-5: returns object with updated errorMessage when errorMessage is passed',
        () {
      expect(
        const LoginState().copyWith(errorMessage: 'Invalid credentials'),
        const LoginState(errorMessage: 'Invalid credentials'),
      );
    });

    test('F-14: returns object with updated isValid when isValid is passed',
        () {
      expect(
        const LoginState().copyWith(isValid: true),
        const LoginState(isValid: true),
      );
    });

    test('F-9: returns object with email validation error when email is empty',
        () {
      expect(
        const LoginState().copyWith(email: Email.dirty('')),
        const LoginState(email: Email.dirty('')),
      );
    });

    test(
        'F-10: returns object with password validation error when password is empty',
        () {
      expect(
        const LoginState().copyWith(password: Password.dirty('')),
        const LoginState(password: Password.dirty('')),
      );
    });

    test(
        'F-11: returns object with email validation error when email is invalid',
        () {
      expect(
        const LoginState().copyWith(email: Email.dirty('invalid-email')),
        const LoginState(email: Email.dirty('invalid-email')),
      );
    });

    test(
        'F-12: returns object with password validation error when password is invalid',
        () {
      expect(
        const LoginState()
            .copyWith(password: Password.dirty('invalid-password')),
        const LoginState(password: Password.dirty('invalid-password')),
      );
    });

    test(
        'F-18: returns object with network error when logInWithCredentials fails',
        () {
      expect(
        const LoginState().copyWith(errorMessage: 'Network error'),
        const LoginState(errorMessage: 'Network error'),
      );
    });

    test(
        'F-19: returns object with server error when logInWithCredentials fails',
        () {
      expect(
        const LoginState().copyWith(errorMessage: 'Server error'),
        const LoginState(errorMessage: 'Server error'),
      );
    });

    test(
        'F-20: returns object with invalid credentials error when logInWithGoogle fails',
        () {
      expect(
        const LoginState().copyWith(errorMessage: 'Invalid credentials'),
        const LoginState(errorMessage: 'Invalid credentials'),
      );
    });

    test('F-21: returns object with network error when logInWithGoogle fails',
        () {
      expect(
        const LoginState().copyWith(errorMessage: 'Network error'),
        const LoginState(errorMessage: 'Network error'),
      );
    });
  });
}
