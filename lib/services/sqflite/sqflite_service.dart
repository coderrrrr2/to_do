import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/models/to_do.dart';

class SqfLiteService {
  Future<Database> initializeDataBase() async {
    final dbPath = await sql.getDatabasesPath();
    final dbInstance = await sql.openDatabase(path.join(dbPath, 'Todos.db'),
        onCreate: (dbInstance, version) {
      return dbInstance.execute(
          "CREATE TABLE user_todos (id TEXT PRIMARY KEY, taskName TEXT, hour INTEGER, minute INTEGER, date TEXT, taskDayClassification TEXT, repeatTaskDays TEXT, isChecked INTEGER)");
    }, version: 1);

    return dbInstance;
  }

  Future<List<ToDo>> loadPlaces() async {
    final db = await SqfLiteService().initializeDataBase();
    final data = await db.query('user_todos');
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
    final db = await initializeDataBase();
    db.insert('user_todos', {
      'id': todo.id,
      'taskName': todo.taskName,
      'hour': todo.time.hour, // Store hour separately
      'minute': todo.time.minute,
      'date': todo.date.toString(),
      'taskDayClassification': todo.taskDayClassification,
      'repeatTaskDays': todo.repeatTaskDays,
      'isChecked': todo.isChecked ? 1 : 0
    });
  }

  void deleteFromDataBase(ToDo todo) async {
    final db = await initializeDataBase();
    await db.delete('user_todos', where: 'id == ?', whereArgs: [todo.id]);
  }

  void updateDataBaseValue(
      {required ToDo oldtodo, required ToDo newtodo}) async {
    final db = await initializeDataBase();
    await db.update(
      'user_todos',
      {
        'taskName': newtodo.taskName,
        'hour': newtodo.time.hour, // Store hour separately
        'minute': newtodo.time.minute,
        'date': newtodo.date.toString(),
        'taskDayClassification': newtodo.taskDayClassification,
        'repeatTaskDays': newtodo.repeatTaskDays,
        'isChecked': newtodo.isChecked ? 1 : 0
      },
      where: 'id = ?', // Use a WHERE clause to specify which record to update
      whereArgs: [oldtodo.id],
    );
  }
}
