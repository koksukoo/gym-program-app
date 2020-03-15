import 'dart:convert';

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

  Map<String, dynamic> toDatabaseFormat() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'cycles': cycles,
      'programDays':
          json.encode(programDays.map((day) => day.toMap()).toList()),
    };
    return data;
  }

  factory Program.fromDatabaseFormat(Map<String, dynamic> dbProgram) => Program(
        cycles: dbProgram['cycles'],
        id: dbProgram['id'],
        name: dbProgram['name'],
        programDays: json
            .decode(dbProgram['programDays'])
            .map<ProgramDay>(
              (dbDay) => ProgramDay(
                id: dbDay['id'],
                name: dbDay['name'],
                exercises: dbDay['exercises']
                    .map<Exercise>((dbEx) => Exercise(
                          id: dbEx['id'],
                          name: dbEx['name'],
                          repeats: dbEx['repeats'],
                          description: dbEx['description'],
                          isMinutes: dbEx['isMinutes'],
                        ))
                    .toList(),
              ),
            )
            .toList(),
      );
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

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'exercises': exercises
          .map(
            (ex) => {
              'id': ex.id,
              'name': ex.name,
              'repeats': ex.repeats,
              'description': ex.description,
              'isMinutes': ex.isMinutes,
            },
          )
          .toList(),
    };

    return data;
  }
}
