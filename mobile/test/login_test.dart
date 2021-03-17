// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:area/exceptions/bad_response_exception.dart';
import 'package:area/exceptions/wrong_email_password_combination_exception.dart';
import 'package:area/login.dart';
import 'package:area/main_page.dart';
import 'package:area/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'mock_area_service.dart';
import 'mock_navigator_observer.dart';

void main() {
  group("Login page", () {
    NavigatorObserver mockObserver;
    MockAreaService mockAreaService;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      mockAreaService = MockAreaService();
    });

    _loadWidget(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Login(mockAreaService),
        navigatorObservers: [mockObserver],
      ));
      await tester.pumpAndSettle();
    }

    Future<Null> _signIn(WidgetTester tester) async {
      final signInButton = find.widgetWithText(RoundedLoadingButton, "Sign in");
      final emailTextField = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Email");
      final passwordTextField =
          find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Password" && widget.obscureText == true);
      expect(signInButton, findsOneWidget);
      expect(emailTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);

      await tester.enterText(emailTextField, "kylian.balan@epitech.eu");
      await tester.enterText(passwordTextField, "heinnnn");

      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.signInWithCredentials("kylian.balan@epitech.eu", "heinnnn")).called(1);
      verify(mockObserver.didPush(any, any)).called(2);
      expect(find.byType(MyMainPage), findsOneWidget);
    }

    Future<Null> _formError(WidgetTester tester) async {
      final signUpButton = find.widgetWithText(RoundedLoadingButton, "Sign in");
      final emailTextField = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Email");
      final passwordTextField =
          find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Password" && widget.obscureText == true);
      expect(signUpButton, findsOneWidget);
      expect(emailTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);

      await tester.enterText(emailTextField, "kylian.balanepitech.eu");
      await tester.enterText(passwordTextField, "hein");

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      verifyNever(mockAreaService.signInWithCredentials("kylian.balanepitech.eu", "hein"));
      expect(find.byType(Login), findsOneWidget);
    }

    Future<Null> _goToRegisterPage(WidgetTester tester) async {
      final goToSignUpPageButton = find.widgetWithText(TextButton, "Don't have an account? Sign up");
      expect(goToSignUpPageButton, findsOneWidget);

      await tester.tap(goToSignUpPageButton);
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any)).called(2);
      expect(find.byType(Register), findsOneWidget);
    }

    Future<Null> _wrongEmailPasswordCombinationError(WidgetTester tester) async {
      when(mockAreaService.signInWithCredentials("kylian.balan@epitech.eu", "heinnnn")).thenThrow(WrongEmailPasswordCombinationException());
      await _loadWidget(tester);

      final signInButton = find.widgetWithText(RoundedLoadingButton, "Sign in");
      final emailTextField = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Email");
      final passwordTextField =
          find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Password" && widget.obscureText == true);
      expect(signInButton, findsOneWidget);
      expect(emailTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);

      await tester.enterText(emailTextField, "kylian.balan@epitech.eu");
      await tester.enterText(passwordTextField, "heinnnn");

      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.signInWithCredentials("kylian.balan@epitech.eu", "heinnnn")).called(1);
      expect(find.byType(Login), findsOneWidget);
    }

    Future<Null> _badResponseError(WidgetTester tester) async {
      when(mockAreaService.signInWithCredentials("kylian.balan@epitech.eu", "heinnnn")).thenThrow(BadResponseException());
      await _loadWidget(tester);

      final signInButton = find.widgetWithText(RoundedLoadingButton, "Sign in");
      final emailTextField = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Email");
      final passwordTextField =
          find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Password" && widget.obscureText == true);
      expect(signInButton, findsOneWidget);
      expect(emailTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);

      await tester.enterText(emailTextField, "kylian.balan@epitech.eu");
      await tester.enterText(passwordTextField, "heinnnn");

      await tester.tap(signInButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.signInWithCredentials("kylian.balan@epitech.eu", "heinnnn")).called(1);
      expect(find.byType(Login), findsOneWidget);
    }

    testWidgets("Simple sign in", (WidgetTester tester) async {
      await _loadWidget(tester);

      await _signIn(tester);
    });

    testWidgets("Form error", (WidgetTester tester) async {
      await _loadWidget(tester);

      await _formError(tester);
    });

    testWidgets("Go to register page", (WidgetTester tester) async {
      await _loadWidget(tester);

      await _goToRegisterPage(tester);
    });

    testWidgets("Wrong email password combination error", (WidgetTester tester) async {
      await _wrongEmailPasswordCombinationError(tester);
    });

    testWidgets("Bad response error", (WidgetTester tester) async {
      await _badResponseError(tester);
    });
  });
}
