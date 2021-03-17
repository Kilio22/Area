import 'package:area/dashboard.dart';
import 'package:area/profile.dart';
import 'package:area/services/app_service.dart';
import 'package:area/users.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'about.dart';

class MyMainPage extends StatefulWidget {
  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MyMainPage> {
  static const List<String> _childrenTitle = ["Dashboard", "Users", "Profile"];

  final List<Widget> _children = [DashboardPage(), Users(), MyProfilePage()];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            centerTitle: true,
            actions: _selectedIndex == 2
                ? <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 15.0), child: IconButton(onPressed: () => this.signOut(), icon: Icon(Icons.logout)))
                  ]
                : <Widget>[
                    Padding(
                        padding: EdgeInsets.only(right: 15.0),
                        child: IconButton(onPressed: () => this.goToAboutPage(), icon: Icon(Icons.info_outline)))
                  ],
            title: Text(_childrenTitle[this._selectedIndex])),
        body: this._children[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile')
        ], currentIndex: _selectedIndex, selectedItemColor: Colors.blueAccent, onTap: onItemTapped));
  }

  onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  signOut() {
    showDialog(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Sign out'),
              content: SingleChildScrollView(child: ListBody(children: <Widget>[Text('Do you really want to sign out?')])),
              actions: <Widget>[
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel')),
                TextButton(onPressed: () => AppService.signOut(context), child: Text('Yes'))
              ]);
        });
  }

  goToAboutPage() async {
    return Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
  }
}
