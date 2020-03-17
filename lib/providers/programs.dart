import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/program.dart';
import '../helpers/db_helper.dart';

class Programs with ChangeNotifier {
  List<Program> _items = [];
  String _ongoingId;

  List<Program> get items => [..._items.reversed];

  Future<Program> get ongoing async {
    await refreshPrograms();
    if (_items.length <= 0) {
      return null;
    }
    if (_ongoingId == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String prefsId = prefs.getString('ongoingProgramId') ?? items[0].id;
      _ongoingId = prefsId;
    }
    notifyListeners();
    return _items.firstWhere((item) => item.id == _ongoingId);
  }

  Future<void> setOngoing(String id) async {
    final item = _items.firstWhere((item) => item.id == id);
    if (item != null) {
      _ongoingId = item.id;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('ongoingProgramId', item.id);
    }
  }

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
