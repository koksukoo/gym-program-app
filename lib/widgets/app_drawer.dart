import 'package:flutter/material.dart';
import '../screens/edit_program_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: <Widget>[
        AppBar(title: Text('Manage Programs'),
        automaticallyImplyLeading: false,),
        Divider(),
        ListTile(
          leading: Icon(Icons.add),
          title: Text('Add a New Program'),
          onTap: () {
            Navigator.of(context).pushReplacementNamed(EditProgramScreen.routeName);
          },
        ),
      ],)
    );
  }
}