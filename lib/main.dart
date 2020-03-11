import 'package:flutter/material.dart';

import './screens/program_list_screen.dart';
import './screens/edit_program_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProgramListScreen(),
      routes: {
        EditProgramScreen.routeName: (ctx) => EditProgramScreen(),  
      },
    );
  }
}
