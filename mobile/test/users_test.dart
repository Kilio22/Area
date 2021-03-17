import 'package:area/models/user.dart';
import 'package:area/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock_area_service.dart';
import 'mock_navigator_observer.dart';

void main() {
  group("Users", () {
    NavigatorObserver mockObserver;
    MockAreaService mockAreaService;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      mockAreaService = MockAreaService();
    });

    _loadWidget(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Users(mockAreaService),
        navigatorObservers: [mockObserver],
      ));
      await tester.pump();
    }

    _displayUsers(WidgetTester tester) async {
      when(mockAreaService.getUsers()).thenAnswer((_) async =>
      ([
        User("id1", "kilio22", "test1@test.eu", [], false),
        User("id2", "kilio23", "test2@test.eu", [], false),
        User("id3", "kilio24", "test3@test.eu", [], false),
        User("id4", "kilio25", "test4@test.eu", [], false),
      ]));
      await _loadWidget(tester);

      verify(mockAreaService.getUsers()).called(1);
      expect(find.byKey(Key("card_id1")), findsOneWidget);
      expect(find.byKey(Key("card_id2")), findsOneWidget);
      expect(find.byKey(Key("card_id3")), findsWidgets);
      expect(find.byKey(Key("card_id4")), findsWidgets);
    }

    _nothingToDisplay(WidgetTester tester) async {
      verify(mockAreaService.getUsers()).called(1);
      expect(find.text("Nothing to display"), findsWidgets);
      expect(find.byType(ListView), findsNothing);
    }

    _deleteUser(WidgetTester tester) async {
      when(mockAreaService.getUsers()).thenAnswer((_) async =>
      ([
        User("id1", "kilio22", "test1@test.eu", [], false),
      ]));
      await _loadWidget(tester);

      final deleteButton = find.byIcon(Icons.delete_outline);
      expect(deleteButton, findsOneWidget);

      await tester.tap(deleteButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.deleteUser(any)).called(1);
      verify(mockAreaService.getUsers()).called(2);
    }


    testWidgets("Display users", (WidgetTester tester) async {
      await _displayUsers(tester);
    });

    testWidgets("Nothing to display", (WidgetTester tester) async {
      await _loadWidget(tester);

      await _nothingToDisplay(tester);
    });

    testWidgets("Delete user", (WidgetTester tester) async {
      await _deleteUser(tester);
    });
  });
}
