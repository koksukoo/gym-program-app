import 'package:flutter/foundation.dart';

import '../models/program.dart';
import '../helpers/db_helper.dart';

class Programs with ChangeNotifier {
  List<Program> _items = [];

  List<Program> get items =>[..._items];

  Future <void> refreshPrograms() async {
    
  }

  void addProgram(Program program) {
    print(program.toString());
    _items.add(program);
    notifyListeners();

    DBHelper.insert('programs', program.toDatabaseFormat());
  }
}