import 'dart:async';

import 'package:area/services/app_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import 'area_service_widget_base.dart';
import 'input.dart';
import 'option.dart';

class DiscordServiceWidget extends AreaServiceWidgetBase {
  static const List<Option> ACTIONS = [];
  static const List<Option> REACTIONS = [
    Option("post_message", [Input("id", "Channel id", null, false), Input("body", "Body of the message", null, false)])
  ];

  final StreamController<Map<String, dynamic>> streamParamsController;
  final bool isAction;
  final Map<String, dynamic> params;

  DiscordServiceWidget({Key key, @required this.streamParamsController, @required this.isAction, this.params = const {}}) : super(key: key);

  static create(StreamController<Map<String, dynamic>> streamParamsController, bool isAction, [params = const {}]) {
    return DiscordServiceWidget(streamParamsController: streamParamsController, isAction: isAction, params: params);
  }

  @override
  AreaServiceWidgetBaseState createState() => _DiscordServiceWidgetState(streamParamsController, isAction, ACTIONS, REACTIONS, params);

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

class _DiscordServiceWidgetState extends AreaServiceWidgetBaseState<DiscordServiceWidget> {
  _DiscordServiceWidgetState(StreamController<Map<String, dynamic>> streamParams, bool isAction, List<Option> actions,
      List<Option> reactions, Map<String, dynamic> params)
      : super(streamParams, isAction, actions, reactions, params);

  @override
  void initState() {
    super.initState();
    Timer.run(() => this.showDiscordAlert());
  }

  showDiscordAlert() {
    return showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Discord bot'),
              content: SingleChildScrollView(
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
                Text('Type on the button bellow to copy the link that enables you to invite our bot.', textAlign: TextAlign.center),
                SizedBox(height: 10),
                MaterialButton(
                    onPressed: () {
                      Clipboard.setData(new ClipboardData(text: DISCORD_BOT_LINK));
                      AppService.showToast("Copied to clipboard", Colors.grey);
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.black)),
                    color: Color(0xFFd5d8dc),
                    child: Text("COPY"))
              ])),
              actions: <Widget>[TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('OK'))]);
        });
  }
}
