import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todo_app/dto/todo_dto.dart';
import 'package:todo_app/widgets/done_todo_item.dart';
import 'package:todo_app/widgets/undone_todo_item.dart';
import 'package:woozy_search/woozy_search.dart';

class Search extends StatefulWidget {
  static const routeName = '/search';
  final List<TodoDTO> todoList;
  final Function(int) markTodoHandler;
  const Search(
      {Key? key, required this.todoList, required this.markTodoHandler})
      : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<TodoDTO> searchResult = [];
  final woozy = Woozy(limit: 50);
  @override
  void initState() {
    super.initState();
    for (var todo in widget.todoList) {
      woozy.addEntry(todo.title, value: todo);
    }
  }

  void searchHandler(String query) {
    var res = woozy.search(query).where((element) => element.score >= 0.25);
    setState(() {
      searchResult = res.map((r) => r.value as TodoDTO).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: CupertinoSearchTextField(
          backgroundColor: Colors.white,
          onChanged: (value) {
            searchHandler(value);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              color: Colors.black12,
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Tasks',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
            searchResult.isNotEmpty
                ? Column(
                    children: searchResult.map((todo) {
                      if (todo.isDone == 0) {
                        return UndoneTodoItem(
                          key: ValueKey(todo.id),
                          id: todo.id,
                          title: todo.title,
                          time: todo.dueTime,
                          markTodoHandler: widget.markTodoHandler,
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
                  )
                : const Padding(
                    padding: EdgeInsets.all(50),
                    child: Text('No task found'),
                  ),
          ],
        ),
      ),
    );
  }
}
