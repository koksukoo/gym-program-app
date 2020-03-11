import 'package:flutter/material.dart';

class EditProgramScreen extends StatefulWidget {
  static const routeName = '/edit-program';

  @override
  _EditProgramScreenState createState() => _EditProgramScreenState();
}

class _EditProgramScreenState extends State<EditProgramScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Program')),
    );
  }
}