import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todo_app/dto/todo_dto.dart';

import 'package:todo_app/widgets/datetime_badge.dart';

class AddTodo extends StatefulWidget {
  final Function(TodoDTO) addTodoHandler;

  const AddTodo({Key? key, required this.addTodoHandler}) : super(key: key);

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  String _datePicked = '';
  String _title = '';
  final titleController = TextEditingController();
  bool _isValid = false;

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
      _isValid = _checkValidTodo();
    });
  }

  bool _checkValidTodo() {
    return _datePicked.isNotEmpty && _title.trim().isNotEmpty;
  }

  void _addTodoHandler() async {
    var choosenDate = DateFormat('MMM dd yyyy HH:mm').parse(_datePicked);

    final todoItem = TodoDTO(
        id: DateTime.now().toIso8601String(),
        title: _title,
        dueTime: choosenDate,
        isDone: 0);

    widget.addTodoHandler(todoItem);

    setState(() {
      _datePicked = '';
      _title = '';
      titleController.text = _title;
      _isValid = _checkValidTodo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(
              hintText: 'e.g. Family lunch on Sunday at noon',
            ),
            controller: titleController,
            onChanged: (value) {
              setState(() {
                _title = value;
                _isValid = _checkValidTodo();
              });
            },
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
                      color: _isValid
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(50)),
                  child: InkWell(
                    onTap: _isValid ? () => _addTodoHandler() : null,
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
