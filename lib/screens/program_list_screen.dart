import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class ProgramListScreen extends StatelessWidget {
  static const routeName = '/';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Program name')),
      body: Center(
        child: CircularProgressIndicator(),
      ),
      drawer: AppDrawer(),
    );
  }
}
