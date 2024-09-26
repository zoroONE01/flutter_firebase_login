// ignore_for_file: prefer_const_constructors
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_login/login/login.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  late AuthenticationRepository authenticationRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
  });

  group('LoginPage', () {
    test('has a route', () {
      expect(LoginPage.page(), isA<MaterialPage<void>>());
    });
  
    testWidgets('renders LoginPage', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(home: LoginPage()),
        ),
      );
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('renders AppBar with title', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(home: LoginPage()),
        ),
      );
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('renders LoginForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(home: LoginPage()),
        ),
      );
      expect(find.byType(LoginForm), findsOneWidget);
    });

    testWidgets('renders padding around LoginForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(home: LoginPage()),
        ),
      );
      final padding = tester.widget<Padding>(find.byType(Padding));
      expect(padding.padding, EdgeInsets.all(8));
    });

    testWidgets('provides LoginCubit to LoginForm', (tester) async {
      await tester.pumpWidget(
        RepositoryProvider.value(
          value: authenticationRepository,
          child: MaterialApp(home: LoginPage()),
        ),
      );
      final provider = find.byWidgetPredicate(
        (widget) => widget is BlocProvider<LoginCubit>,
      );
      expect(provider, findsOneWidget);
    });
  });
}
