import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'area_service_widget_base.dart';
import 'input.dart';
import 'option.dart';

class GoogleServiceWidget extends AreaServiceWidgetBase {
  static const List<Option> ACTIONS = [
    Option("new_video", [Input("id", "Channel id", null, false)]),
    Option("playlist_update", [Input("id", "Playlist id", null, false)])
  ];
  static const List<Option> REACTIONS = [];

  final StreamController<Map<String, dynamic>> streamParamsController;
  final bool isAction;
  final Map<String, dynamic> params;

  GoogleServiceWidget({Key key, @required this.streamParamsController, @required this.isAction, this.params = const {}}) : super(key: key);

  static create(StreamController<Map<String, dynamic>> streamParamsController, bool isAction, [params = const {}]) {
    return GoogleServiceWidget(streamParamsController: streamParamsController, isAction: isAction, params: params);
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
