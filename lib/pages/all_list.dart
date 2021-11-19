import 'package:flutter/material.dart';
import 'package:todo_app/dto/todo_dto.dart';
import 'package:todo_app/pages/search.dart';
import 'package:todo_app/widgets/add_todo.dart';
import 'package:todo_app/widgets/done_todo_item.dart';
import 'package:todo_app/widgets/empty_list.dart';
import 'package:todo_app/widgets/undone_todo_item.dart';

class AllList extends StatelessWidget {
  static const routeName = '/all';
  final List<TodoDTO> allTodoList;
  final Function(TodoDTO) addTodoHandler;
  final Function(int) markTodoHandler;
  final VoidCallback clearAllTodoHandler;
  const AllList(
      {Key? key,
      required this.allTodoList,
      required this.markTodoHandler,
      required this.addTodoHandler,
      required this.clearAllTodoHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('All'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(Search.routeName);
            },
            icon: const Icon(
              Icons.search_rounded,
            ),
          ),
          PopupMenuButton(
              itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: const Text('Clear All'),
                      onTap: clearAllTodoHandler,
                    )
                  ]),
        ],
      ),
      body: allTodoList.isEmpty
          ? const EmptyList()
          : SingleChildScrollView(
              child: Column(
                children: allTodoList.map((todo) {
                  if (todo.isDone == 0) {
                    return UndoneTodoItem(
                      key: ValueKey(todo.id),
                      id: todo.id,
                      title: todo.title,
                      time: todo.dueTime,
                      markTodoHandler: markTodoHandler,
                      seeDetailDate: true,
                    );
                  } else {
                    return DoneTodoItem(
                      key: ValueKey(todo.id),
                      id: todo.id,
                      title: todo.title,
                      time: todo.dueTime,
                    );
                  }
                }).toList(),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        onPressed: () => showModalBottomSheet(
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
              child: AddTodo(
                addTodoHandler: addTodoHandler,
                countAll: allTodoList.length,
              ),
            );
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
