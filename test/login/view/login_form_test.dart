// ignore_for_file: prefer_const_constructors
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/login/login.dart';
import 'package:flutter_firebase_login/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginCubit extends Mock implements LoginCubit {}

void main() {
  late LoginCubit loginCubit;

  setUp(() {
    loginCubit = MockLoginCubit();
    when(() => loginCubit.state).thenReturn(LoginState());
  });

  group('LoginForm', () {
    testWidgets('renders LoginForm', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      expect(find.byType(LoginForm), findsOneWidget);
    });

    testWidgets('renders email input', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      expect(find.byKey(Key('loginForm_emailInput_textField')), findsOneWidget);
    });

    testWidgets('renders password input', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      expect(
          find.byKey(Key('loginForm_passwordInput_textField')), findsOneWidget);
    });

    testWidgets('renders login button', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      expect(
          find.byKey(Key('loginForm_continue_raisedButton')), findsOneWidget);
    });

    testWidgets('renders Google login button', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      expect(find.byKey(Key('loginForm_googleLogin_raisedButton')),
          findsOneWidget);
    });

    testWidgets('renders sign up button', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      expect(find.byKey(Key('loginForm_createAccount_flatButton')),
          findsOneWidget);
    });

    testWidgets('calls emailChanged when email is updated', (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      await tester.enterText(find.byKey(Key('loginForm_emailInput_textField')),
          'test@example.com');
      verify(() => loginCubit.emailChanged('test@example.com')).called(1);
    });

    testWidgets('calls passwordChanged when password is updated',
        (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      await tester.enterText(
          find.byKey(Key('loginForm_passwordInput_textField')), 'password');
      verify(() => loginCubit.passwordChanged('password')).called(1);
    });

    testWidgets('calls logInWithCredentials when login button is pressed',
        (tester) async {
      when(() => loginCubit.state).thenReturn(LoginState(isValid: true));
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      await tester.tap(find.byKey(Key('loginForm_continue_raisedButton')));
      verify(() => loginCubit.logInWithCredentials()).called(1);
    });

    testWidgets('calls logInWithGoogle when Google login button is pressed',
        (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      await tester.tap(find.byKey(Key('loginForm_googleLogin_raisedButton')));
      verify(() => loginCubit.logInWithGoogle()).called(1);
    });

    testWidgets('navigates to SignUpPage when sign up button is pressed',
        (tester) async {
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      await tester.tap(find.byKey(Key('loginForm_createAccount_flatButton')));
      await tester.pumpAndSettle();
      expect(find.byType(SignUpPage), findsOneWidget);
    });

    testWidgets('shows error snackbar when login fails', (tester) async {
      whenListen(
        loginCubit,
        Stream.fromIterable([
          LoginState(
              status: FormzSubmissionStatus.failure,
              errorMessage: 'Authentication Failure')
        ]),
      );
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      await tester.pump();
      expect(find.text('Authentication Failure'), findsOneWidget);
    });

    testWidgets('shows CircularProgressIndicator when login is in progress',
        (tester) async {
      when(() => loginCubit.state)
          .thenReturn(LoginState(status: FormzSubmissionStatus.inProgress));
      await tester.pumpWidget(
        BlocProvider.value(
          value: loginCubit,
          child: MaterialApp(home: Scaffold(body: LoginForm())),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
