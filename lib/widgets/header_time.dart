import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HeaderTime extends StatelessWidget {
  final DateTime datetime;
  const HeaderTime({Key? key, required this.datetime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(width: 1, color: Colors.black38)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Text(DateFormat('MMM dd yyyy').format(datetime),
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ));
  }
}
