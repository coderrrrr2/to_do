import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/models/to_do.dart';

class SqfLiteService {
  Future<Database> initializeDataBase() async {
    final dbPath = await sql.getDatabasesPath();
    return await sql.openDatabase(path.join(dbPath, 'TodstoDb'),
        onCreate: (dbInstance, version) async {
      dbInstance.execute(
        "CREATE TABLE user_todos (id TEXT PRIMARY KEY, taskName TEXT, time TEXT, date TEXT, taskDayClassification TEXT, repeatTaskDays TEXT, isChecked INTEGER)",
      );
    }, version: 1);
  }

  void insertIntoDatabase(ToDo todo) async {
    final db = await initializeDataBase();
    db.insert('user_todos', {
      'id': todo.id,
      'taskName': todo.taskName,
      'time': todo.time.toString(),
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
}
