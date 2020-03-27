import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/program.dart';
import '../models/exercise.dart';
import '../providers/programs.dart';
import '../widgets/program_section_field.dart';
import './user_programs_screen.dart';

class EditProgramScreen extends StatefulWidget {
  static const routeName = '/edit-program';

  @override
  _EditProgramScreenState createState() => _EditProgramScreenState();
}

class _EditProgramScreenState extends State<EditProgramScreen> {
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  final _uuid = Uuid();
  String _programId;
  var _programName = '';
  var _programNameKey = GlobalKey();
  List<Map<String, dynamic>> _sections = [];

  void _addTrainingSection({name: '', String id}) {
    setState(() {
      _sections.add({
        'key': GlobalKey(),
        'id': id,
        'name': name,
        'exercises': <Map<String, dynamic>>[],
        'focusNode': FocusNode(),
      });
    });
  }

  void _addExercise(
    int index, {
    String id,
    name: '',
    description: '',
    reps: 0,
    isMinutes: false,
  }) {
    setState(() {
      _sections[index]['exercises'].add({
        'id': id,
        'name': name,
        'description': description,
        'reps': reps.toString(),
        'isMinutes': isMinutes,
        'focusNodes': {
          'name': FocusNode(),
          'description': FocusNode(),
          'reps': FocusNode(),
        },
        'keys': {
          'name': GlobalKey(),
          'description': GlobalKey(),
          'reps': GlobalKey(),
        }
      });
    });
  }

  void _setSectionName(int index, String value) {
    if (_sections[index] != null) {
      _sections[index]['name'] = value;
    }
  }

  void _setExercise(
      int sectionIndex, int exIndex, String field, dynamic value) {
    if (_sections[sectionIndex] != null &&
        _sections[sectionIndex]['exercises'][exIndex] != null) {
      _sections[sectionIndex]['exercises'][exIndex][field] = value;
    }
  }

  Future<void> _removeSection(context, int index, String id) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This can not be undone'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                _sections[index] = null;
              });
              // _saveForm(navigateBack: false);

              Navigator.of(ctx).pop();
            },
            child: Text(
              'Remove Section',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeExercise(context, int sectionIndex, int exIndex) {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('This can not be undone'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Cancel'),
          ),
          FlatButton(
            onPressed: () {
              setState(() {
                _sections[sectionIndex]['exercises'][exIndex] = null;
              });
              // _saveForm(navigateBack: false);

              Navigator.of(ctx).pop();
            },
            child: Text(
              'Remove Exercise',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveForm({bool navigateBack: true}) async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }

    _form.currentState.save();

    final program = Program(
      id: _programId ?? _uuid.v1(),
      name: _programName,
      cycles: 1,
      programDays: _sections
          .where((item) => item != null)
          .map((section) => ProgramDay(
                id: section['id'] ?? _uuid.v1(),
                name: section['name'],
                exercises: section['exercises']
                    .where((item) => item != null)
                    .map<Exercise>((exercise) => Exercise(
                          id: exercise['id'] ?? _uuid.v1(),
                          name: exercise['name'],
                          repeats: int.parse(exercise['reps']),
                          description: exercise['description'],
                          isMinutes: exercise['isMinutes'],
                        ))
                    .toList(),
              ))
          .toList(),
    );

    Provider.of<Programs>(context, listen: false).addProgram(program);
    if (navigateBack) {
      Navigator.of(context).pushReplacementNamed(UserProgramsScreen.routeName);
    }
  }

  @override
  void dispose() {
    _sections.forEach((section) {
      section['focusNode'].dispose();
      if (section != null) {
        section['exercises'].where((item) => item != null).forEach((ex) {
          if (ex != null) {
            ex['focusNodes']['name'].dispose();
            ex['focusNodes']['description'].dispose();
            ex['focusNodes']['reps'].dispose();
          }
        });
      }
    });
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      var programId = ModalRoute.of(context).settings.arguments as String;
      if (programId != null) {
        var _program =
            Provider.of<Programs>(context, listen: false).findById(programId);
        _programName = _program.name;
        _programId = _program.id;

        for (var i = 0; i < _program.programDays.length; i++) {
          _addTrainingSection(
            name: _program.programDays[i].name,
            id: _program.programDays[i].id,
          );
          _program.programDays[i].exercises.forEach((ex) {
            _addExercise(
              i,
              id: ex.id,
              name: ex.name,
              description: ex.description,
              reps: ex.repeats,
              isMinutes: ex.isMinutes,
            );
          });
        }
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var programId = ModalRoute.of(context).settings.arguments as String;
    var isNewProgram = programId == null;

    return Scaffold(
      appBar: AppBar(
          title: Text(isNewProgram ? 'Create a New Program' : 'Edit Program')),
      body: Padding(
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                    key: _programNameKey,
                    decoration:
                        InputDecoration(labelText: 'Name of the program'),
                    textInputAction: TextInputAction.next,
                    initialValue: _programName,
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
                  if (_sections[i] != null)
                    ProgramSectionField(
                      i: i,
                      section: _sections[i],
                      addExercise: _addExercise,
                      setSectionName: _setSectionName,
                      setExercise: _setExercise,
                      removeSection: _removeSection,
                      removeExercise: _removeExercise,
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
                        ],
                      )
                    ],
                  ),
                  onPressed: () {
                    _addTrainingSection(id: _uuid.v1());
                  },
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
        ),
        padding: const EdgeInsets.all(10.0),
      ),
    );
  }
}
