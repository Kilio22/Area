import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants.dart';
import 'input.dart';
import 'option.dart';

abstract class AreaServiceWidgetBase extends StatefulWidget {
  AreaServiceWidgetBase({Key key}) : super(key: key);

  Option getActionOption(String actionValue) {
    return null;
  }

  Option getReactionOption(String reactionValue) {
    return null;
  }
}

class AreaServiceWidgetBaseState<Page extends AreaServiceWidgetBase> extends State<Page> {
  final List<Option> actions;
  final List<Option> reactions;
  final StreamController<Map<String, dynamic>> streamParams;
  final bool isAction;
  final Map<String, TextEditingController> textControllers = Map();

  Option _selectedOption;
  Map<String, dynamic> _params = Map();

  AreaServiceWidgetBaseState(this.streamParams, this.isAction, this.actions, this.reactions, Map<String, dynamic> params) {
    if (params == null || params.length == 0) {
      return;
    }
    if (this.isAction) {
      this._params[ACTION_KEY] = params[ACTION_KEY];
      this.actions.forEach((element) {
        if (this._params[ACTION_KEY] == element.name) {
          this._selectedOption = element;
        }
      });
    } else {
      this._params[REACTION_KEY] = params[REACTION_KEY];
      this.reactions.forEach((element) {
        if (this._params[REACTION_KEY] == element.name) {
          this._selectedOption = element;
        }
      });
    }
    if (this._selectedOption == null) {
      return;
    }
    params.forEach((key, value) {
      if (this._selectedOption.inputs.any((element) => key == element.name)) {
        this._params[key] = value;
      }
    });
    this.streamParams.add(this._params);
    this._selectedOption.inputs.forEach((element) {
      this.textControllers[element.name] = TextEditingController();
      this.textControllers[element.name].text = this._params[element.name].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: body(),
    );
  }

  Widget body() {
    return Column(children: [
      if (this.isAction) this.showOptions(this.actions) else this.showOptions(this.reactions),
      if (this._selectedOption != null) this.showInputs()
    ]);
  }

  Widget showInputs() {
    return Column(
        children: this._selectedOption.inputs.map<Widget>((input) {
      return Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Container(
              width: double.infinity,
              child: TextField(
                  key: Key("input_" + this._selectedOption.name + "_" + input.name),
                  controller: this.textControllers[input.name],
                  obscureText: false,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      errorText: this.getErrorText(input, this._params[input.name].toString()),
                      contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: input.hintText,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                  keyboardType: input.isTimePicker ? TextInputType.number : TextInputType.text,
                  inputFormatters: input.isTimePicker ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly] : [],
                  onChanged: (value) {
                    if (value.isEmpty) {
                      this.setState(() {
                        this._params.remove(input.name);
                      });
                      this.streamParams.add(this._params);
                      return;
                    } else {
                      this.setState(() {
                        this._params[input.name] = input.isTimePicker ? int.parse(value) : value;
                      });
                    }
                    if (this.getErrorText(input, value) == null) {
                      this.streamParams.add(this._params);
                    } else {
                      this.setState(() {
                        this._params.remove(input.name);
                      });
                      this.streamParams.add(this._params);
                    }
                  })));
    }).toList());
  }

  String getErrorText(Input input, String value) {
    if (value == null || input.regex == null) {
      return null;
    }
    if (RegExp(input.regex).hasMatch(value) == false) {
      return "Invalid field.";
    }
    return null;
  }

  Widget showOptions(List<Option> options) {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32.0), color: Colors.white, border: Border.all(width: 2.0, color: Colors.grey)),
            padding: const EdgeInsets.only(left: 20.0, right: 10.0),
            width: 200.0,
            child: DropdownButtonHideUnderline(
                child: DropdownButton<Option>(
                    key: this.isAction ? Key("action_options_dropdown") : Key("reaction_options_dropdown"),
                    isExpanded: true,
                    value: this._selectedOption,
                    items: options.map((e) => DropdownMenuItem(child: Text(e.name), value: e)).toList(),
                    onChanged: (value) {
                      if (this.isAction) {
                        this._params[ACTION_KEY] = value.name;
                      } else {
                        this._params[REACTION_KEY] = value.name;
                      }
                      this.setState(() {
                        this._selectedOption = value;
                        this.textControllers.clear();
                        this._selectedOption.inputs.forEach((element) {
                          this.textControllers[element.name] = TextEditingController();
                        });
                      });
                      this.streamParams.add(this._params);
                    }))));
  }
}
