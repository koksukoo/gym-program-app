import 'package:flutter/foundation.dart';
import './exercise.dart';

class Program {
  final String id;
  final String name;
  final int cycles;
  final List<ProgramDay> programDays;

  Program({
    @required this.id,
    @required this.name,
    @required this.cycles,
    @required this.programDays,
  });
}

class ProgramDay {
  final String id;
  final String name;
  final List<Exercise> exercises;

  ProgramDay({
    @required this.id,
    @required this.name,
    @required this.exercises,
  });
}
