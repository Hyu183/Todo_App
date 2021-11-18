import 'package:flutter/material.dart';
import 'package:todo_app/dto/todo_dto.dart';
import 'package:todo_app/pages/search.dart';
import 'package:todo_app/widgets/add_todo.dart';
import 'package:todo_app/widgets/empty_list.dart';
import 'package:todo_app/widgets/upcoming_todo_item.dart';

class UpcomingList extends StatelessWidget {
  static const routeName = '/upcoming';
  final List<TodoDTO> upcomingTodoList;
  final Function(TodoDTO) addTodoHandler;
  final Function(String) markTodoHandler;
  const UpcomingList(
      {Key? key,
      required this.upcomingTodoList,
      required this.addTodoHandler,
      required this.markTodoHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Upcoming'),
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
        ],
      ),
      body: upcomingTodoList.isEmpty
          ? const EmptyList()
          : SingleChildScrollView(
              child: Column(
                children: upcomingTodoList
                    .map((todo) => UpcomingTodoItem(
                        title: todo.title,
                        time: todo.dueTime,
                        id: todo.id,
                        markTodoHandler: markTodoHandler))
                    .toList(),
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
              child: AddTodo(addTodoHandler: addTodoHandler),
            );
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
