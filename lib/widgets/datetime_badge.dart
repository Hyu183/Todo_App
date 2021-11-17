import 'package:flutter/material.dart';

class DatetimeBadge extends StatelessWidget {
  final String datetime;
  const DatetimeBadge({
    Key? key,
    required this.datetime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6DAD7),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Text(datetime, style: const TextStyle(fontSize: 16)),
    );
  }
}
