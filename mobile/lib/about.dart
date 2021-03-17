import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState<Page extends AboutPage> extends State<Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: this.getFormTitle(),
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          DescriptionCard(),
          Padding(padding: EdgeInsets.only(top: 32.0)),
          Text(' Our Team',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center),
          NathanCard(),
          GhassaneCard(),
          KylianCard(),
          RodoCard(),
          EliottCard(),
          BearCard(),
          Text('© 2021 Chad Corporation',
              style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center),
          Padding(padding: EdgeInsets.only(top: 8.0)),
        ])));
  }

  Widget getFormTitle() {
    return Text('About ChadArea');
  }
}

class DescriptionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(24.0),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text(' Project Overview',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.only(bottom: 15.0)),
            Text('Epitech 3rd year final project.',
                style: TextStyle(fontSize: 18.0), textAlign: TextAlign.center),
            Text('(20/01/21 - 07/03/21).',
                style: TextStyle(fontSize: 18.0), textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text(
                'This project consists in the creation of a software suite that functions similarly to IFTTT / Zapier.',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text(
                'You are using the mobile version of ChadArea, which was developed in Flutter and uses our server created using NodeJs & MongoDb.',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.only(top: 5.0)),
            Text(
                'For more detailed information about the project, please refer to the documentation provided in the official Github page of the project.',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.only(top: 10.0)),
          ],
        ),
      ),
    );
  }
}

class NathanCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(24.0),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/team/watermelon.png',
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text('Nathan LECORCHET',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            Text('Back Developper',
                style: TextStyle(fontSize: 18.0), textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.only(top: 14.0)),
          ],
        ),
      ),
    );
  }
}

class GhassaneCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(24.0),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/team/bubz.png',
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text('Ghassane SEBAÏ',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            Text('Web developper & Designer',
                style: TextStyle(fontSize: 18.0), textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.only(top: 14.0)),
          ],
        ),
      ),
    );
  }
}

class KylianCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(24.0),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/team/sock.png',
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text('Kylian BALAN',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            Text('Mobile Developper',
                style: TextStyle(fontSize: 18.0), textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.only(top: 14.0)),
          ],
        ),
      ),
    );
  }
}

class RodoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(24.0),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/team/muscle.png',
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text('Rodolphe DUPUIS',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            Text('Back Developper',
                style: TextStyle(fontSize: 18.0), textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.only(top: 14.0)),
          ],
        ),
      ),
    );
  }
}

class EliottCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(24.0),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/team/ouaf.png',
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text('Eliott PALUEAU',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            Text('Web developper & Doc redactor',
                style: TextStyle(fontSize: 18.0), textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.only(top: 14.0)),
          ],
        ),
      ),
    );
  }
}

class BearCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(24.0),
        elevation: 5,
        child: Column(
          children: <Widget>[
            Image.asset(
              'assets/images/team/bear.png',
            ),
            Padding(padding: EdgeInsets.only(top: 10.0)),
            Text('CHAD BEAR',
                style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            Text('Mascott',
                style: TextStyle(fontSize: 18.0), textAlign: TextAlign.center),
            Padding(padding: EdgeInsets.only(top: 14.0)),
          ],
        ),
      ),
    );
  }
}
