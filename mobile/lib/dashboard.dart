import 'dart:developer';

import 'package:area/area_form.dart';
import 'package:area/models/area.dart';
import 'package:area/models/service.dart';
import 'package:area/services/app_service.dart';
import 'package:area/services/area_service.dart';
import 'package:area/update_area_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'constants.dart';
import 'exceptions/bad_token_exception.dart';

class DashboardPage extends StatefulWidget {
  final AreaService _areaServiceInstance;

  DashboardPage([AreaService areaService]) : this._areaServiceInstance = areaService ?? AreaService();

  @override
  _DashboardPageState createState() => _DashboardPageState(this._areaServiceInstance);
}

class _DashboardPageState extends State<DashboardPage> {
  final AreaService _areaServiceInstance;

  bool _isLoading = true;
  List<Area> _areaList;

  _DashboardPageState(AreaService areaService) : this._areaServiceInstance = areaService;

  @override
  void initState() {
    super.initState();
    this.updateAreaList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(onPressed: this.navigateToForm, child: Icon(Icons.add), backgroundColor: Colors.blue),
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: this._isLoading
                    ? [CircularProgressIndicator()]
                    : (this._areaList == null || this._areaList.length == 0)
                        ? [Text("Nothing to display", style: TextStyle(fontSize: 20.0))]
                        : [
                            Expanded(
                                child: ListView.builder(
                                    itemCount: _areaList.length,
                                    itemBuilder: (context, index) {
                                      final Area item = _areaList[index];
                                      Service actionService;
                                      Service reactionService;

                                      SERVICES_MAP.forEach((key, value) {
                                        if (item.action.service.toLowerCase() == value.name.toLowerCase()) {
                                          actionService = value;
                                        }
                                        if (item.reaction.service.toLowerCase() == value.name.toLowerCase()) {
                                          reactionService = value;
                                        }
                                      });
                                      return Padding(
                                          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
                                          child: Card(
                                              key: Key(
                                                  'card_' + actionService.name.toLowerCase() + '_' + reactionService.name.toLowerCase()),
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(color: Colors.black, width: 1.5),
                                                  borderRadius: BorderRadius.circular(4.0)),
                                              child: ListTile(
                                                  title: Row(children: [
                                                    Flexible(
                                                      child: new Container(
                                                          child: Text(actionService.name,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(color: Colors.black, fontSize: 20.0))),
                                                    ),
                                                    Icon(Icons.arrow_forward, color: Colors.black),
                                                    Flexible(
                                                      child: new Container(
                                                          child: Text(reactionService.name,
                                                              overflow: TextOverflow.ellipsis,
                                                              style: TextStyle(color: Colors.black, fontSize: 20.0))),
                                                    )
                                                  ]),
                                                  subtitle: Row(children: [
                                                    Flexible(
                                                      child: new Container(child: Text(item.action.name, overflow: TextOverflow.ellipsis)),
                                                    ),
                                                    Icon(Icons.arrow_forward, color: Colors.grey),
                                                    Flexible(
                                                        child:
                                                            new Container(child: Text(item.reaction.name, overflow: TextOverflow.ellipsis)))
                                                  ]),
                                                  trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                                    IconButton(
                                                        icon: Icon(Icons.edit, color: Colors.black),
                                                        onPressed: () {
                                                          Navigator.push(context,
                                                                  MaterialPageRoute(builder: (context) => UpdateAreaFormPage(item)))
                                                              .then((value) => this.updateAreaList());
                                                        }),
                                                    IconButton(
                                                        icon: Icon(Icons.delete_outline, color: Colors.red),
                                                        onPressed: () async {
                                                          this.setState(() {
                                                            this._isLoading = true;
                                                          });
                                                          await this.deleteArea(item);
                                                          await this.getAreaList();
                                                          this.setState(() {
                                                            this._isLoading = false;
                                                          });
                                                        })
                                                  ]))));
                                    }))
                          ])));
  }

  navigateToForm() {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => AreaFormPage())).then((_) => this.updateAreaList());
  }

  updateAreaList() async {
    this.setState(() {
      this._isLoading = true;
    });
    await this.getAreaList();
    this.setState(() {
      this._isLoading = false;
    });
  }

  deleteArea(Area area) async {
    try {
      await this._areaServiceInstance.deleteArea(area);
      return AppService.showToast("Area deleted successfully!", Colors.green);
    } on BadTokenException {
      AppService.showToast("Invalid token, signing you out.");
      AppService.signOut(context);
    } on Exception {
      AppService.showToast("Couldn't delete area.");
    } catch (e) {
      log(e.toString());
      AppService.showToast("Couldn't delete area.");
    }
  }

  List<Area> checkAreaList(List<Area> areaList) {
    List<Area> finalAreaList = areaList;

    areaList.asMap().forEach((idx, element) {
      if (!SERVICES_MAP.containsKey(element.action.service.toLowerCase()) ||
          !SERVICES_MAP.containsKey(element.reaction.service.toLowerCase())) {
        finalAreaList.removeAt(idx);
      }
    });
    return finalAreaList;
  }

  Future<void> getAreaList() async {
    try {
      List<Area> areaList = await _areaServiceInstance.getAreaList();
      areaList = this.checkAreaList(areaList);

      return this.setState(() {
        this._areaList = areaList;
      });
    } on BadTokenException {
      AppService.showToast("Invalid token, signing you out.");
      AppService.signOut(context);
    } on Exception {
      AppService.showToast("Cannot get area list.");
    } catch (e) {
      log(e.toString());
      AppService.showToast("Cannot get area list.");
    }
    this.setState(() {
      this._areaList = null;
    });
  }
}
