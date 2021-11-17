import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/dao/todo_dao.dart';
import 'package:todo_app/dto/todo_dto.dart';

import 'package:todo_app/pages/today_list.dart';
import 'package:todo_app/provider/todo_provider.dart';
import 'package:todo_app/widgets/add_todo.dart';
import 'package:todo_app/widgets/category_tile.dart';

class Homepage extends StatelessWidget {
  const Homepage({Key? key}) : super(key: key);

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

  Future loadData(BuildContext context) async {
    final todoDAO = TodoDAO();
    List<TodoDTO> loadedList = await todoDAO.getTodo();
    Provider.of<TodoProvider>(context, listen: false).setTodoList(loadedList);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  value: 0.9,
                  backgroundColor: Colors.grey,
                ),
              ),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
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
                      Icons.notifications_none_outlined,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.settings_outlined,
                    ),
                  )
                ],
              ),
              body: Container(
                width: double.infinity,
                color: const Color(0xfff7f2f2),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CategoryTile(
                              title: 'All',
                              iconData: Icons.access_alarm,
                              onTapHandler: () {},
                              count: Provider.of<TodoProvider>(context)
                                  .countAllTodo),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                            indent: 60,
                          ),
                          CategoryTile(
                              title: 'Today',
                              iconData: Icons.access_alarm,
                              onTapHandler: () {
                                Navigator.of(context)
                                    .pushNamed(TodayList.routeName);
                              },
                              count: Provider.of<TodoProvider>(context)
                                  .countTodayTodo),
                          const Divider(
                            color: Colors.grey,
                            thickness: 1,
                            indent: 60,
                          ),
                          CategoryTile(
                              title: 'Upcoming',
                              iconData: Icons.access_alarm,
                              onTapHandler: () {
                                print(DateTime.now()
                                    .toIso8601String()
                                    .replaceFirst('T', ' '));
                              },
                              count: Provider.of<TodoProvider>(context)
                                  .countUpcomingTodo),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              floatingActionButton: FloatingActionButton(
                heroTag: null,
                onPressed: () => _showModalAdd(context),
                child: const Icon(Icons.add),
              ),
            );
          }
          return const Scaffold();
        });
  }
}
