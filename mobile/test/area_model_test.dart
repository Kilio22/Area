import 'dart:convert';

import 'package:area/models/area.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Area model", () {
    test('Area from json', () {
      String jsonObject =
          '{"id":"603b5d65eb9eb83e4b86469d","action":{"_id":"603b5d65eb9eb83e4b86469e","service":"timer","name":"every_hour","data":{"minute":42}},"reaction":{"_id":"603b5d65eb9eb83e4b86469f","data":{"id":"ezefea","body":"test"},"service":"discord","name":"post_message"}}';
      Area area = Area.fromJson(jsonDecode(jsonObject));

      expect(area.id, '603b5d65eb9eb83e4b86469d');
      expect(area.action.service, 'timer');
      expect(area.action.name, 'every_hour');
      expect(area.action.data, {"minute": 42});
      expect(area.reaction.service, 'discord');
      expect(area.reaction.name, 'post_message');
      expect(area.reaction.data, {"id": "ezefea", "body": "test"});
    });

    test('Area to json', () {
      String jsonObject =
          '{"id":"603b5d65eb9eb83e4b86469d","action":{"_id":"603b5d65eb9eb83e4b86469e","service":"timer","name":"every_hour","data":{"minute":42}},"reaction":{"_id":"603b5d65eb9eb83e4b86469f","data":{"id":"ezefea","body":"test"},"service":"discord","name":"post_message"}}';
      Area area = Area.fromJson(jsonDecode(jsonObject));
      expect(
          area.toJson(),
          jsonDecode(
              '{"action":{"service":"timer","name":"every_hour","data":{"minute":42}},"reaction":{"data":{"id":"ezefea","body":"test"},"service":"discord","name":"post_message"}}'));
    });
  });
}
