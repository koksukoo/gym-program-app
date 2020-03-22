import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../models/program.dart';
import '../models/session.dart';
import '../providers/programs.dart';
import '../providers/sessions.dart';
import '../widgets/app_drawer.dart';
import './session_screen.dart';

class ProgramListScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _ProgramListScreenState createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
  Program _ongoingProgram;
  Session _ongoingSession;
  ProgramDay _selectedSection;
  var _uuid = Uuid();

  void _startSession() {
    print('start a session');
    showDialog(
        context: context,
        child: StatefulBuilder(
          builder: (context, setState) => SimpleDialog(
            title: Text('Select a program section'),
            elevation: 3,
            titlePadding: EdgeInsets.all(10),
            contentPadding: EdgeInsets.all(10),
            children: <Widget>[
              for (var i = 0; i < _ongoingProgram.programDays.length; i++)
                Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              _selectedSection == _ongoingProgram.programDays[i]
                                  ? Theme.of(context).accentColor
                                  : Colors.transparent,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: ListTile(
                        trailing: CircleAvatar(
                          radius: 25,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              child: Column(children: <Widget>[
                                Text(
                                  '${_ongoingProgram.programDays[i].exercises.length.toString()}',
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text('Exercises'),
                              ]),
                            ),
                          ),
                        ),
                        title: Text(
                          _ongoingProgram.programDays[i].name,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Completed 0/1 times'),
                        selected:
                            _selectedSection == _ongoingProgram.programDays[i],
                        onTap: () {
                          setState(() {
                            _selectedSection = _ongoingProgram.programDays[i];
                          });
                        },
                      ),
                    ),
                    if (i + 1 < _ongoingProgram.programDays.length) Divider(),
                  ],
                ),
              SizedBox(height: 20),
              RaisedButton(
                onPressed: _selectedSection == null
                    ? null
                    : () async {
                        await Provider.of<Sessions>(context, listen: false)
                            .addSession(
                                Session(
                                    id: _uuid.v1(),
                                    date: DateTime.now(),
                                    duration: null,
                                    programDayId: _selectedSection.id,
                                    completedExerciseIds: []),
                                true);
                        Navigator.pushReplacementNamed(
                            context, SessionScreen.routeName);
                      },
                child: Text('Start Session',
                    style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ));
  }

  Future<void> _refreshSessions() async {
    await Provider.of<Sessions>(context, listen: false).refreshSessions();
  }

  @override
  void initState() {
    Provider.of<Programs>(context, listen: false).ongoing.then((value) {
      setState(() {
        _ongoingProgram = value;
      });
    });
    Provider.of<Sessions>(context, listen: false).refreshSessions();
    Provider.of<Sessions>(context, listen: false).ongoing.then((value) {
      setState(() {
        _ongoingSession = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Consumer(
      builder: (BuildContext ctx, Sessions sessions, _) => Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text(
              _ongoingProgram == null ? 'Loading...' : _ongoingProgram.name),
        ),
        body: _ongoingProgram == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                child: ListView.builder(
                  itemCount: sessions.items.length,
                  itemBuilder: (ctx, i) {
                    final programDay = _ongoingProgram.programDays.firstWhere(
                        (item) => item.id == sessions.items[i].programDayId);
                    final session = sessions.items[i];
                    final hasCompletedExercises =
                        session.completedExerciseIds != null;
                    final durationSeconds = session.duration.inSeconds;
                    final hours = (durationSeconds / 3600).floor();
                    final minutes =
                        (durationSeconds / 60 - (hours * 60)).floor();
                    final seconds =
                        (durationSeconds - hours * 3600 - minutes * 60).floor();
                    final time =
                        '${hours > 0 ? '${hours}h' : ''} ${minutes}min ${seconds}s';

                    final subtitle =
                        'Completed ${!hasCompletedExercises ? 0 : session.completedExerciseIds.length}/${programDay.exercises.length} of exercises';
                    return Dismissible(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                '${session.date.day}.${session.date.month}',
                              ),
                            ),
                          ),
                        ),
                        title: Text(programDay.name),
                        subtitle: Text(subtitle),
                        trailing: _ongoingSession != null &&
                                _ongoingSession.id == session.id
                            ? Text(
                                'ONGOING',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).accentColor),
                              )
                            : Text(time),
                      ),
                      key: Key(session.id),
                      background: Container(
                        alignment: Alignment.centerRight,
                        color: Colors.redAccent,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        sessions.delete(session.id);
                        scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                            content: Center(
                              heightFactor: 1,
                              child: Text(
                                  'Session ${programDay.name} on ${session.date.day}.${session.date.month} Deleted!'),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                onRefresh: _refreshSessions,
              ),
        drawer: AppDrawer(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _startSession();
          },
          tooltip: 'Start Session',
          child: FittedBox(child: Text('New')),
        ),
      ),
    );
  }
}
