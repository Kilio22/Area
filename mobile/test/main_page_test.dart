import 'package:area/about.dart';
import 'package:area/dashboard.dart';
import 'package:area/main_page.dart';
import 'package:area/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mock_navigator_observer.dart';

void main() {
  group("Main page", () {
    NavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    _loadWidget(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: MyMainPage(),
        navigatorObservers: [mockObserver],
      ));
      await tester.pumpAndSettle();
    }

    _isWidgetValid(WidgetTester tester) {
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text("Dashboard"), findsWidgets);
      expect(find.text("Users"), findsOneWidget);
      expect(find.text("Profile"), findsOneWidget);
      expect(find.byIcon(Icons.info_outline), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsNothing);
      expect(find.byType(DashboardPage), findsOneWidget);
    }

    _goToAboutPage(WidgetTester tester) async {
      final aboutIcon = find.byIcon(Icons.info_outline);
      expect(aboutIcon, findsOneWidget);

      await tester.tap(aboutIcon);
      await tester.pumpAndSettle();

      verify(mockObserver.didPush(any, any)).called(2);
      expect(find.byIcon(Icons.info_outline), findsNothing);
      expect(find.byType(AboutPage), findsOneWidget);
    }

    _goToProfile(WidgetTester tester) async {
      final profileItem = find.text("Profile");
      expect(profileItem, findsOneWidget);

      await tester.tap(profileItem);
      await tester.pump();

      expect(find.byIcon(Icons.info_outline), findsNothing);
      expect(find.byIcon(Icons.logout), findsOneWidget);
      expect(find.byType(MyProfilePage), findsOneWidget);
    }

    _logout(WidgetTester tester) async {
      final logoutButton = find.byIcon(Icons.logout);
      expect(logoutButton, findsOneWidget);

      await tester.tap(logoutButton);
      await tester.pump();

      final confirmButton = find.text("Yes");
      expect(confirmButton, findsOneWidget);

      await tester.tap(confirmButton);
      await tester.pump();

      verify(mockObserver.didPush(any, any)).called(2);
    }

    testWidgets("Is widget valid", (WidgetTester tester) async {
      await _loadWidget(tester);

      _isWidgetValid(tester);
    });

    testWidgets("Go to about page", (WidgetTester tester) async {
      await _loadWidget(tester);

      await _goToAboutPage(tester);
    });

    testWidgets("Go to profile", (WidgetTester tester) async {
      await _loadWidget(tester);

      await _goToProfile(tester);
    });

    testWidgets("Logout", (WidgetTester tester) async {
      await _loadWidget(tester);

      await _goToProfile(tester);
      await _logout(tester);
    });
  });
}
