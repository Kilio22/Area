import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'area_service_widget_base.dart';
import 'input.dart';
import 'option.dart';

class GithubServiceWidget extends AreaServiceWidgetBase {
  static const List<Option> ACTIONS = [
    Option("new_issue", [Input("owner", "EliottPal", null, false), Input("repo", "Dashboard_2020", null, false)]),
    Option("new_repository", [Input("owner", "EliottPal", null, false)]),
    Option("new_pull_request", [Input("owner", "EliottPal", null, false), Input("repo", "Dashboard_2020", null, false)]),
    Option("issue_closes", [Input("owner", "EliottPal", null, false), Input("repo", "Dashboard_2020", null, false)]),
    Option("new_ref", [Input("owner", "EliottPal", null, false), Input("repo", "Dashboard_2020", null, false)]),
    Option("new_tag", [Input("owner", "EliottPal", null, false), Input("repo", "Dashboard_2020", null, false)])
  ];
  static const List<Option> REACTIONS = [
    Option("open_issue", [
      Input("owner", "EliottPal", null, false),
      Input("repo", "Dashboard_2020", null, false),
      Input("title", "Title", null, false),
      Input("body", "Description", null, false)
    ])
  ];

  final StreamController<Map<String, dynamic>> streamParamsController;
  final bool isAction;
  final Map<String, dynamic> params;

  GithubServiceWidget({Key key, @required this.streamParamsController, @required this.isAction, this.params = const {}}) : super(key: key);

  static create(StreamController<Map<String, dynamic>> streamParamsController, bool isAction, [params = const {}]) {
    return GithubServiceWidget(streamParamsController: streamParamsController, isAction: isAction, params: params);
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
