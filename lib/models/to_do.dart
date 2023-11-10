import 'package:uuid/uuid.dart';

Uuid uuid = const Uuid();

class ToDo {
  ToDo({required this.taskName, required this.date, String? id})
      : id = id ?? const Uuid().v4();
  final String taskName;
  final String id;
  final DateTime date;
}
