import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/dto/todo_dto.dart';
import 'package:todo_app/provider/todo_provider.dart';
import 'package:todo_app/widgets/datetime_badge.dart';
import 'package:intl/intl.dart';

class AddTodo extends StatefulWidget {
  const AddTodo({Key? key}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  String _datePicked = '';
  final _titleController = TextEditingController();

  Future _startDatePicker(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    return selectedDate;
  }

  Future _startTimePicker(BuildContext context, DateTime selectedDate) async {
    final selectedTime =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (selectedTime == null) return;
    var timeString = selectedTime.hour.toString().padLeft(2, '0') +
        ':' +
        selectedTime.minute.toString().padLeft(2, '0');

    setState(() {
      _datePicked =
          DateFormat('MMM dd yyyy').format(selectedDate) + ' ' + timeString;
    });
  }

  bool isValidTodo() {
    return _datePicked.isNotEmpty && _titleController.text.isNotEmpty;
  }

  void _addTodoHandler(TodoProvider todoProvider) async {
    var choosenDate = DateFormat('MMM dd yyyy HH:mm').parse(_datePicked);
    var title = _titleController.text;

    final todoItem = TodoDTO(
        id: DateTime.now().toIso8601String(),
        title: title,
        dueTime: choosenDate,
        isDone: 0);

    await todoProvider.addTodo(todoItem);

    _titleController.text = '';
    setState(() {
      _datePicked = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            style: const TextStyle(fontSize: 18),
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'e.g. Family lunch on Sunday at noon',
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          DatetimeBadge(
              datetime:
                  _datePicked.isNotEmpty ? _datePicked : 'No date picked'),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey)),
                child: InkWell(
                  onTap: () {
                    _startDatePicker(context).then((selectedDate) {
                      if (selectedDate == null) return;
                      _startTimePicker(context, selectedDate);
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('Pick date',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                      color: isValidTodo()
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(50)),
                  child: InkWell(
                    onTap: isValidTodo()
                        ? () => _addTodoHandler(todoProvider)
                        : null,
                    borderRadius: BorderRadius.circular(50),
                    splashColor: Colors.grey,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                      ),
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
