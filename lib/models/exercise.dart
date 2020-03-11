import 'package:flutter/foundation.dart';

class Exercise {
  final String id;
  final String name;
  final int repeats;
  final String description;
  final bool isMinutes;

  Exercise({
    @required this.id,
    @required this.name,
    @required this.repeats,
    this.description = '',
    this.isMinutes = false,
  });
}
