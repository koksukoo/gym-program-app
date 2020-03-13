import 'package:flutter/foundation.dart';

import '../models/program.dart';

class Programs with ChangeNotifier {
  List<Program> _items = [];

  List<Program> get items =>[..._items];

  Future <void> refreshPrograms() async {
    
  }

  Future <void> addProgram(Program program) async {
    print(program.toString());
    _items.add(program);
    notifyListeners();
  }
}