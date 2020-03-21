import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/program_list_screen.dart';
import './screens/edit_program_screen.dart';
import './screens/user_programs_screen.dart';
import './screens/session_screen.dart';
import './providers/programs.dart';
import './providers/sessions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        home: ProgramListScreen(),
        routes: {
          EditProgramScreen.routeName: (ctx) => EditProgramScreen(),
          UserProgramsScreen.routeName: (ctx) => UserProgramsScreen(),
          SessionScreen.routeName: (ctx) => SessionScreen(),
        },
      ),
      providers: [
        ChangeNotifierProvider.value(value: Programs()),
        ChangeNotifierProvider.value(value: Sessions()),
      ],
    );
  }
}
