import 'package:area/exceptions/bad_response_exception.dart';
import 'package:area/exceptions/bad_token_exception.dart';
import 'package:area/models/area.dart';
import 'package:area/update_area_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import 'mock_area_service.dart';
import 'mock_navigator_observer.dart';

void main() {
  group("Update area form", () {
    NavigatorObserver mockObserver;
    MockAreaService mockAreaService;

    setUp(() {
      mockObserver = MockNavigatorObserver();
      mockAreaService = MockAreaService();
    });

    _loadWidget(WidgetTester tester) async {
      Area area = Area('603b5d65eb9eb83e4b86469d', AreaAction("timer", "every_hour", {"minute": 42}),
          AreaReaction("discord", "post_message", {"id": "ezefea", "body": "test"}));

      await tester.pumpWidget(MaterialApp(
        home: UpdateAreaFormPage(area, mockAreaService),
        navigatorObservers: [mockObserver],
      ));
      await tester.pumpAndSettle();
    }

    _writeTextInWidgetByKey(WidgetTester tester, Key key, String value) async {
      final input = find.byKey(key);
      expect(input, findsOneWidget);

      await tester.enterText(input, value);
      await tester.pumpAndSettle();
    }

    _updateArea(WidgetTester tester) async {
      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();

      await _writeTextInWidgetByKey(tester, Key("input_every_hour_minute"), "43");
      await tester.pump();

      expect(find.text("43"), findsOneWidget);

      // Scrolling up
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0.0, -800));
      await tester.pumpAndSettle();

      final submitButton = find.byWidgetPredicate((widget) => widget is RoundedLoadingButton && widget.onPressed != null);
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.updateArea(any)).called(1);
      expect(find.byType(UpdateAreaFormPage), findsNothing);
    }

    _updateAreaBadTokenError(WidgetTester tester) async {
      when(mockAreaService.updateArea(any)).thenThrow(BadTokenException());
      await _loadWidget(tester);

      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();

      // Scrolling up
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0.0, -800));
      await tester.pumpAndSettle();

      final submitButton = find.byWidgetPredicate((widget) => widget is RoundedLoadingButton && widget.onPressed != null);
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.updateArea(any)).called(1);
      expect(find.byType(UpdateAreaFormPage), findsOneWidget);
    }

    _updateAreaBadResponseError(WidgetTester tester) async {
      when(mockAreaService.updateArea(any)).thenThrow(BadResponseException());
      await _loadWidget(tester);

      await tester.tap(find.text("OK"));
      await tester.pumpAndSettle();

      // Scrolling up
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0.0, -800));
      await tester.pumpAndSettle();

      final submitButton = find.byWidgetPredicate((widget) => widget is RoundedLoadingButton && widget.onPressed != null);
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      verify(mockAreaService.updateArea(any)).called(1);
      expect(find.byType(UpdateAreaFormPage), findsOneWidget);
    }

    testWidgets("Update area", (WidgetTester tester) async {
      await _loadWidget(tester);

      await _updateArea(tester);
    });

    testWidgets("Bad token error", (WidgetTester tester) async {
      await _updateAreaBadTokenError(tester);
    });

    testWidgets("Bad response error", (WidgetTester tester) async {
      await _updateAreaBadResponseError(tester);
    });
  });
}
