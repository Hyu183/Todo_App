import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/service/notification.dart';

class UndoneTodoItem extends StatefulWidget {
  final int id;
  final String title;

  final DateTime time;
  final Function(int) markTodoHandler;
  final bool seeDetailDate;
  const UndoneTodoItem({
    Key? key,
    required this.title,
    required this.time,
    required this.id,
    required this.markTodoHandler,
    required this.seeDetailDate,
  }) : super(key: key);

  @override
  State<UndoneTodoItem> createState() => _UndoneTodoItemState();
}

class _UndoneTodoItemState extends State<UndoneTodoItem> {
  var isChecked = false;
  bool _checkIsDue() {
    if (widget.time.isBefore(DateTime.now())) return true;
    return false;
  }

  void _onTapHandler() async {
    setState(() {
      isChecked = true;
    });
    await widget.markTodoHandler(widget.id);
    await NotificationService.notifications.cancel(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(50),
            onTap: () => _onTapHandler(),
            child: isChecked
                ? const Icon(
                    Icons.task_alt,
                  )
                : const Icon(
                    Icons.circle_outlined,
                    color: Colors.grey,
                  ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 18)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.calendar_today,
                        color: _checkIsDue()
                            ? Theme.of(context).primaryColor
                            : Colors.green,
                        size: 15),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.seeDetailDate
                          ? DateFormat('MMM dd yyyy HH:mm').format(widget.time)
                          : DateFormat('HH:mm').format(widget.time),
                      style: TextStyle(
                        color: _checkIsDue()
                            ? Theme.of(context).primaryColor
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: 2,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
