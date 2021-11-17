import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback onTapHandler;
  final int count;

  const CategoryTile({
    Key? key,
    required this.title,
    required this.iconData,
    required this.onTapHandler,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      splashColor: Theme.of(context).primaryColor.withOpacity(0.8),
      onTap: onTapHandler,
      child: ListTile(
        leading: Icon(iconData),
        title: Text(title),
        trailing: Text(
          '$count',
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
