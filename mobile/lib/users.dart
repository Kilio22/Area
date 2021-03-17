import 'dart:developer';

import 'package:area/services/app_service.dart';
import 'package:area/services/area_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'exceptions/bad_token_exception.dart';
import 'models/user.dart';

class Users extends StatefulWidget {
  final AreaService _areaServiceInstance;

  Users([AreaService areaService]) : this._areaServiceInstance = areaService ?? AreaService();

  @override
  _UsersState createState() => _UsersState(this._areaServiceInstance);
}

class _UsersState extends State<Users> {
  final AreaService _areaServiceInstance;

  bool _isLoading = false;
  List<User> _users;

  _UsersState(AreaService areaService) : this._areaServiceInstance = areaService;

  @override
  void initState() {
    super.initState();
    this.updateUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: this._isLoading
                    ? [CircularProgressIndicator()]
                    : (this._users == null || this._users.length == 0)
                        ? [Text("Nothing to display", style: TextStyle(fontSize: 20.0))]
                        : [
                            Expanded(
                                child: ListView.builder(
                                    itemCount: _users.length,
                                    itemBuilder: (context, index) {
                                      final User item = _users[index];

                                      return Padding(
                                          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0),
                                          child: Card(
                                              key: Key("card_" + item.id),
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(color: Colors.black, width: 1.5),
                                                  borderRadius: BorderRadius.circular(4.0)),
                                              child: ListTile(
                                                  title: Row(children: [
                                                    Text(item.email,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(color: Colors.black, fontSize: 20.0))
                                                  ]),
                                                  subtitle: Row(children: [Text(item.displayName, overflow: TextOverflow.ellipsis)]),
                                                  trailing: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                                                    IconButton(
                                                        icon: Icon(Icons.delete_outline, color: Colors.red),
                                                        onPressed: () async {
                                                          this.setState(() {
                                                            this._isLoading = true;
                                                          });
                                                          await this.deleteUser(item);
                                                          await this.getUsers();
                                                          this.setState(() {
                                                            this._isLoading = false;
                                                          });
                                                        })
                                                  ]))));
                                    }))
                          ])));
  }

  updateUsers() async {
    this.setState(() {
      this._isLoading = true;
    });
    await this.getUsers();
    this.setState(() {
      this._isLoading = false;
    });
  }

  Future<void> getUsers() async {
    try {
      List<User> users = await this._areaServiceInstance.getUsers();

      return this.setState(() {
        this._users = users;
      });
    } on BadTokenException {
      AppService.showToast("Invalid token, signing you out.");
      AppService.signOut(context);
    } on Exception {
      AppService.showToast("Cannot get users.");
    } catch (e) {
      log(e.toString());
      AppService.showToast("Cannot get users.");
    }
    this.setState(() {
      this._users = null;
    });
  }

  Future<void> deleteUser(User user) async {
    try {
      await this._areaServiceInstance.deleteUser(user);
    } on BadTokenException {
      AppService.showToast("Invalid token, signing you out.");
      AppService.signOut(context);
    } on Exception {
      AppService.showToast("Cannot get users.");
    } catch (e) {
      log(e.toString());
      AppService.showToast("Cannot get users.");
    }
  }
}
