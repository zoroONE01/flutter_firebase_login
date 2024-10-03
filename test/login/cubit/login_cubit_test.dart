import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_firebase_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  group('LoginCubit', () {
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
    });

    test('initial state is LoginState', () {
      expect(LoginCubit(authenticationRepository).state, const LoginState());
    });

    blocTest<LoginCubit, LoginState>(
      'F-14: emits [LoginState] with updated email when emailChanged is called',
      build: () => LoginCubit(authenticationRepository),
      act: (cubit) => cubit.emailChanged('test@example.com'),
      expect: () => [
        const LoginState(
          email: Email.dirty('test@example.com'),
          isValid: false,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-15: emits [LoginState] with updated password when passwordChanged is called',
      build: () => LoginCubit(authenticationRepository),
      act: (cubit) => cubit.passwordChanged('password123'),
      expect: () => [
        const LoginState(
          password: Password.dirty('password123'),
          isValid: false,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-3: emits [inProgress, success] when logInWithCredentials succeeds',
      build: () => LoginCubit(authenticationRepository),
      setUp: () {
        when(() => authenticationRepository.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenAnswer((_) async {});
      },
      seed: () => const LoginState(
        email: Email.dirty('test@example.com'),
        password: Password.dirty('password123'),
        isValid: true,
      ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
          status: FormzSubmissionStatus.inProgress,
          isValid: true,
        ),
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
          status: FormzSubmissionStatus.success,
          isValid: true,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-5: emits [inProgress, failure] when logInWithCredentials fails',
      build: () => LoginCubit(authenticationRepository),
      setUp: () {
        when(() => authenticationRepository.logInWithEmailAndPassword(
                  email: any(named: 'email'),
                  password: any(named: 'password'),
                ))
            .thenThrow(LogInWithEmailAndPasswordFailure('Invalid credentials'));
      },
      seed: () => const LoginState(
        email: Email.dirty('test@example.com'),
        password: Password.dirty('password123'),
        isValid: true,
      ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
          status: FormzSubmissionStatus.inProgress,
          isValid: true,
        ),
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Invalid credentials',
          isValid: true,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-6: emits [inProgress, success] when logInWithGoogle succeeds',
      build: () => LoginCubit(authenticationRepository),
      setUp: () {
        when(() => authenticationRepository.logInWithGoogle())
            .thenAnswer((_) async {});
      },
      act: (cubit) => cubit.logInWithGoogle(),
      expect: () => [
        const LoginState(
          status: FormzSubmissionStatus.inProgress,
        ),
        const LoginState(
          status: FormzSubmissionStatus.success,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-8: emits [inProgress, failure] when logInWithGoogle fails',
      build: () => LoginCubit(authenticationRepository),
      setUp: () {
        when(() => authenticationRepository.logInWithGoogle())
            .thenThrow(LogInWithGoogleFailure('Google login failed'));
      },
      act: (cubit) => cubit.logInWithGoogle(),
      expect: () => [
        const LoginState(
          status: FormzSubmissionStatus.inProgress,
        ),
        const LoginState(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Google login failed',
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-9: emits [LoginState] with email validation error when email is empty',
      build: () => LoginCubit(authenticationRepository),
      act: (cubit) => cubit.emailChanged(''),
      expect: () => [
        const LoginState(
          email: Email.dirty(''),
          isValid: false,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-10: emits [LoginState] with password validation error when password is empty',
      build: () => LoginCubit(authenticationRepository),
      act: (cubit) => cubit.passwordChanged(''),
      expect: () => [
        const LoginState(
          password: Password.dirty(''),
          isValid: false,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-11: emits [inProgress, failure] when logInWithCredentials fails with invalid email',
      build: () => LoginCubit(authenticationRepository),
      setUp: () {
        when(() => authenticationRepository.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(LogInWithEmailAndPasswordFailure('Invalid email'));
      },
      seed: () => const LoginState(
        email: Email.dirty('invalid-email'),
        password: Password.dirty('password123'),
        isValid: true,
      ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [
        const LoginState(
          email: Email.dirty('invalid-email'),
          password: Password.dirty('password123'),
          status: FormzSubmissionStatus.inProgress,
          isValid: true,
        ),
        const LoginState(
          email: Email.dirty('invalid-email'),
          password: Password.dirty('password123'),
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Invalid email',
          isValid: true,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-12: emits [inProgress, failure] when logInWithCredentials fails with invalid password',
      build: () => LoginCubit(authenticationRepository),
      setUp: () {
        when(() => authenticationRepository.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(LogInWithEmailAndPasswordFailure('Invalid password'));
      },
      seed: () => const LoginState(
        email: Email.dirty('test@example.com'),
        password: Password.dirty('invalid-password'),
        isValid: true,
      ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('invalid-password'),
          status: FormzSubmissionStatus.inProgress,
          isValid: true,
        ),
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('invalid-password'),
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Invalid password',
          isValid: true,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-13: emits [inProgress, failure] when logInWithGoogle fails with network error',
      build: () => LoginCubit(authenticationRepository),
      setUp: () {
        when(() => authenticationRepository.logInWithGoogle())
            .thenThrow(LogInWithGoogleFailure('Network error'));
      },
      act: (cubit) => cubit.logInWithGoogle(),
      expect: () => [
        const LoginState(
          status: FormzSubmissionStatus.inProgress,
        ),
        const LoginState(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Network error',
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-18: emits [inProgress, failure] when logInWithCredentials fails with network error',
      build: () => LoginCubit(authenticationRepository),
      setUp: () {
        when(() => authenticationRepository.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(LogInWithEmailAndPasswordFailure('Network error'));
      },
      seed: () => const LoginState(
        email: Email.dirty('test@example.com'),
        password: Password.dirty('password123'),
        isValid: true,
      ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
          status: FormzSubmissionStatus.inProgress,
          isValid: true,
        ),
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Network error',
          isValid: true,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-19: emits [inProgress, failure] when logInWithCredentials fails with server error',
      build: () => LoginCubit(authenticationRepository),
      setUp: () {
        when(() => authenticationRepository.logInWithEmailAndPassword(
              email: any(named: 'email'),
              password: any(named: 'password'),
            )).thenThrow(LogInWithEmailAndPasswordFailure('Server error'));
      },
      seed: () => const LoginState(
        email: Email.dirty('test@example.com'),
        password: Password.dirty('password123'),
        isValid: true,
      ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
          status: FormzSubmissionStatus.inProgress,
          isValid: true,
        ),
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password123'),
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Server error',
          isValid: true,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-20: emits [inProgress, failure] when logInWithGoogle fails with invalid credentials',
      build: () => LoginCubit(authenticationRepository),
      setUp: () {
        when(() => authenticationRepository.logInWithGoogle())
            .thenThrow(LogInWithGoogleFailure('Invalid credentials'));
      },
      act: (cubit) => cubit.logInWithGoogle(),
      expect: () => [
        const LoginState(
          status: FormzSubmissionStatus.inProgress,
        ),
        const LoginState(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Invalid credentials',
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'F-21: emits [inProgress, failure] when logInWithGoogle fails with network error',
      build: () => LoginCubit(authenticationRepository),
      setUp: () {
        when(() => authenticationRepository.logInWithGoogle())
            .thenThrow(LogInWithGoogleFailure('Network error'));
      },
      act: (cubit) => cubit.logInWithGoogle(),
      expect: () => [
        const LoginState(
          status: FormzSubmissionStatus.inProgress,
        ),
        const LoginState(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'Network error',
        ),
      ],
    );
  });
}
