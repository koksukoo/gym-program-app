import 'package:flutter/material.dart';

class ProgramExerciseField extends StatelessWidget {
  const ProgramExerciseField({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black12),
            borderRadius: BorderRadius.circular(3)
          ),
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Name of the exercise'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {},
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Description'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {},
            ),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Repeats'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_) {},
            ),
            SizedBox(height: 10),
          ],),
        ),
        SizedBox(height: 10)
      ],
    );
  }
}