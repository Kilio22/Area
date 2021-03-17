import 'package:area/exceptions/already_exists_exception.dart';
import 'package:area/exceptions/bad_response_exception.dart';
import 'package:area/main_page.dart';
import 'package:area/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'mock_area_service.dart';
import 'mock_navigator_observer.dart';

void main() {
  group("Register page", () {
    NavigatorObserver mockObserver;
    MockAreaService mockAreaService;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      mockAreaService = MockAreaService();
    });

    _loadWidget(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Register(mockAreaService),
        navigatorObservers: [mockObserver],
      ));
      await tester.pumpAndSettle();
    }

    Future<Null> _signUp(WidgetTester tester) async {
      final signUpButton = find.widgetWithText(RoundedLoadingButton, "Sign up");
      final usernameTextField = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Username");
      final emailTextField = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Email");
      final passwordTextField =
          find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Password" && widget.obscureText == true);
      expect(signUpButton, findsOneWidget);
      expect(usernameTextField, findsOneWidget);
      expect(emailTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);

      await tester.enterText(usernameTextField, "kilio22");
      await tester.enterText(emailTextField, "kylian.balan@epitech.eu");
      await tester.enterText(passwordTextField, "heinnnn");

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.signUp("kilio22", "kylian.balan@epitech.eu", "heinnnn")).called(1);
      verify(mockObserver.didPush(any, any)).called(2);
      expect(find.byType(MyMainPage), findsOneWidget);
    }

    Future<Null> _formError(WidgetTester tester) async {
      final signUpButton = find.widgetWithText(RoundedLoadingButton, "Sign up");
      final usernameTextField = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Username");
      final emailTextField = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Email");
      final passwordTextField =
          find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Password" && widget.obscureText == true);
      expect(signUpButton, findsOneWidget);
      expect(usernameTextField, findsOneWidget);
      expect(emailTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);

      await tester.enterText(usernameTextField, "ki");
      await tester.enterText(emailTextField, "kylian.balanepitech.eu");
      await tester.enterText(passwordTextField, "hein");

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      verifyNever(mockAreaService.signUp("ki", "kylian.balanepitech.eu", "hein"));
      expect(find.byType(Register), findsOneWidget);
    }

    Future<Null> _alreadyExistingUserError(WidgetTester tester) async {
      when(mockAreaService.signUp("kilio22", "kylian.balan@epitech.eu", "heinnnn")).thenThrow(AlreadyExistsException());
      await _loadWidget(tester);

      final signUpButton = find.widgetWithText(RoundedLoadingButton, "Sign up");
      final usernameTextField = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Username");
      final emailTextField = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Email");
      final passwordTextField =
          find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Password" && widget.obscureText == true);
      expect(signUpButton, findsOneWidget);
      expect(usernameTextField, findsOneWidget);
      expect(emailTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);

      await tester.enterText(usernameTextField, "kilio22");
      await tester.enterText(emailTextField, "kylian.balan@epitech.eu");
      await tester.enterText(passwordTextField, "heinnnn");

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.signUp("kilio22", "kylian.balan@epitech.eu", "heinnnn")).called(1);
      expect(find.byType(Register), findsOneWidget);
    }

    Future<Null> _badResponseError(WidgetTester tester) async {
      when(mockAreaService.signUp("kilio22", "kylian.balan@epitech.eu", "heinnnn")).thenThrow(BadResponseException());
      await _loadWidget(tester);

      final signUpButton = find.widgetWithText(RoundedLoadingButton, "Sign up");
      final usernameTextField = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Username");
      final emailTextField = find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Email");
      final passwordTextField =
          find.byWidgetPredicate((widget) => widget is TextField && widget.decoration.hintText == "Password" && widget.obscureText == true);
      expect(signUpButton, findsOneWidget);
      expect(usernameTextField, findsOneWidget);
      expect(emailTextField, findsOneWidget);
      expect(passwordTextField, findsOneWidget);

      await tester.enterText(usernameTextField, "kilio22");
      await tester.enterText(emailTextField, "kylian.balan@epitech.eu");
      await tester.enterText(passwordTextField, "heinnnn");

      await tester.tap(signUpButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.signUp("kilio22", "kylian.balan@epitech.eu", "heinnnn")).called(1);
      expect(find.byType(Register), findsOneWidget);
    }

    testWidgets("Simple sign up", (WidgetTester tester) async {
      await _loadWidget(tester);

      await _signUp(tester);
    });

    testWidgets("Form error", (WidgetTester tester) async {
      await _loadWidget(tester);

      await _formError(tester);
    });

    testWidgets("Already existing user error", (WidgetTester tester) async {
      await _alreadyExistingUserError(tester);
    });

    testWidgets("Bad response error", (WidgetTester tester) async {
      await _badResponseError(tester);
    });
  });
}
