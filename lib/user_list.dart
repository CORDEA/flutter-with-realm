import 'package:flutter/material.dart';
import 'package:flutter_with_realm/person.dart';

class UserList extends StatelessWidget {
  static const String routeName = '/userList';

  UserList({List<Person> persons}) {
    _persons = persons;
  }

  List<Person> _persons;

  @override
  Widget build(BuildContext context) {
    print(_persons);
    return new Theme(
        data: new ThemeData(
          primarySwatch: Colors.blue,
          iconTheme: new IconThemeData(color: Colors.white),
          platform: Theme.of(context).platform,
        ),
        child: new UserListPage(
            persons: _persons,
            title: _persons.length == 1
                ? '${_persons.length} Person'
                : '${_persons.length} Persons'));
  }
}

class UserListPageRoute<T> extends MaterialPageRoute<T> {
  UserListPageRoute(
      {WidgetBuilder builder, RouteSettings settings: const RouteSettings()})
      : super(builder: builder, settings: settings);
}

class UserListPage extends StatefulWidget {
  UserListPage({Key key, this.persons, this.title}) : super(key: key);

  List<Person> persons;

  String title;

  @override
  _UserListPageState createState() => new _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  Widget _buildListItem(Person person) {
    return new ListItem(
        title: new Text('${person.firstName} ${person.lastName}'),
        subtitle: new Text('${person.age} years old, from ${person.country}'));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(config.title)),
        body: new MaterialList(
            children: config.persons.map((p) => _buildListItem(p)).toList()));
  }
}
