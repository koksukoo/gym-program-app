import 'dart:async';
import 'dart:math';

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
  var _randomString = Random().nextInt(10000).toString();

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

  bool isCompletedExercise(int index) =>
      _session.completedExerciseIds != null &&
      _session.completedExerciseIds.contains(_programDay.exercises[index].id);

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
                      body: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10),
                          if (_session.completedExerciseIds != null &&
                              _session.completedExerciseIds.length >
                                  0) ...<Widget>[
                            Text('Done exercises:',
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            Expanded(
                                flex: 0,
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _programDay.exercises.length,
                                    itemBuilder: (ctx, i) =>
                                        isCompletedExercise(i)
                                            ? ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor: Colors.grey,
                                                  child: FittedBox(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: Column(
                                                        children: <Widget>[
                                                          Text(
                                                            _programDay
                                                                .exercises[i]
                                                                .repeats
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize: 24,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          Text('reps',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                    _programDay
                                                        .exercises[i].name,
                                                    style: TextStyle(
                                                        color: Colors.grey)),
                                              )
                                            : null))
                          ],
                          Text(
                            'Upcoming exercises:',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _programDay.exercises.length,
                              itemBuilder: (context, i) => isCompletedExercise(
                                      i)
                                  ? null
                                  : Dismissible(
                                      direction: DismissDirection.startToEnd,
                                      background: Container(
                                        color: Colors.green,
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20.0),
                                          child: Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          child: FittedBox(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                children: <Widget>[
                                                  Text(
                                                    _programDay
                                                        .exercises[i].repeats
                                                        .toString(),
                                                    style:
                                                        TextStyle(fontSize: 24),
                                                  ),
                                                  Text('reps'),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        title:
                                            Text(_programDay.exercises[i].name),
                                      ),
                                      key: Key(_programDay.exercises[i].id +
                                          _randomString),
                                      onDismissed: (direction) {
                                        var ex = _programDay.exercises[i];
                                        final ses = Session(
                                          id: _session.id,
                                          date: _session.date,
                                          duration: DateTime.now()
                                              .difference(_session.date),
                                          programDayId: _session.programDayId,
                                          completedExerciseIds: [
                                            ..._session.completedExerciseIds,
                                            ex.id
                                          ],
                                        );
                                        _randomString =
                                            Random().nextInt(10000).toString();
                                        sessions.addSession(ses).then((_) {
                                          setState(() {
                                            _session = ses;
                                          });
                                          print(_session.completedExerciseIds
                                              .toString());
                                          print(_programDay.exercises.length);
                                        });
                                      },
                                    ),
                            ),
                          ),
                          Container(
                              height: Theme.of(context).buttonTheme.height,
                              width: double.infinity,
                              child: RaisedButton(
                                color: Colors.redAccent,
                                onPressed: () {
                                  sessions.addSession(Session(
                                    id: _session.id,
                                    date: _session.date,
                                    duration: DateTime.now()
                                        .difference(_session.date),
                                    programDayId: _session.programDayId,
                                    completedExerciseIds:
                                        _session.completedExerciseIds,
                                  ));
                                  sessions.setOngoing(null).then((_) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Text(
                                  'End Session',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ],
                      ),
                    );
            },
          );
  }
}
