import 'package:flutter/material.dart';
import './program_exercise_field.dart';

class ProgramSectionField extends StatelessWidget {
  const ProgramSectionField({
    Key key,
    @required this.i,
    @required Map<String, dynamic> section,
    @required this.addExercise,
    @required this.setSectionName,
    @required this.setExercise,
    @required this.removeSection,
    @required this.removeExercise,
  })  : _section = section,
        super(key: key);

  final int i;
  final Map<String, dynamic> _section;
  final Function addExercise;
  final Function setSectionName;
  final Function setExercise;
  final Function removeSection;
  final Function removeExercise;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Card(
          semanticContainer: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                ListTile(
                  contentPadding: EdgeInsets.all(0),
                  leading: Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: CircleAvatar(child: Text((i + 1).toString())),
                  ),
                  title: TextFormField(
                    key: _section['key'],
                    decoration:
                        InputDecoration(labelText: 'Name of the section'),
                    initialValue: _section['name'],
                    textInputAction: TextInputAction.next,
                    focusNode: _section['focusNode'],
                    onFieldSubmitted: (_) {
                      if (_section['exercises'].length <= 0) {
                        return;
                      }
                      FocusScope.of(context).requestFocus(
                          _section['exercises'][0]['focusNodes']['name']);
                    },
                    onSaved: (value) {
                      setSectionName(i, value);
                    },
                    validator: (value) =>
                        value.isEmpty ? 'Provide a name' : null,
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: <Widget>[
                    for (var j = 0; j < _section['exercises'].length; j++)
                      if (_section['exercises'][j] != null)
                      ProgramExerciseField(
                          exercise: _section['exercises'][j],
                          setExercise: (field, value) {
                            setExercise(i, j, field, value);
                          },
                          removeExercise: () {
                            removeExercise(context, i, j);
                          }),
                  ],
                ),
                ButtonBar(
                  children: <Widget>[
                    FlatButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.add, color: Theme.of(context).accentColor),
                          SizedBox(width: 10),
                          Text(
                            'Add an Exercise',
                            style:
                                TextStyle(color: Theme.of(context).accentColor),
                          ),
                        ],
                      ),
                      onPressed: () {
                        addExercise(i);
                      },
                    ),
                    FlatButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.delete_outline, color: Colors.redAccent),
                          SizedBox(width: 10),
                          Text(
                            'Remove',
                            style: TextStyle(color: Colors.redAccent),
                          ),
                        ],
                      ),
                      onPressed: () {
                        removeSection(context, i, _section['id']);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10)
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}
