import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'area_service_widget_base.dart';
import 'input.dart';
import 'option.dart';

class TwitterServiceWidget extends AreaServiceWidgetBase {
  static const List<Option> ACTIONS = [];
  static const List<Option> REACTIONS = [
    Option("post_tweet", [Input("body", "Tweet body", null, false)]),
    Option("update_bio", [Input("body", "Your new biography", null, false)])
  ];

  final StreamController<Map<String, dynamic>> streamParamsController;
  final bool isAction;
  final Map<String, dynamic> params;

  TwitterServiceWidget({Key key, @required this.streamParamsController, @required this.isAction, this.params = const {}}) : super(key: key);

  static create(StreamController<Map<String, dynamic>> streamParamsController, bool isAction, [params = const {}]) {
    return TwitterServiceWidget(streamParamsController: streamParamsController, isAction: isAction, params: params);
  }

  @override
  AreaServiceWidgetBaseState createState() => AreaServiceWidgetBaseState(streamParamsController, isAction, ACTIONS, REACTIONS, params);

  @override
  Option getReactionOption(String reactionValue) {
    for (Option value in REACTIONS) {
      if (value.name == reactionValue) {
        return value;
      }
    }
    return null;
  }
}
