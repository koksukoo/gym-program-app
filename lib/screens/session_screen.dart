import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/program.dart';
import '../providers/programs.dart';
import '../providers/sessions.dart';

class SessionScreen extends StatefulWidget {
  static const routeName = '/program-session';

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  Program _ongoingProgram;

  @override
  void initState() {
    Provider.of<Programs>(context, listen: false).ongoing.then((value) {
      setState(() {
        _ongoingProgram = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _ongoingProgram == null ? CircularProgressIndicator() : Consumer<Sessions>(
      builder: (BuildContext context, sessions, Widget child) {
        var session = sessions.ongoing;
        var programDay = _ongoingProgram.programDays
            .firstWhere((item) => item.id == session.programDayId);
        return session == null
            ? CircularProgressIndicator()
            : Scaffold(
                appBar: AppBar(title: Text(programDay.name)),
              );
      },
    );
  }
}
