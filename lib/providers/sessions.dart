import 'package:flutter/foundation.dart';
import '../models/session.dart';

class Sessions with ChangeNotifier {
  List<Session> _items = [];

  List<Session> get items => [..._items];
}