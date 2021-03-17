import 'dart:async';

import 'package:flutter/cupertino.dart';

import 'area_service_widget_base.dart';
import 'input.dart';
import 'option.dart';

class TimerServiceWidget extends AreaServiceWidgetBase {
  static const List<Option> ACTIONS = [
    Option("every_hour", [Input('minute', '42', r'^[0-5]?[0-9]$', true)]),
    Option("every_day", [Input('hour', '10', r'^([0-1]?[0-9]|2[0-3])$', true)])
  ];
  static const List<Option> REACTIONS = [];

  final StreamController<Map<String, dynamic>> streamParamsController;
  final bool isAction;
  final Map<String, dynamic> params;

  TimerServiceWidget({Key key, @required this.streamParamsController, @required this.isAction, this.params = const {}}) : super(key: key);

  static create(StreamController<Map<String, dynamic>> streamParamsController, bool isAction, [params = const {}]) {
    return TimerServiceWidget(streamParamsController: streamParamsController, isAction: isAction, params: params);
  }

  @override
  AreaServiceWidgetBaseState createState() => AreaServiceWidgetBaseState(streamParamsController, isAction, ACTIONS, REACTIONS, params);

  @override
  Option getActionOption(String actionValue) {
    for (Option value in ACTIONS) {
      if (value.name == actionValue) {
        return value;
      }
    }
    return null;
  }
}
