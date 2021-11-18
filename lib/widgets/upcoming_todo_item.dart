import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpcomingTodoItem extends StatefulWidget {
  final String id;
  final String title;

  final DateTime time;
  final Function(String) markTodoHandler;
  const UpcomingTodoItem({
    Key? key,
    required this.title,
    required this.time,
    required this.id,
    required this.markTodoHandler,
  }) : super(key: key);

  @override
  State<UpcomingTodoItem> createState() => _UpcomingTodoItemState();
}

class _UpcomingTodoItemState extends State<UpcomingTodoItem> {
  var isChecked = false;

  void _onTapHandler() {
    setState(() {
      isChecked = true;
    });

    widget.markTodoHandler(widget.id);
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
                    const Icon(Icons.calendar_today,
                        color: Colors.green, size: 15),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      DateFormat('MMM dd yyyy HH:mm').format(widget.time),
                      style: const TextStyle(
                        color: Colors.green,
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
