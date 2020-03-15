import 'package:flutter/material.dart';
import '../screens/user_programs_screen.dart';
import '../screens/edit_program_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        AppBar(
          title: Text('Manage Programs'),
          automaticallyImplyLeading: false,
        ),
        ListTile(
          leading: Icon(Icons.assignment),
          title: Text('Ongoing Program'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/');
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.school),
          title: Text('Your Programs'),
          onTap: () {
            Navigator.of(context)
                .pushReplacementNamed(UserProgramsScreen.routeName);
          },
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add a New Program'),
          onTap: () {
            Navigator.of(context).pushNamed(EditProgramScreen.routeName);
          },
        ),
      ],
    ));
  }
}
