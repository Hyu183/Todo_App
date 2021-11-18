import 'package:flutter/material.dart';

class CategoryTile extends StatelessWidget {
  final String iconUrl;
  final String title;
  final VoidCallback onTapHandler;
  final int count;

  const CategoryTile({
    Key? key,
    required this.title,
    required this.onTapHandler,
    required this.count,
    required this.iconUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(15),
      splashColor: Theme.of(context).primaryColor.withOpacity(0.8),
      onTap: onTapHandler,
      child: ListTile(
        leading: Image(
          image: AssetImage(iconUrl),
          height: 30,
          width: 30,
        ),
        title: Text(title),
        trailing: Text(
          '$count',
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
