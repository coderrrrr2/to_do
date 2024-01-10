import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/models/to_do.dart';

class SqfLiteService {
  static SqfLiteService? _instance;
  late Database _dbInstance;

  SqfLiteService._(); // Private constructor

  factory SqfLiteService() {
    _instance ??= SqfLiteService._();
    return _instance!;
  }

  Future<Database> initializeDataBase() async {
    final dbPath = await sql.getDatabasesPath();
    final database = await sql.openDatabase(path.join(dbPath, 'Todos.db'),
        onCreate: (db, version) {
      db.execute(
          "CREATE TABLE user_todos (id TEXT PRIMARY KEY, taskName TEXT, hour INTEGER, minute INTEGER, date TEXT, taskDayClassification TEXT, repeatTaskDays TEXT, isChecked INTEGER)");
    }, version: 1);
    return database;
  }

  Future<void> setDbInstance() async {
    _dbInstance = await initializeDataBase();
  }

  Future<List<ToDo>> loadPlaces() async {
    await setDbInstance();
    final data = await _dbInstance.query('user_todos');
    return data.map((row) {
      return ToDo(
        taskName: row['taskName'] as String,
        date: DateTime.parse(row['date'] as String),
        time: TimeOfDay(
          hour: row['hour'] as int,
          minute: row['minute'] as int,
        ),
        repeatTaskDays: row['repeatTaskDays'] as String,
        id: row['id'] as String,
        isChecked: row["isChecked"] == 1,
      );
    }).toList();
  }

  void insertIntoDatabase(ToDo todo) async {
    _dbInstance.insert('user_todos', {
      'id': todo.id,
      'taskName': todo.taskName,
      'hour': todo.time.hour,
      'minute': todo.time.minute,
      'date': todo.date.toString(),
      'taskDayClassification': todo.taskDayClassification,
      'repeatTaskDays': todo.repeatTaskDays,
      'isChecked': todo.isChecked ? 1 : 0,
    });
  }

  void deleteFromDataBase(ToDo todo) async {
    await _dbInstance
        .delete('user_todos', where: 'id == ?', whereArgs: [todo.id]);
  }

  void updateDataBaseValue(
      {required ToDo oldtodo, required ToDo newtodo}) async {
    await _dbInstance.update(
      'user_todos',
      {
        'taskName': newtodo.taskName,
        'hour': newtodo.time.hour,
        'minute': newtodo.time.minute,
        'date': newtodo.date.toString(),
        'taskDayClassification': newtodo.taskDayClassification,
        'repeatTaskDays': newtodo.repeatTaskDays,
        'isChecked': newtodo.isChecked ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [oldtodo.id],
    );
  }
}
