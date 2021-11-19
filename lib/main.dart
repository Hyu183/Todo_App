import 'package:flutter/material.dart';

import 'package:todo_app/config/palette.dart';
import 'package:todo_app/dao/todo_dao.dart';
import 'package:todo_app/dto/todo_dto.dart';
import 'package:todo_app/pages/all_list.dart';

import 'package:todo_app/pages/homepage.dart';
import 'package:todo_app/pages/search.dart';
import 'package:todo_app/pages/today_list.dart';
import 'package:todo_app/pages/upcoming_list.dart';
import 'package:todo_app/service/notification.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await NotificationService.resolvePlatform();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<TodoDTO> todoList = [];
  var isLoading = true;
  final todoDAO = TodoDAO();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    final todos = await todoDAO.getTodo();
    setState(() {
      todoList = [...todos];
      isLoading = false;
    });
  }

  void addTodoHandler(TodoDTO todo) async {
    setState(() {
      todoList.add(todo);
    });
    await todoDAO.insertTodo(todo);
  }

  void clearAllTodoHandler() async {
    setState(() {
      todoList = [];
    });
    await todoDAO.deleteAllTodo();
  }

  void markTodoHandler(String id) async {
    int oldTodoIndex = todoList.indexWhere((todo) => todo.id == id);
    setState(() {
      todoList[oldTodoIndex] = TodoDTO(
          id: todoList[oldTodoIndex].id,
          title: todoList[oldTodoIndex].title,
          dueTime: todoList[oldTodoIndex].dueTime,
          isDone: 1);
    });
    await todoDAO.markAsDone(id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
        primarySwatch: Palette.myColor,
      ),
      initialRoute: '/',
      routes: {
        Homepage.routeName: (ctx) {
          final countAll = todoList.length;
          final countToday = todoList
              .where((todo) =>
                  todo.dueTime.day == DateTime.now().day && todo.isDone == 0)
              .length;
          final countUpcoming = todoList
              .where((todo) =>
                  todo.dueTime.day > DateTime.now().day && todo.isDone == 0)
              .toList()
              .length;
          return Homepage(
            countAll: countAll,
            countToday: countToday,
            countUpcoming: countUpcoming,
            addTodoHandler: addTodoHandler,
            isLoading: isLoading,
          );
        },
        TodayList.routeName: (ctx) {
          final todayList = todoList
              .where((todo) =>
                  todo.dueTime.day == DateTime.now().day && todo.isDone == 0)
              .toList();
          return TodayList(
            todayTodoList: todayList,
            addTodoHandler: addTodoHandler,
            markTodoHandler: markTodoHandler,
          );
        },
        AllList.routeName: (ctx) => AllList(
              allTodoList: todoList,
              markTodoHandler: markTodoHandler,
              addTodoHandler: addTodoHandler,
              clearAllTodoHandler: clearAllTodoHandler,
            ),
        UpcomingList.routeName: (ctx) {
          final upcomingTodoList = todoList
              .where((todo) =>
                  todo.dueTime.day > DateTime.now().day && todo.isDone == 0)
              .toList();
          return UpcomingList(
              upcomingTodoList: upcomingTodoList,
              addTodoHandler: addTodoHandler,
              markTodoHandler: markTodoHandler);
        },
        Search.routeName: (ctx) {
          return Search(
            todoList: todoList,
            markTodoHandler: markTodoHandler,
          );
        },
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// 1 Cho người dùng tạo TODO có chọn thời gian TODO
// 2 Trang chính cho chọn xem TODO theo All/Today/Upcoming
// 3 Hiển thị danh sách TODO theo từng loại All/Today/Upcoming
// 4 Search TODO list
// 5 Thông báo notification trước khi TODO list xảy ra 10 phút (Sử dụng https://pub.dev/packages/flutter_local_notifications)
// 6 Đánh dầu 1 TODO đã xong và remove khỏi danh sách TODO
// Yêu cầu sử dụng Local Storage

