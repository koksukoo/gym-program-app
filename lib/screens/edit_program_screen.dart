import 'package:flutter/material.dart';

import '../widgets/program_section_field.dart';

class EditProgramScreen extends StatefulWidget {
  static const routeName = '/edit-program';

  @override
  _EditProgramScreenState createState() => _EditProgramScreenState();
}

class _EditProgramScreenState extends State<EditProgramScreen> {
  final _form = GlobalKey<FormState>();
  List<Map<String, dynamic>> _sections = [];

  void _addTrainingSection() {
    setState(() {
      _sections.add({
        'name': '',
        'exercises': <Map<String, dynamic>>[],
      });
    });
  }

  void _addExercise(int index) {
    setState(() {
      _sections[index]['exercises'].add({
        'name': '',
        'description': '',
        'reps': 0,
        'isMinutes': false,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Edit Program')),
        body: Padding(
          child: Form(
            key: _form,
            child: ListView(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name of the program'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {},
                ),
                SizedBox(height: 10),
                for (var i = 0; i < _sections.length; i++)
                  ProgramSectionField(i: i, sections: _sections, addExercise: _addExercise),
                SizedBox(height: 10),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add_circle_outline, color: Colors.white),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Add a training section',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          Text(
                            'You need at least one',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          )
                        ],
                      )
                    ],
                  ),
                  onPressed: _addTrainingSection,
                ),
              ],
            ),
          ),
          padding: const EdgeInsets.all(10.0),
        ));
  }
}
