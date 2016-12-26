import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_with_realm/person.dart';
import 'package:flutter_with_realm/realm_helper.dart';
import 'package:flutter_with_realm/user_list.dart';

void main() {
  runApp(new Main());
}

class Main extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    UserList.routeName: (BuildContext context) => new UserList()
  };

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Flutter with Realm',
        theme: new ThemeData(
            primarySwatch: Colors.blue, platform: Theme.of(context).platform),
        home: new MainPage(title: 'Flutter with Realm'));
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  MainPageState createState() => new MainPageState();
}

class MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final double _margin = 16.0;
  final RealmHelper _realmHelper = new RealmHelper();

  InputValue _firstName = new InputValue();
  InputValue _lastName = new InputValue();
  InputValue _age = new InputValue();
  InputValue _country = new InputValue();

  void _initInputValues() {
    setState(() {
      _firstName = new InputValue();
      _lastName = new InputValue();
      _age = new InputValue();
      _country = new InputValue();
    });
  }

  Future _save(Person person) async {
    if (!person.validate()) {
      _scaffoldKey.currentState?.showSnackBar(
          new SnackBar(content: new Text('Required argument is missing.')));
      return;
    }
    await _realmHelper.save(person.toMap());
    _initInputValues();
  }

  Future _loadAll() async {
    ;
    var reply = await _realmHelper.load();
    var persons = reply[RealmHelper.resultKey].map((j) => new Person.fromMap(j)).toList();
    if (persons.length == 0) {
      _scaffoldKey.currentState
          ?.showSnackBar(new SnackBar(content: new Text('Data is empty.')));
      return;
    }
    Navigator.push(context, new UserListPageRoute(builder: (_) {
      return new UserList(persons: persons);
    }));
  }

  Future _search(Person person) async {
    var reply = await _realmHelper.search(person.toMap());
    var persons = reply[RealmHelper.resultKey].map((j) => new Person.fromMap(j)).toList();
    if (persons.length == 0) {
      _scaffoldKey.currentState?.showSnackBar(
          new SnackBar(content: new Text('Could not find matching person.')));
      return;
    }
    Navigator.push(context, new UserListPageRoute(builder: (_) {
      return new UserList(persons: persons);
    }));
    _initInputValues();
  }

  Future _deleteAll() async {
    await _realmHelper.delete();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(config.title),
        ),
        body: new Center(
            child: new Column(children: [
          new Container(
              margin: new EdgeInsets.only(
                  top: _margin, left: _margin, right: _margin),
              child: new Input(
                  labelText: 'First name',
                  value: _firstName,
                  onChanged: (v) {
                    setState(() {
                      _firstName = v;
                    });
                  })),
          new Container(
              margin: new EdgeInsets.only(left: _margin, right: _margin),
              child: new Input(
                  labelText: 'Last name',
                  value: _lastName,
                  onChanged: (v) {
                    setState(() {
                      _lastName = v;
                    });
                  })),
          new Container(
              margin: new EdgeInsets.only(left: _margin, right: _margin),
              child: new Input(
                  labelText: 'Age',
                  keyboardType: TextInputType.number,
                  value: _age,
                  onChanged: (v) {
                    setState(() {
                      _age = v;
                    });
                  })),
          new Container(
              margin: new EdgeInsets.only(
                  left: _margin, right: _margin, bottom: _margin),
              child: new Input(
                  labelText: 'Country',
                  value: _country,
                  onChanged: (v) {
                    setState(() {
                      _country = v;
                    });
                  })),
          new ButtonBar(children: [
            new RaisedButton(
                onPressed: () {
                  _save(new Person(
                      firstName: _firstName.text,
                      lastName: _lastName.text,
                      age: int.parse(_age.text, onError: (s) => -1),
                      country: _country.text));
                },
                child: new Text('SAVE')),
            new RaisedButton(
                onPressed: () {
                  _search(new Person(
                      firstName: _firstName.text,
                      lastName: _lastName.text,
                      age: int.parse(_age.text, onError: (s) => -1),
                      country: _country.text));
                },
                child: new Text('SEARCH'))
          ]),
          new Container(
              alignment: FractionalOffset.centerRight,
              margin: new EdgeInsets.only(left: _margin, right: _margin),
              child: new RaisedButton(
                  onPressed: () {
                    _loadAll();
                  },
                  child: new Container(
                      alignment: FractionalOffset.center,
                      width: 100.0,
                      child: new Text('LOAD ALL')))),
          new Container(
              alignment: FractionalOffset.centerRight,
              margin: new EdgeInsets.all(_margin),
              child: new RaisedButton(
                  onPressed: () {
                    _deleteAll();
                  },
                  child: new Container(
                      alignment: FractionalOffset.center,
                      width: 100.0,
                      child: new Text('DELETE ALL'))))
        ])));
  }
}
