import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../helpers/db_helper.dart';
import '../models/session.dart';

class Sessions with ChangeNotifier {
  List<Session> _items = [];
  String _ongoingId;

  List<Session> get items => [..._items];

  Future<Session> get ongoing async {
    if (_items.length <= 0) {
      return null;
    }
    if (_ongoingId == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String prefsId = prefs.getString('ongoingSessionId') ?? null;
      _ongoingId = prefsId;
    }
    notifyListeners();
    return _ongoingId == null
        ? null
        : _items.firstWhere((item) => item.id == _ongoingId);
  }

  Future<void> setOngoing(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (id == null) {
      prefs.remove('ongoingSessionId');
      _ongoingId = null;
      notifyListeners();
      return;
    }
    final item = _items.firstWhere((item) => item.id == id);
    if (item != null) {
      _ongoingId = item.id;
      prefs.setString('ongoingSessionId', item.id);
    }
    notifyListeners();
  }

  Future<void> addSession(Session session, [bool setActive = false]) async {
    final index = _items.indexWhere((item) => item.id == session.id);
    if (index >= 0) {
      _items[index] = session;
    } else {
      if (_ongoingId != null) {
        return; // can not create new if there is an ongoing session
      }
      _items.add(session);
    }
    if (setActive) {
      await setOngoing(session.id);
    }
    notifyListeners();

    DBHelper.insert('sessions', session.toDatabaseFormat());
  }

  Future<void> refreshSessions(String programId) async {
    final response = await DBHelper.getData('sessions');
    _items = response
        .map((program) => Session.fromDatabaseFormat(program))
        .where((session) => session.programId == programId).toList();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (items.length > 0) {
      final ongoingPref = prefs.getString('ongoingSessionId');
      _ongoingId = ongoingPref;
    }

    notifyListeners();
  }

  Session findById(String id) => _items.firstWhere((item) => item.id == id);

  void delete(String id) {
    _items.removeWhere((item) => item.id == id);
    if (_ongoingId == id) {
      setOngoing(null);
    }
    notifyListeners();

    DBHelper.delete('sessions', id);
  }
}
