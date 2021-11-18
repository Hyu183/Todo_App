import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DoneTodoItem extends StatelessWidget {
  final String id;
  final String title;
  final DateTime time;

  const DoneTodoItem({
    Key? key,
    required this.id,
    required this.title,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.task_alt,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        color: Colors.black38, size: 15),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      DateFormat('MMM dd yyyy HH:mm').format(time),
                      style: const TextStyle(
                        color: Colors.black38,
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
