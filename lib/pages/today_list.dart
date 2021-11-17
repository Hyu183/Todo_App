import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/dto/todo_dto.dart';
import 'package:todo_app/provider/todo_provider.dart';
import 'package:todo_app/widgets/add_todo.dart';
import 'package:todo_app/widgets/header_time.dart';
import 'package:todo_app/widgets/undone_todo_item.dart';

class TodayList extends StatelessWidget {
  static const routeName = '/today';
  const TodayList({Key? key}) : super(key: key);

  void _showModalAdd(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      )),
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: AddTodo(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<TodoDTO> todayList =
        Provider.of<TodoProvider>(context).getTodayList;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Today'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search_rounded,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_horiz_rounded,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderTime(
              datetime: DateTime.now(),
            ),
            Column(
              children: todayList
                  .map((todo) => UndoneTodoItem(
                      key: ValueKey(todo.id),
                      id: todo.id,
                      title: todo.title,
                      time: todo.dueTime))
                  .toList(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => _showModalAdd(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
