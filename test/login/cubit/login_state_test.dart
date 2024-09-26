// ignore_for_file: prefer_const_constructors
import 'package:flutter_firebase_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';

void main() {
  const email = Email.dirty('test@example.com');
  const password = Password.dirty('password');
  const errorMessage = 'oops';

  group('LoginState', () {
    test('supports value comparisons', () {
      expect(LoginState(), LoginState());
    });

    test('returns same object when no properties are passed', () {
      expect(LoginState().copyWith(), LoginState());
    });

    test('returns object with updated email when email is passed', () {
      expect(
        LoginState().copyWith(email: email),
        LoginState(email: email),
      );
    });

    test('returns object with updated password when password is passed', () {
      expect(
        LoginState().copyWith(password: password),
        LoginState(password: password),
      );
    });

    test('returns object with updated status when status is passed', () {
      expect(
        LoginState().copyWith(status: FormzSubmissionStatus.inProgress),
        LoginState(status: FormzSubmissionStatus.inProgress),
      );
    });

    test('returns object with updated isValid when isValid is passed', () {
      expect(
        LoginState().copyWith(isValid: true),
        LoginState(isValid: true),
      );
    });

    test('returns object with updated errorMessage when errorMessage is passed',
        () {
      expect(
        LoginState().copyWith(errorMessage: errorMessage),
        LoginState(errorMessage: errorMessage),
      );
    });

    test('props are correct', () {
      expect(
        LoginState(
          email: email,
          password: password,
          status: FormzSubmissionStatus.inProgress,
          isValid: true,
          errorMessage: errorMessage,
        ).props,
        [email, password, FormzSubmissionStatus.inProgress, true, errorMessage],
      );
    });
  });
}
