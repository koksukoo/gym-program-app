import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/program.dart';
import '../providers/programs.dart';
import '../widgets/app_drawer.dart';

class ProgramListScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _ProgramListScreenState createState() => _ProgramListScreenState();
}

class _ProgramListScreenState extends State<ProgramListScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_ongoingProgram == null ? 'Loading...' : _ongoingProgram.name),
      ),
      body: _ongoingProgram == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Text('Hello'),
            ),
      drawer: AppDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Start Session',
        child: FittedBox(child: Text('New')),
      ),
    );
  }
}
