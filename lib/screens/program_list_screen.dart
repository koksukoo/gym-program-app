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
                onPressed: () async {
                  await Provider.of<Sessions>(context, listen: false).addSession(
                    Session(
                        id: _uuid.v1(),
                        date: DateTime.now(),
                        duration: null,
                        programDayId: _selectedSection.id),
                  );
                  Navigator.pushNamed(context, SessionScreen.routeName);
                },
                child: Text('Start Session',
                    style: TextStyle(color: Colors.white)),
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ));
  }

  @override
  void initState() {
    Provider.of<Programs>(context, listen: false).ongoing.then((value) {
      setState(() {
        _ongoingProgram = value;
      });
    });
    Provider.of<Sessions>(context, listen: false).refreshSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, Sessions sessions, _) => Scaffold(
        appBar: AppBar(
          title: Text(
              _ongoingProgram == null ? 'Loading...' : _ongoingProgram.name),
        ),
        body: _ongoingProgram == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: sessions.items.length,
                itemBuilder: (ctx, i) =>
                    ListTile(leading: Text(sessions.items[i].id)),
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
