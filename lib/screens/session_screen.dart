import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/program.dart';
import '../models/session.dart';
import '../providers/programs.dart';
import '../providers/sessions.dart';

class SessionScreen extends StatefulWidget {
  static const routeName = '/program-session';

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  Program _ongoingProgram;
  Session _session;
  ProgramDay _programDay;
  var _clock = '00:00:00';
  Timer _timer;

  void updateClock(Timer timer) {
    final difference = DateTime.now().difference(_session.date);
    final durationSeconds = difference.inSeconds;
    final hours = (durationSeconds / 3600).floor();
    final minutes = (durationSeconds / 60 - (hours * 60)).floor();
    final seconds = (durationSeconds - hours * 3600 - minutes * 60).floor();
    setState(() {
      _clock =
        '${hours < 10 ? '0' : ''}$hours:${minutes < 10 ? '0' : ''}$minutes:${seconds < 10 ? '0' : ''}$seconds';
    });
  }

  @override
  void initState() {
    Provider.of<Programs>(context, listen: false).ongoing.then((value) {
      setState(() {
        _ongoingProgram = value;
      });
    });
    Provider.of<Sessions>(context, listen: false).ongoing.then((session) {
      setState(() {
        _session = session;
        _programDay = _ongoingProgram.programDays
            .firstWhere((item) => item.id == _session.programDayId);
      });
    });
    _timer = Timer.periodic(Duration(milliseconds: 500), updateClock);
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _ongoingProgram == null
        ? CircularProgressIndicator()
        : Consumer<Sessions>(
            builder: (BuildContext context, sessions, Widget child) {
              return _session == null
                  ? CircularProgressIndicator()
                  : Scaffold(
                      appBar:
                          AppBar(title: Text('${_programDay.name} – $_clock')),
                    );
            },
          );
  }
}
