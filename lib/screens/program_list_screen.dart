import 'package:flutter/material.dart';

class ProgramListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Program name')),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
