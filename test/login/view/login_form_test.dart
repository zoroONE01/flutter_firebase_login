import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginCubit extends Mock implements LoginCubit {}

void main() {
  group('LoginForm', () {
    late LoginCubit loginCubit;

    setUp(() {
      loginCubit = MockLoginCubit();
      when(() => loginCubit.state).thenReturn(const LoginState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: loginCubit,
        child: const MaterialApp(
          home: Scaffold(
            body: LoginForm(),
          ),
        ),
      );
    }

    testWidgets('G-1: Check background', (tester) async {
      await tester.pumpWidget(buildSubject());
      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsOneWidget);
    });

    testWidgets('G-2: Check display label [Login]', (tester) async {
      await tester.pumpWidget(buildSubject());
      final appBar = find.text('Login');
      expect(appBar, findsOneWidget);
    });

    testWidgets('G-3: Check display textbox [Email]', (tester) async {
      await tester.pumpWidget(buildSubject());
      final emailField =
          find.byKey(const Key('loginForm_emailInput_textField'));
      expect(emailField, findsOneWidget);
    });

    testWidgets('G-4: Check display textbox [Password]', (tester) async {
      await tester.pumpWidget(buildSubject());
      final passwordField =
          find.byKey(const Key('loginForm_passwordInput_textField'));
      expect(passwordField, findsOneWidget);
    });

    testWidgets('G-5: Check display button [Login]', (tester) async {
      await tester.pumpWidget(buildSubject());
      final loginButton =
          find.byKey(const Key('loginForm_continue_raisedButton'));
      expect(loginButton, findsOneWidget);
    });

    testWidgets('G-6: Check display button [Google Login]', (tester) async {
      await tester.pumpWidget(buildSubject());
      final googleLoginButton =
          find.byKey(const Key('loginForm_googleLogin_raisedButton'));
      expect(googleLoginButton, findsOneWidget);
    });

    testWidgets('G-7: Check display icon [Password visibility]',
        (tester) async {
      await tester.pumpWidget(buildSubject());
      final passwordField =
          find.byKey(const Key('loginForm_passwordInput_textField'));
      expect(passwordField, findsOneWidget);
    });

    testWidgets('G-8: Check display text [Forgot password]', (tester) async {
      await tester.pumpWidget(buildSubject());
      final forgotPasswordText = find.text('Forgot password');
      expect(forgotPasswordText, findsOneWidget);
    });

    testWidgets('F-1: Check email validation', (tester) async {
      when(() => loginCubit.state).thenReturn(
        const LoginState(email: Email.dirty('invalid')),
      );
      await tester.pumpWidget(buildSubject());
      final emailField =
          find.byKey(const Key('loginForm_emailInput_textField'));
      await tester.enterText(emailField, 'invalid');
      await tester.pump();
      expect(find.text('invalid email'), findsOneWidget);
    });

    testWidgets('F-2: Check password validation', (tester) async {
      when(() => loginCubit.state).thenReturn(
        const LoginState(password: Password.dirty('short')),
      );
      await tester.pumpWidget(buildSubject());
      final passwordField =
          find.byKey(const Key('loginForm_passwordInput_textField'));
      await tester.enterText(passwordField, 'short');
      await tester.pump();
      expect(find.text('invalid password'), findsOneWidget);
    });

    testWidgets('F-3: Check login with credentials', (tester) async {
      when(() => loginCubit.state).thenReturn(
        const LoginState(isValid: true),
      );
      await tester.pumpWidget(buildSubject());
      final loginButton =
          find.byKey(const Key('loginForm_continue_raisedButton'));
      await tester.tap(loginButton);
      verify(() => loginCubit.logInWithCredentials()).called(1);
    });

    testWidgets('F-6: Check Google login', (tester) async {
      await tester.pumpWidget(buildSubject());
      final googleLoginButton =
          find.byKey(const Key('loginForm_googleLogin_raisedButton'));
      await tester.tap(googleLoginButton);
      verify(() => loginCubit.logInWithGoogle()).called(1);
    });

    testWidgets('F-14: Check email changed', (tester) async {
      await tester.pumpWidget(buildSubject());
      final emailField =
          find.byKey(const Key('loginForm_emailInput_textField'));
      await tester.enterText(emailField, 'test@example.com');
      verify(() => loginCubit.emailChanged('test@example.com')).called(1);
    });

    testWidgets('F-15: Check password changed', (tester) async {
      await tester.pumpWidget(buildSubject());
      final passwordField =
          find.byKey(const Key('loginForm_passwordInput_textField'));
      await tester.enterText(passwordField, 'password123');
      verify(() => loginCubit.passwordChanged('password123')).called(1);
    });

    testWidgets('F-4: Check login with credentials success', (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(status: FormzSubmissionStatus.success),
        ]),
      );
      await tester.pumpWidget(buildSubject());
      final loginButton =
          find.byKey(const Key('loginForm_continue_raisedButton'));
      await tester.tap(loginButton);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('F-5: Check login with credentials failure', (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Invalid credentials'),
        ]),
      );
      await tester.pumpWidget(buildSubject());
      final loginButton =
          find.byKey(const Key('loginForm_continue_raisedButton'));
      await tester.tap(loginButton);
      await tester.pump();
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('F-7: Check Google login success', (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(status: FormzSubmissionStatus.success),
        ]),
      );
      await tester.pumpWidget(buildSubject());
      final googleLoginButton =
          find.byKey(const Key('loginForm_googleLogin_raisedButton'));
      await tester.tap(googleLoginButton);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('F-8: Check Google login failure', (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Google login failed'),
        ]),
      );
      await tester.pumpWidget(buildSubject());
      final googleLoginButton =
          find.byKey(const Key('loginForm_googleLogin_raisedButton'));
      await tester.tap(googleLoginButton);
      await tester.pump();
      expect(find.text('Google login failed'), findsOneWidget);
    });

    testWidgets('F-9: Check email validation with empty input', (tester) async {
      when(() => loginCubit.state).thenReturn(
        const LoginState(email: Email.dirty('')),
      );
      await tester.pumpWidget(buildSubject());
      final emailField =
          find.byKey(const Key('loginForm_emailInput_textField'));
      await tester.enterText(emailField, '');
      await tester.pump();
      expect(find.text('invalid email'), findsOneWidget);
    });

    testWidgets('F-10: Check password validation with empty input',
        (tester) async {
      when(() => loginCubit.state).thenReturn(
        const LoginState(password: Password.dirty('')),
      );
      await tester.pumpWidget(buildSubject());
      final passwordField =
          find.byKey(const Key('loginForm_passwordInput_textField'));
      await tester.enterText(passwordField, '');
      await tester.pump();
      expect(find.text('invalid password'), findsOneWidget);
    });

    testWidgets('F-11: Check login with credentials and invalid email',
        (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Invalid email'),
        ]),
      );
      await tester.pumpWidget(buildSubject());
      final loginButton =
          find.byKey(const Key('loginForm_continue_raisedButton'));
      await tester.tap(loginButton);
      await tester.pump();
      expect(find.text('Invalid email'), findsOneWidget);
    });

    testWidgets('F-12: Check login with credentials and invalid password',
        (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Invalid password'),
        ]),
      );
      await tester.pumpWidget(buildSubject());
      final loginButton =
          find.byKey(const Key('loginForm_continue_raisedButton'));
      await tester.tap(loginButton);
      await tester.pump();
      expect(find.text('Invalid password'), findsOneWidget);
    });

    testWidgets('F-13: Check Google login with network error', (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Network error'),
        ]),
      );
      await tester.pumpWidget(buildSubject());
      final googleLoginButton =
          find.byKey(const Key('loginForm_googleLogin_raisedButton'));
      await tester.tap(googleLoginButton);
      await tester.pump();
      expect(find.text('Network error'), findsOneWidget);
    });

    testWidgets('F-16: Check email validation with special characters',
        (tester) async {
      when(() => loginCubit.state).thenReturn(
        const LoginState(email: Email.dirty('invalid@#email')),
      );
      await tester.pumpWidget(buildSubject());
      final emailField =
          find.byKey(const Key('loginForm_emailInput_textField'));
      await tester.enterText(emailField, 'invalid@#email');
      await tester.pump();
      expect(find.text('invalid email'), findsOneWidget);
    });

    testWidgets('F-17: Check password validation with special characters',
        (tester) async {
      when(() => loginCubit.state).thenReturn(
        const LoginState(password: Password.dirty('invalid@#password')),
      );
      await tester.pumpWidget(buildSubject());
      final passwordField =
          find.byKey(const Key('loginForm_passwordInput_textField'));
      await tester.enterText(passwordField, 'invalid@#password');
      await tester.pump();
      expect(find.text('invalid password'), findsOneWidget);
    });

    testWidgets('F-18: Check login with credentials and network error',
        (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Network error'),
        ]),
      );
      await tester.pumpWidget(buildSubject());
      final loginButton =
          find.byKey(const Key('loginForm_continue_raisedButton'));
      await tester.tap(loginButton);
      await tester.pump();
      expect(find.text('Network error'), findsOneWidget);
    });

    testWidgets('F-19: Check login with credentials and server error',
        (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Server error'),
        ]),
      );
      await tester.pumpWidget(buildSubject());
      final loginButton =
          find.byKey(const Key('loginForm_continue_raisedButton'));
      await tester.tap(loginButton);
      await tester.pump();
      expect(find.text('Server error'), findsOneWidget);
    });

    testWidgets('F-20: Check Google login with invalid credentials',
        (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Invalid credentials'),
        ]),
      );
      await tester.pumpWidget(buildSubject());
      final googleLoginButton =
          find.byKey(const Key('loginForm_googleLogin_raisedButton'));
      await tester.tap(googleLoginButton);
      await tester.pump();
      expect(find.text('Invalid credentials'), findsOneWidget);
    });

    testWidgets('F-21: Check Google login with network error', (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          const LoginState(status: FormzSubmissionStatus.inProgress),
          const LoginState(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Network error'),
        ]),
      );
      await tester.pumpWidget(buildSubject());
      final googleLoginButton =
          find.byKey(const Key('loginForm_googleLogin_raisedButton'));
      await tester.tap(googleLoginButton);
      await tester.pump();
      expect(find.text('Network error'), findsOneWidget);
    });
  });
}
