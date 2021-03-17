import 'package:area/area_form.dart';
import 'package:area/dashboard.dart';
import 'package:area/models/area.dart';
import 'package:area/update_area_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock_area_service.dart';
import 'mock_navigator_observer.dart';

void main() {
  group("Dashboard page", () {
    NavigatorObserver mockObserver;
    MockAreaService mockAreaService;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      mockAreaService = MockAreaService();
    });

    _loadWidget(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: DashboardPage(mockAreaService),
        navigatorObservers: [mockObserver],
      ));
      await tester.pumpAndSettle();
    }

    _displayAreaList(WidgetTester tester) async {
      when(mockAreaService.getAreaList()).thenAnswer((_) async => ([
            Area("", AreaAction("Github", "new_issue", {"owner": "EliottPal", "repo": "Dashboard_2020"}),
                AreaReaction("Microsoft", "send_mail", {"to": "eliott.palueau@epitech.eu", "subject": "test", "body": "test"})),
            Area("", AreaAction("Google", "new_video", {"id": "UCB3Vqxt5hVRKKWivG_OI4DA"}),
                AreaReaction("Discord", "post_message", {"id": "798196713449979954", "body": "test"})),
            Area("", AreaAction("Timer", "every_hour", {"minute": 42}),
                AreaReaction("Microsoft", "send_mail", {"to": "eliott.palueau@epitech.eu", "subject": "test", "body": "test"})),
            Area("", AreaAction("Timer", "every_hour", {"minute": 42}),
                AreaReaction("Microsoft", "send_mail", {"to": "eliott.palueau@epitech.eu", "subject": "test", "body": "test"}))
          ]));
      await _loadWidget(tester);

      verify(mockAreaService.getAreaList()).called(1);
      expect(find.byKey(Key("card_github_microsoft")), findsOneWidget);
      expect(find.byKey(Key("card_google_discord")), findsOneWidget);
      expect(find.byKey(Key("card_timer_microsoft")), findsWidgets);
    }

    _badAreaList(WidgetTester tester) async {
      when(mockAreaService.getAreaList()).thenAnswer((_) async => ([
            Area("", AreaAction("mdr", "every_hour", {"minute": 42}),
                AreaReaction("Microsoft", "send_mail", {"to": "eliott.palueau@epitech.eu", "subject": "test", "body": "test"})),
            Area("", AreaAction("Timer", "every_hour", {"minute": 42}),
                AreaReaction("lol", "send_mail", {"to": "eliott.palueau@epitech.eu", "subject": "test", "body": "test"})),
            Area("", AreaAction("", "every_hour", {"minute": 42}),
                AreaReaction("Microsoft", "send_mail", {"to": "eliott.palueau@epitech.eu", "subject": "test", "body": "test"}))
          ]));
      await _loadWidget(tester);

      verify(mockAreaService.getAreaList()).called(1);
      expect(find.text("Nothing to display"), findsWidgets);
      expect(find.byType(ListView), findsNothing);
    }

    _nothingToDisplay(WidgetTester tester) async {
      verify(mockAreaService.getAreaList()).called(1);
      expect(find.text("Nothing to display"), findsWidgets);
      expect(find.byType(ListView), findsNothing);
    }

    _openAreaForm(WidgetTester tester) async {
      final addButton = find.byIcon(Icons.add);
      expect(addButton, findsOneWidget);

      await tester.tap(addButton);
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any)).called(2);
      expect(find.byType(DashboardPage), findsNothing);
      expect(find.byType(AreaFormPage), findsOneWidget);
    }

    _openUpdateAreaForm(WidgetTester tester) async {
      when(mockAreaService.getAreaList()).thenAnswer((_) async => ([
            Area("", AreaAction("Github", "new_issue", {"owner": "EliottPal", "repo": "Dashboard_2020"}),
                AreaReaction("Microsoft", "send_mail", {"to": "eliott.palueau@epitech.eu", "subject": "test", "body": "test"})),
          ]));
      await _loadWidget(tester);

      final editButton = find.byIcon(Icons.edit);
      expect(editButton, findsOneWidget);

      await tester.tap(editButton);
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any)).called(2);
      expect(find.byType(DashboardPage), findsNothing);
      expect(find.byType(UpdateAreaFormPage), findsOneWidget);
    }

    _deleteArea(WidgetTester tester) async {
      when(mockAreaService.getAreaList()).thenAnswer((_) async => ([
            Area("", AreaAction("Github", "new_issue", {"owner": "EliottPal", "repo": "Dashboard_2020"}),
                AreaReaction("Microsoft", "send_mail", {"to": "eliott.palueau@epitech.eu", "subject": "test", "body": "test"})),
          ]));
      await _loadWidget(tester);

      final deleteButton = find.byIcon(Icons.delete_outline);
      expect(deleteButton, findsOneWidget);

      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.deleteArea(any)).called(1);
      verify(mockAreaService.getAreaList()).called(2);
    }

    testWidgets("Valid area list", (WidgetTester tester) async {
      await _displayAreaList(tester);
    });

    testWidgets("Bad area list", (WidgetTester tester) async {
      await _badAreaList(tester);
    });

    testWidgets("Nothing to display", (WidgetTester tester) async {
      await _loadWidget(tester);

      await _nothingToDisplay(tester);
    });

    testWidgets("Open to area form", (WidgetTester tester) async {
      await _loadWidget(tester);

      await _openAreaForm(tester);
    });

    testWidgets("Open update area form", (WidgetTester tester) async {
      await _openUpdateAreaForm(tester);
    });

    testWidgets("Delete area", (WidgetTester tester) async {
      await _deleteArea(tester);
    });
  });
}
