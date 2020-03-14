import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/program.dart';
import '../models/exercise.dart';
import '../providers/programs.dart';
import '../widgets/program_section_field.dart';

class EditProgramScreen extends StatefulWidget {
  static const routeName = '/edit-program';

  @override
  _EditProgramScreenState createState() => _EditProgramScreenState();
}

class _EditProgramScreenState extends State<EditProgramScreen> {
  final _form = GlobalKey<FormState>();
  var _programName = '';
  List<Map<String, dynamic>> _sections = [];

  void _addTrainingSection() {
    setState(() {
      _sections.add({
        'name': '',
        'exercises': <Map<String, dynamic>>[],
        'focusNode': FocusNode(),
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
        'focusNodes': {
          'name': FocusNode(),
          'description': FocusNode(),
          'reps': FocusNode(),
        },
      });
    });
  }

  void _setSectionName(int index, String value) {
    _sections[index]['name'] = value;
  }

  void _setExercise(
      int sectionIndex, int exIndex, String field, dynamic value) {
    _sections[sectionIndex]['exercises'][exIndex][field] = value;
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();
    final uuid = Uuid();
    final program = Program(
      id: uuid.v1(),
      name: _programName,
      cycles: 1,
      programDays: _sections.map((section) => ProgramDay(
            id: uuid.v1(),
            name: section['name'],
            exercises: section['exercises'].map<Exercise>((exercise) => Exercise(
                  id: uuid.v1(),
                  name: exercise['name'],
                  repeats: exercise['repeats'],
                  description: exercise['description'],
                  isMinutes: exercise['isMinutes'],
                )).toList(),
          )).toList(),
    );

    Provider.of<Programs>(context, listen: false).addProgram(program);
  }

  @override
  void dispose() {
    _sections.forEach((section) {
      section['focusNode'].dispose();
      section['exercises'].forEach((ex) {
        ex['focusNodes']['name'].dispose();
        ex['focusNodes']['description'].dispose();
        ex['focusNodes']['reps'].dispose();
      });
    });
    super.dispose();
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
                    decoration:
                        InputDecoration(labelText: 'Name of the program'),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      if (_sections.length <= 0) {
                        return;
                      }
                      FocusScope.of(context)
                          .requestFocus(_sections[0]['focusNode']);
                    },
                    onSaved: (value) {
                      _programName = value;
                    },
                    validator: (value) =>
                        value.isEmpty ? 'Provide a name' : null),
                SizedBox(height: 10),
                for (var i = 0; i < _sections.length; i++)
                  ProgramSectionField(
                    i: i,
                    section: _sections[i],
                    addExercise: _addExercise,
                    setSectionName: _setSectionName,
                    setExercise: _setExercise,
                  ),
                SizedBox(height: 10),
                FlatButton(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.add, color: Theme.of(context).accentColor),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Add a training section',
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text(
                            'You need at least one',
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 12),
                          )
                        ],
                      )
                    ],
                  ),
                  onPressed: _addTrainingSection,
                ),
                SizedBox(height: 10),
                RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _saveForm,
                ),
              ],
            ),
          ),
          padding: const EdgeInsets.all(10.0),
        ));
  }
}
