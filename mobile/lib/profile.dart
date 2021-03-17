import 'dart:developer';

import 'package:area/exceptions/bad_token_exception.dart';
import 'package:area/models/service.dart';
import 'package:area/models/user.dart';
import 'package:area/services/app_service.dart';
import 'package:area/services/area_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';

import 'constants.dart';

class MyProfilePage extends StatefulWidget {
  final AreaService _areaServiceInstance;

  MyProfilePage([AreaService areaService]) : _areaServiceInstance = areaService ?? AreaService();

  @override
  _MyProfilePageState createState() => _MyProfilePageState(_areaServiceInstance);
}

class _MyProfilePageState extends State<MyProfilePage> {
  final AreaService _areaServiceInstance;

  User _user;
  bool _isLoading = false;

  _MyProfilePageState(AreaService areaService) : this._areaServiceInstance = areaService;

  @override
  void initState() {
    this.getUserProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: SingleChildScrollView(
                child: Column(
                    children: this._user == null
                        ? <Widget>[CircularProgressIndicator()]
                        : <Widget>[
                            Icon(Icons.person, size: 100.0),
                            Padding(
                                padding: EdgeInsets.only(bottom: 50.0),
                                child: Column(children: [
                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                    Spacer(),
                                    Text(_user.displayName,
                                        style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
                                    Expanded(
                                        child: this._user.isMicrosoftAuth
                                            ? Container()
                                            : Container(
                                                alignment: Alignment.centerLeft,
                                                child: IconButton(
                                                    key: Key("edit_username"),
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () => this.editUsername(),
                                                    iconSize: 20.0)))
                                  ]),
                                  this._user.isMicrosoftAuth ? SizedBox(height: 10.0) : Container(),
                                  Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                                    Spacer(),
                                    Text(_user.email, style: TextStyle(color: Colors.black, fontSize: 15)),
                                    Expanded(
                                        child: this._user.isMicrosoftAuth
                                            ? Container()
                                            : Container(
                                                alignment: Alignment.centerLeft,
                                                child: IconButton(
                                                    key: Key("edit_email"),
                                                    icon: Icon(Icons.edit),
                                                    onPressed: () => this.editEmail(),
                                                    iconSize: 20.0)))
                                  ]),
                                  this._user.isMicrosoftAuth
                                      ? Padding(
                                          padding: EdgeInsets.only(top: 10.0),
                                          child: Text("You're signed in with Microsoft.",
                                              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.green)))
                                      : MaterialButton(
                                          onPressed: () => this.editPassword(), color: Color(0xFFd5d8dc), child: Text("Change password"))
                                ])),
                            Padding(
                                padding: EdgeInsets.only(left: 20.0, right: 20.0),
                                child: Column(
                                    children: SERVICES_MAP.entries.map((e) {
                                  if (e.value.uri != null) {
                                    return Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: getSignInWith(
                                            e.value, this._user.servicesConnectInformation.contains(e.value.name.toLowerCase())));
                                  }
                                  return Container();
                                }).toList()))
                          ]))));
  }

  editUsername() {
    TextEditingController usernameController = TextEditingController(text: this._user.displayName);

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Edit username'),
              content: SingleChildScrollView(
                  child: ListBody(children: <Widget>[
                Text('Edit your username below.'),
                TextField(
                    key: Key("edit_username_input"),
                    obscureText: false,
                    controller: usernameController,
                    decoration: InputDecoration(contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0), hintText: "kilio22"))
              ])),
              actions: <Widget>[
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                TextButton(
                    onPressed: () async {
                      if (usernameController.text == "") {
                        AppService.showToast("Please fill the username field.");
                        return;
                      }
                      if (usernameController.text.length < 3) {
                        AppService.showToast("Username must be formed of at least 3 characters");
                        return;
                      }
                      FocusScope.of(context).unfocus();

                      try {
                        User newUser = User("", usernameController.text, this._user.email, this._user.servicesConnectInformation,
                            this._user.isMicrosoftAuth);

                        await this._areaServiceInstance.updateUsernameEmail(newUser);
                        this.setState(() {
                          this._user = newUser;
                        });
                        AppService.showToast("Username updated successfully!", Colors.green);
                        return Navigator.of(context).pop();
                      } on BadTokenException {
                        AppService.showToast("Invalid token, signing you out.");
                        AppService.signOut(context);
                      } on Exception {
                        AppService.showToast("Couldn't update your username.");
                      } catch (e) {
                        log(e.toString());
                        AppService.showToast("Couldn't update your username.");
                      }
                    },
                    child: Text('OK'))
              ]);
        });
  }

  editEmail() {
    TextEditingController emailController = TextEditingController(text: this._user.email);

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Edit email'),
              content: SingleChildScrollView(
                  child: ListBody(children: <Widget>[
                Text('Edit your email below.'),
                TextField(
                    key: Key("edit_email_input"),
                    obscureText: false,
                    controller: emailController,
                    decoration: InputDecoration(contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0), hintText: "area@chad.com"))
              ])),
              actions: <Widget>[
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                TextButton(
                    onPressed: () async {
                      if (emailController.text == "") {
                        AppService.showToast("Please fill the email field.");
                        return;
                      }
                      if (RegExp(EMAIL_REGEX).hasMatch(emailController.text) == false) {
                        AppService.showToast("Invalid email.");
                        return;
                      }
                      FocusScope.of(context).unfocus();

                      try {
                        User newUser = User("", this._user.displayName, emailController.text, this._user.servicesConnectInformation,
                            this._user.isMicrosoftAuth);

                        await this._areaServiceInstance.updateUsernameEmail(newUser);
                        this.setState(() {
                          this._user = newUser;
                        });
                        AppService.showToast("Email updated successfully!", Colors.green);
                        return Navigator.of(context).pop();
                      } on BadTokenException {
                        AppService.showToast("Invalid token, signing you out.");
                        AppService.signOut(context);
                      } on Exception {
                        AppService.showToast("Couldn't update your email.");
                      } catch (e) {
                        log(e.toString());
                        AppService.showToast("Couldn't update your email.");
                      }
                    },
                    child: Text('OK'))
              ]);
        });
  }

  editPassword() {
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Change password'),
              content: SingleChildScrollView(
                  child: ListBody(children: <Widget>[
                Text('Enter your new password below.'),
                TextField(
                    key: Key("edit_password_input"),
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0))),
                SizedBox(height: 20.0),
                Text('Confirm your new password below.'),
                TextField(
                    key: Key("edit_password_confirm_input"),
                    obscureText: true,
                    controller: confirmPasswordController,
                    decoration: InputDecoration(contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0)))
              ])),
              actions: <Widget>[
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                TextButton(
                    onPressed: () async {
                      if (passwordController.text == "" || confirmPasswordController.text == "") {
                        AppService.showToast("Please fill all fields.");
                        return;
                      }
                      if (passwordController.text.length < 6) {
                        AppService.showToast("Password must be formed of at least 6 characters");
                        return;
                      }
                      if (passwordController.text != confirmPasswordController.text) {
                        AppService.showToast("Both passwords are not the same.");
                        return;
                      }
                      FocusScope.of(context).unfocus();

                      try {
                        await this._areaServiceInstance.updatePassword(passwordController.text);
                        AppService.showToast("Password updated successfully!", Colors.green);
                        return Navigator.of(context).pop();
                      } on BadTokenException {
                        AppService.showToast("Invalid token, signing you out.");
                        AppService.signOut(context);
                      } on Exception {
                        AppService.showToast("Couldn't update your password.");
                      } catch (e) {
                        log(e.toString());
                        AppService.showToast("Couldn't update your password.");
                      }
                    },
                    child: Text('OK'))
              ]);
        });
  }

  signInWithService(Service service) async {
    setState(() {
      this._isLoading = true;
    });
    try {
      final String url = await this._areaServiceInstance.getServiceRedirectionUrl(service);
      final String callbackUrl = await FlutterWebAuth.authenticate(url: url.toString(), callbackUrlScheme: service.callbackUrlScheme);

      await this._areaServiceInstance.handleServiceRedirection(callbackUrl, service);
      await this.getUserProfile();
    } on BadTokenException {
      AppService.showToast("Invalid token, signing you out.");
      AppService.signOut(context);
    } catch (e) {
      log(e.toString());
      AppService.showToast("Couldn't sign you in with this service.");
    }
    setState(() {
      this._isLoading = false;
    });
  }

  getSignInWith(Service service, bool isAuthenticated) {
    if (isAuthenticated) {
      return MaterialButton(
          onPressed: null,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.blue)),
          height: 50.0,
          color: Colors.white,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(service.iconPath),
            Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text('You\'re connected with ' + service.name, style: TextStyle(color: Colors.black)))
          ]));
    }
    return MaterialButton(
        onPressed: () async {
          if (this._isLoading) {
            return;
          }
          await this.signInWithService(service);
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.transparent)),
        height: 50.0,
        color: Color(0xFFd5d8dc),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: this._isLoading
                ? [CircularProgressIndicator()]
                : [
                    Image.asset(service.iconPath),
                    Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text('Connect with ' + service.name, style: TextStyle(color: Colors.black)))
                  ]));
  }

  Future<void> getUserProfile() async {
    try {
      final User user = await this._areaServiceInstance.getUserProfile();

      this.setState(() {
        this._user = user;
      });
    } on BadTokenException {
      AppService.showToast("Invalid token, signing you out.");
      AppService.signOut(context);
    } on Exception {
      AppService.showToast("Cannot get user profile information.");
    } catch (e) {
      log(e.toString());
      AppService.showToast("Cannot get user profile information.");
    }
  }
}
