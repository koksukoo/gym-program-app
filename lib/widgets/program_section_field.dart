import 'package:flutter/material.dart';
import './program_exercise_field.dart';

class ProgramSectionField extends StatelessWidget {
  const ProgramSectionField({
    Key key,
    @required this.i,
    @required List<Map<String, dynamic>> sections,
    @required this.addExercise
  }) : _sections = sections, super(key: key);

  final int i;
  final List<Map<String, dynamic>> _sections;
  final Function addExercise;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12, width: 1),
            borderRadius: BorderRadius.circular(3),
          ),
          padding:
              EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: CircleAvatar(
                      child: Text((i + 1).toString())),
                ),
                title: TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Name of the section'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {},
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: <Widget>[
                  ..._sections[i]['exercises'].map(
                    (exercise) => ProgramExerciseField(),
                  ),
                ],
              ),
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.add,
                        color: Theme.of(context).accentColor),
                    SizedBox(width: 10),
                    Text(
                      'Add an exercise',
                      style: TextStyle(
                          color: Theme.of(context).accentColor),
                    ),
                  ],
                ),
                onPressed: () {
                  addExercise(i);
                },
              ),
              SizedBox(height: 10)
            ],
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }
}