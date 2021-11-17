import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/dto/todo_dto.dart';

const String tableTodo = 'Todo';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDueTime = 'dueTime';
const String columnDone = 'isDone';

class TodoDAO {
  Database? database;
  final databaseName = 'todo.db';
  Future open(String databaseName) async {
    database = await openDatabase(
      join(
        await getDatabasesPath(),
        databaseName,
      ),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE IF NOT EXISTS Todo ( id text PRIMARY KEY, title text, dueTime text, isDone integer )',
        );
      },
    );
  }

  Future insertTodo(TodoDTO todo) async {
    await open(databaseName);
    await database?.insert(
      'Todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    await close();
  }

//   Future<List<TodoDTO>> getAllDoneTodo() async {
//     await open(databaseName);
//     final List<Map<String, dynamic>>? maps = await database?.query(tableTodo,
//         where:
//             'DATE($columnDueTime) <= DATE("now","localtime") and $columnDone = ?',
//         whereArgs: [1]);
//     await close();

//     return List.generate(
//         maps!.length,
//         (index) => TodoDTO(
//             id: maps[index][columnId],
//             title: maps[index][columnTitle],
//             dueTime: DateTime.parse(maps[index][columnDueTime]),
//             isDone: maps[index][columnDone]));
//   }

//   Future<List<TodoDTO>> getUpcomingTodo() async {
//     await open(databaseName);
//     final List<Map<String, dynamic>>? maps = await database?.query(
//       tableTodo,
//       where: 'DATE($columnDueTime) > DATE("now","localtime") ',
//     );
//     await close();

//     return List.generate(
//         maps!.length,
//         (index) => TodoDTO(
//             id: maps[index][columnId],
//             title: maps[index][columnTitle],
//             dueTime: DateTime.parse(maps[index][columnDueTime]),
//             isDone: maps[index][columnDone]));
//   }

//   Future<List<TodoDTO>> getTodayTodo() async {
//     await open(databaseName);
//     final List<Map<String, dynamic>>? maps = await database?.query(tableTodo,
//         where:
//             'DATE($columnDueTime) = DATE("now","localtime") and $columnDone = ?',
//         whereArgs: [0]);
//     await close();

//     return List.generate(
//         maps!.length,
//         (index) => TodoDTO(
//             id: maps[index][columnId],
//             title: maps[index][columnTitle],
//             dueTime: DateTime.parse(maps[index][columnDueTime]),
//             isDone: maps[index][columnDone]));
//   }
  Future<List<TodoDTO>> getTodo() async {
    await open(databaseName);
    final List<Map<String, dynamic>>? maps = await database?.query(tableTodo);
    await close();

    return List.generate(
        maps!.length,
        (index) => TodoDTO(
            id: maps[index][columnId],
            title: maps[index][columnTitle],
            dueTime: DateTime.parse(maps[index][columnDueTime]),
            isDone: maps[index][columnDone]));
  }

  Future markAsDone(String id) async {
    await open(databaseName);
    await database?.rawUpdate(
        'UPDATE $tableTodo SET $columnDone = ? WHERE $columnId = ?', [1, id]);
    await close();
  }

  Future close() async => database?.close();
}
