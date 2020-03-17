import 'package:flutter/foundation.dart';

import '../models/program.dart';
import '../helpers/db_helper.dart';

class Programs with ChangeNotifier {
  List<Program> _items = [];

  List<Program> get items => [..._items.reversed];

  Future<void> refreshPrograms() async {
    final response = await DBHelper.getData('programs');
    _items =
        response.map((program) => Program.fromDatabaseFormat(program)).toList();
    notifyListeners();
  }

  void addProgram(Program program) {
    final index = _items.indexWhere((item) => item.id == program.id);
    if (index >= 0) {
      _items[index] = program;
    } else {
      _items.add(program);
    }
    notifyListeners();

    DBHelper.insert('programs', program.toDatabaseFormat());
  }

  Program findById(String id) => _items.firstWhere((item) => item.id == id);

  void delete(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();

    DBHelper.delete('programs', id);
  }
}
