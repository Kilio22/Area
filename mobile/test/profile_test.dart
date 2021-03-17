import 'package:area/exceptions/bad_token_exception.dart';
import 'package:area/models/user.dart';
import 'package:area/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock_area_service.dart';
import 'mock_navigator_observer.dart';

void main() {
  group("Profile", () {
    NavigatorObserver mockObserver;
    MockAreaService mockAreaService;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      mockAreaService = MockAreaService();
    });

    _loadWidget(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MyProfilePage(mockAreaService),
        navigatorObservers: [mockObserver],
      ));
      await tester.pump();
    }

    _userProfile(WidgetTester tester) async {
      when(mockAreaService.getUserProfile()).thenAnswer((_) async {
        return User("", "test", "test@epitech.eu", ["twitter", "github", "microsoft"], true);
      });
      await _loadWidget(tester);

      expect(find.byWidgetPredicate((widget) => widget is MaterialButton && widget.enabled), findsNWidgets(1));
      expect(find.byWidgetPredicate((widget) => widget is MaterialButton && !widget.enabled), findsNWidgets(3));
    }

    _badTokenException(WidgetTester tester) async {
      when(mockAreaService.getUserProfile()).thenThrow(BadTokenException());
      await _loadWidget(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    }

    _editUsername(WidgetTester tester) async {
      when(mockAreaService.getUserProfile()).thenAnswer((_) async {
        return User("", "test", "test@epitech.eu", ["twitter", "github", "microsoft"], false);
      });
      await _loadWidget(tester);

      final editUsernameButton = find.byKey(Key("edit_username"));
      expect(editUsernameButton, findsOneWidget);

      await tester.tap(editUsernameButton);
      await tester.pumpAndSettle();

      final editUsernameInput = find.byKey(Key("edit_username_input"));
      final submitButton = find.text("OK");
      expect(editUsernameInput, findsOneWidget);
      expect(submitButton, findsOneWidget);

      await tester.enterText(editUsernameInput, "kilio");
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.updateUsernameEmail(any)).called(1);
      expect(find.text("kilio"), findsOneWidget);
    }

    _editEmail(WidgetTester tester) async {
      when(mockAreaService.getUserProfile()).thenAnswer((_) async {
        return User("", "test", "test@epitech.eu", ["twitter", "github", "microsoft"], false);
      });
      await _loadWidget(tester);

      final editEmailButton = find.byKey(Key("edit_email"));
      expect(editEmailButton, findsOneWidget);

      await tester.tap(editEmailButton);
      await tester.pumpAndSettle();

      final editUsernameInput = find.byKey(Key("edit_email_input"));
      final submitButton = find.text("OK");
      expect(editUsernameInput, findsOneWidget);
      expect(submitButton, findsOneWidget);

      await tester.enterText(editUsernameInput, "test@test.com");
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.updateUsernameEmail(any)).called(1);
      expect(find.text("test@test.com"), findsOneWidget);
    }

    _editPassword(WidgetTester tester) async {
      when(mockAreaService.getUserProfile()).thenAnswer((_) async {
        return User("", "test", "test@epitech.eu", ["twitter", "github", "microsoft"], false);
      });
      await _loadWidget(tester);

      final editPasswordButton = find.text("Change password");
      expect(editPasswordButton, findsOneWidget);

      await tester.tap(editPasswordButton);
      await tester.pumpAndSettle();

      final editPasswordInput = find.byKey(Key("edit_password_input"));
      final editPasswordConfirmInput = find.byKey(Key("edit_password_confirm_input"));
      final submitButton = find.text("OK");
      expect(editPasswordInput, findsOneWidget);
      expect(submitButton, findsOneWidget);

      await tester.enterText(editPasswordInput, "mdrmdr");
      await tester.enterText(editPasswordConfirmInput, "mdrmdr");
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.updatePassword("mdrmdr")).called(1);
    }

    testWidgets("User profile", (WidgetTester tester) async {
      await _userProfile(tester);
    });

    testWidgets("Edit username", (WidgetTester tester) async {
      await _editUsername(tester);
    });

    testWidgets("Edit email", (WidgetTester tester) async {
      await _editEmail(tester);
    });

    testWidgets("Edit password", (WidgetTester tester) async {
      await _editPassword(tester);
    });

    testWidgets("Bad token exception", (WidgetTester tester) async {
      await _badTokenException(tester);
    });
  });
}
