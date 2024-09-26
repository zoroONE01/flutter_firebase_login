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
  late AuthenticationRepository authenticationRepository;
  late LoginCubit loginCubit;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    loginCubit = LoginCubit(authenticationRepository);
  });

  group('LoginCubit', () {
    test('initial state is LoginState', () {
      expect(loginCubit.state, const LoginState());
    });

    blocTest<LoginCubit, LoginState>(
      'emits [LoginState] with updated email when emailChanged is called',
      build: () => loginCubit,
      act: (cubit) => cubit.emailChanged('test@example.com'),
      expect: () => [
        const LoginState(
          email: Email.dirty('test@example.com'),
          isValid: false,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [LoginState] with updated password when passwordChanged is called',
      build: () => loginCubit,
      act: (cubit) => cubit.passwordChanged('password'),
      expect: () => [
        const LoginState(
          password: Password.dirty('password'),
          isValid: false,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [inProgress, success] when logInWithCredentials succeeds',
      setUp: () {
        when(
          () => authenticationRepository.logInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});
      },
      build: () => loginCubit,
      seed: () => const LoginState(
        email: Email.dirty('test@example.com'),
        password: Password.dirty('password'),
        isValid: true,
      ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password'),
          status: FormzSubmissionStatus.inProgress,
          isValid: true,
        ),
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password'),
          status: FormzSubmissionStatus.success,
          isValid: true,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [inProgress, failure] when logInWithCredentials fails',
      setUp: () {
        when(
          () => authenticationRepository.logInWithEmailAndPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(LogInWithEmailAndPasswordFailure('oops'));
      },
      build: () => loginCubit,
      seed: () => const LoginState(
        email: Email.dirty('test@example.com'),
        password: Password.dirty('password'),
        isValid: true,
      ),
      act: (cubit) => cubit.logInWithCredentials(),
      expect: () => [
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password'),
          status: FormzSubmissionStatus.inProgress,
          isValid: true,
        ),
        const LoginState(
          email: Email.dirty('test@example.com'),
          password: Password.dirty('password'),
          status: FormzSubmissionStatus.failure,
          errorMessage: 'oops',
          isValid: true,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [inProgress, success] when logInWithGoogle succeeds',
      setUp: () {
        when(
          () => authenticationRepository.logInWithGoogle(),
        ).thenAnswer((_) async {});
      },
      build: () => loginCubit,
      act: (cubit) => cubit.logInWithGoogle(),
      expect: () => [
        const LoginState(status: FormzSubmissionStatus.inProgress),
        const LoginState(status: FormzSubmissionStatus.success),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [inProgress, failure] when logInWithGoogle fails',
      setUp: () {
        when(
          () => authenticationRepository.logInWithGoogle(),
        ).thenThrow(LogInWithGoogleFailure('oops'));
      },
      build: () => loginCubit,
      act: (cubit) => cubit.logInWithGoogle(),
      expect: () => [
        const LoginState(status: FormzSubmissionStatus.inProgress),
        const LoginState(
          status: FormzSubmissionStatus.failure,
          errorMessage: 'oops',
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'emits [inProgress, failure] when logInWithGoogle fails due to generic exception',
      setUp: () {
        when(
          () => authenticationRepository.logInWithGoogle(),
        ).thenThrow(Exception('oops'));
      },
      build: () => loginCubit,
      act: (cubit) => cubit.logInWithGoogle(),
      expect: () => [
        const LoginState(status: FormzSubmissionStatus.inProgress),
        const LoginState(status: FormzSubmissionStatus.failure),
      ],
    );
  });
}
