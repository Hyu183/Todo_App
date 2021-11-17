import 'package:flutter/material.dart';
import 'package:todo_app/dao/todo_dao.dart';
import 'package:todo_app/dto/todo_dto.dart';

class TodoProvider extends ChangeNotifier {
  List<TodoDTO> todoList = [];

  void setTodoList(List<TodoDTO> source) {
    todoList = [...source];
  }

  List<TodoDTO> get getTodoList {
    return [...todoList];
  }

  List<TodoDTO> get getTodayList {
    return todoList
        .where((todo) =>
            todo.dueTime.day == DateTime.now().day && todo.isDone == 0)
        .toList();
  }

  List<TodoDTO> get getUpcomingList {
    return todoList
        .where((todo) => todo.dueTime.day > DateTime.now().day)
        .toList();
  }

  Future addTodo(TodoDTO todo) async {
    todoList.add(todo);
    final todoDAO = TodoDAO();
    await todoDAO.insertTodo(todo);
    notifyListeners();
  }

  int get countTodayTodo {
    return todoList
        .where((todo) =>
            todo.dueTime.day == DateTime.now().day && todo.isDone == 0)
        .length;
  }

  int get countUpcomingTodo {
    return todoList
        .where((todo) => todo.dueTime.day > DateTime.now().day)
        .length;
  }

  int get countAllTodo {
    return todoList.length;
  }

  Future markAsDone(String id) async {
    int oldTodoIndex = todoList.indexWhere((todo) => todo.id == id);
    todoList[oldTodoIndex] = TodoDTO(
        id: todoList[oldTodoIndex].id,
        title: todoList[oldTodoIndex].title,
        dueTime: todoList[oldTodoIndex].dueTime,
        isDone: 1);
    final todoDAO = TodoDAO();
    await todoDAO.markAsDone(id);
    notifyListeners();
  }
}
