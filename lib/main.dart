import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/config/palette.dart';
import 'package:todo_app/dao/todo_dao.dart';
import 'package:todo_app/dto/todo_dto.dart';

import 'package:todo_app/pages/homepage.dart';
import 'package:todo_app/pages/today_list.dart';
import 'package:todo_app/provider/todo_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: MaterialApp(
        title: 'Todo',
        theme: ThemeData(
          primarySwatch: Palette.myColor,
          // primaryColor: Colors.blue,
        ),
        home: const Homepage(),
        routes: {
          TodayList.routeName: (ctx) => const TodayList(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// 1 Cho người dùng tạo TODO có chọn thời gian TODO
// 2 Trang chính cho chọn xem TODO theo All/Today/Upcoming
// 3 Hiển thị danh sách TODO theo từng loại All/Today/Upcoming
// 4 Search TODO list
// 5 Thông báo notification trước khi TODO list xảy ra 10 phút (Sử dụng https://pub.dev/packages/flutter_local_notifications)
// 6 Đánh dầu 1 TODO đã xong và remove khỏi danh sách TODO
// Yêu cầu sử dụng Local Storage

