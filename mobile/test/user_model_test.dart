import 'dart:convert';

import 'package:area/models/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("User model", () {
    test('User from json', () {
      String jsonObject =
          '{"displayName":"Kylian Balan","email":"kylian.balan@epitech.eu","services":["twitter"],"isMicrosoftAuthed":true}';
      User user = User.fromJson(jsonDecode(jsonObject));

      expect(user.email, "kylian.balan@epitech.eu");
      expect(user.displayName, "Kylian Balan");
      expect(user.servicesConnectInformation, ["twitter"]);
    });
  });
}
