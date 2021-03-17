import 'package:area/area_form.dart';
import 'package:area/exceptions/bad_response_exception.dart';
import 'package:area/exceptions/bad_token_exception.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'mock_area_service.dart';
import 'mock_navigator_observer.dart';

void main() {
  group("Area form", () {
    NavigatorObserver mockObserver;
    MockAreaService mockAreaService;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      mockAreaService = MockAreaService();
    });

    _loadWidget(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: AreaFormPage(mockAreaService),
        navigatorObservers: [mockObserver],
      ));
      await tester.pumpAndSettle();
    }

    _tapWidgetByKey(WidgetTester tester, Key key) async {
      final widget = find.byKey(key);
      expect(widget, findsOneWidget);

      await tester.tap(widget);
      await tester.pumpAndSettle();
    }

    _chooseDropdownOption(WidgetTester tester, String toChoose) async {
      final items = find.text(toChoose);
      expect(items, findsWidgets);

      await tester.tap(items.last);
      await tester.pumpAndSettle();
    }

    _writeTextInWidgetByKey(WidgetTester tester, Key key, String value) async {
      final input = find.byKey(key);
      expect(input, findsOneWidget);

      await tester.enterText(input, value);
      await tester.pumpAndSettle();
    }

    _completeAreaPart(WidgetTester tester, Key servicesDropdownKey, String serviceName, Key optionsDropdownKey, String optionName,
        Map<Key, String> inputs) async {
      await _tapWidgetByKey(tester, servicesDropdownKey);
      await _chooseDropdownOption(tester, serviceName);
      await _tapWidgetByKey(tester, optionsDropdownKey);
      await _chooseDropdownOption(tester, optionName);
      for (final entry in inputs.entries) {
        await _writeTextInWidgetByKey(tester, entry.key, entry.value);
      }
    }

    _createAreaTimerTwitter(WidgetTester tester) async {
      when(mockAreaService.isConnectedToService("Twitter")).thenAnswer((_) async {
        return true;
      });
      await _loadWidget(tester);

      // ACTION
      await _completeAreaPart(
          tester, Key("action_dropdown"), "Timer", Key("action_options_dropdown"), "every_hour", {Key("input_every_hour_minute"): "42"});

      // Scrolling up
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0.0, -800));
      await tester.pumpAndSettle();

      // REACTION
      await _completeAreaPart(tester, Key("reaction_dropdown"), "Twitter", Key("reaction_options_dropdown"), "post_tweet",
          {Key("input_post_tweet_body"): "test"});

      // Scrolling up
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0.0, -800));
      await tester.pumpAndSettle();

      final submitButton = find.byWidgetPredicate((widget) => widget is RoundedLoadingButton && widget.onPressed != null);
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.addArea(any)).called(1);
      expect(find.byType(AreaFormPage), findsNothing);
    }

    _createAreaTwitterGithub(WidgetTester tester) async {
      when(mockAreaService.isConnectedToService("Twitter")).thenAnswer((_) async {
        return true;
      });
      when(mockAreaService.isConnectedToService("Github")).thenAnswer((_) async {
        return true;
      });
      await _loadWidget(tester);

      // ACTION
      await _completeAreaPart(
          tester, Key("action_dropdown"), "Timer", Key("action_options_dropdown"), "every_hour", {Key("input_every_hour_minute"): "42"});

      // Scrolling up
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0.0, -800));
      await tester.pumpAndSettle();

      // REACTION
      await _completeAreaPart(tester, Key("reaction_dropdown"), "Github", Key("reaction_options_dropdown"), "open_issue", {
        Key("input_open_issue_owner"): "EliottPal",
        Key("input_open_issue_repo"): "Dashboard_2020",
        Key("input_open_issue_title"): "Test",
        Key("input_open_issue_body"): "Test"
      });

      // Scrolling up
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0.0, -800));
      await tester.pumpAndSettle();

      final submitButton = find.byWidgetPredicate((widget) => widget is RoundedLoadingButton && widget.onPressed != null);
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.addArea(any)).called(1);
      expect(find.byType(AreaFormPage), findsNothing);
    }

    _createAreaDiscordGoogleBadResponseError(WidgetTester tester) async {
      when(mockAreaService.isConnectedToService("Twitter")).thenAnswer((_) async {
        return true;
      });
      when(mockAreaService.addArea(any)).thenThrow(BadResponseException());
      await _loadWidget(tester);

      // ACTION
      await _completeAreaPart(
          tester, Key("action_dropdown"), "Google", Key("action_options_dropdown"), "new_video", {Key("input_new_video_id"): "42"});

      // Scrolling up
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0.0, -800));
      await tester.pumpAndSettle();

      // REACTION
      await _tapWidgetByKey(tester, Key("reaction_dropdown"));
      await _chooseDropdownOption(tester, "Discord");

      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();

      await _tapWidgetByKey(tester, Key("reaction_options_dropdown"));
      await _chooseDropdownOption(tester, "post_message");
      for (final entry in {Key("input_post_message_id"): "42", Key("input_post_message_body"): "test"}.entries) {
        await _writeTextInWidgetByKey(tester, entry.key, entry.value);
      }

      // Scrolling up
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0.0, -800));
      await tester.pumpAndSettle();

      final submitButton = find.byWidgetPredicate((widget) => widget is RoundedLoadingButton && widget.onPressed != null);
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.addArea(any)).called(1);
      expect(find.byType(AreaFormPage), findsOneWidget);
    }

    _createAreaMicrosoftTwitterBadTokenError(WidgetTester tester) async {
      when(mockAreaService.isConnectedToService("Twitter")).thenAnswer((_) async {
        return true;
      });
      when(mockAreaService.isConnectedToService("Microsoft")).thenAnswer((_) async {
        return true;
      });
      when(mockAreaService.addArea(any)).thenThrow(BadTokenException());
      await _loadWidget(tester);

      // ACTION
      await _completeAreaPart(tester, Key("action_dropdown"), "Microsoft", Key("action_options_dropdown"), "incoming_mail", {});

      // Scrolling up
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0.0, -800));
      await tester.pumpAndSettle();

      // REACTION
      await _completeAreaPart(tester, Key("reaction_dropdown"), "Twitter", Key("reaction_options_dropdown"), "post_tweet",
          {Key("input_post_tweet_body"): "test"});

      // Scrolling up
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0.0, -800));
      await tester.pumpAndSettle();

      final submitButton = find.byWidgetPredicate((widget) => widget is RoundedLoadingButton && widget.onPressed != null);
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.addArea(any)).called(1);
      expect(find.byType(AreaFormPage), findsOneWidget);
    }

    _createBadArea(WidgetTester tester) async {
      when(mockAreaService.isConnectedToService("Twitter")).thenAnswer((_) async {
        return true;
      });
      await _loadWidget(tester);

      // ACTION
      await _completeAreaPart(
          tester, Key("action_dropdown"), "Timer", Key("action_options_dropdown"), "every_hour", {Key("input_every_hour_minute"): "422"});

      // REACTION
      await _completeAreaPart(tester, Key("reaction_dropdown"), "Twitter", Key("reaction_options_dropdown"), "post_tweet",
          {Key("input_post_tweet_body"): "testttt"});

      final submitButton = find.byWidgetPredicate((widget) => widget is RoundedLoadingButton && widget.onPressed != null);
      expect(submitButton, findsNothing);
    }

    _notConnectedToService(WidgetTester tester) async {
      when(mockAreaService.isConnectedToService("Twitter")).thenAnswer((_) async {
        return false;
      });
      await _loadWidget(tester);

      // ACTION
      await _completeAreaPart(
          tester, Key("action_dropdown"), "Timer", Key("action_options_dropdown"), "every_hour", {Key("input_every_hour_minute"): "422"});

      // REACTION
      await _tapWidgetByKey(tester, Key("reaction_dropdown"));
      await _chooseDropdownOption(tester, "Twitter");

      expect(find.byWidgetPredicate((widget) => widget is DropdownButton && widget.value == null), findsOneWidget);
      final submitButton = find.byWidgetPredicate((widget) => widget is RoundedLoadingButton && widget.onPressed != null);
      expect(submitButton, findsNothing);
    }

    testWidgets("Create area - Timer + Twitter", (WidgetTester tester) async {
      await _createAreaTimerTwitter(tester);
    });

    testWidgets("Create area - Discord + Google bad response error", (WidgetTester tester) async {
      await _createAreaDiscordGoogleBadResponseError(tester);
    });

    testWidgets("Create area - Twitter + Github", (WidgetTester tester) async {
      await _createAreaTwitterGithub(tester);
    });

    testWidgets("Create area - Microsoft + Twitter bad token error", (WidgetTester tester) async {
      await _createAreaMicrosoftTwitterBadTokenError(tester);
    });

    testWidgets("Create bad area", (WidgetTester tester) async {
      await _createBadArea(tester);
    });

    testWidgets("Not connected to selected service", (WidgetTester tester) async {
      await _notConnectedToService(tester);
    });
  });
}
