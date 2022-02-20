import 'package:flutter/material.dart';
import 'package:praticando_udemy_todolist/pages/checked_list_page.dart';
import 'package:praticando_udemy_todolist/pages/todo_list_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/TodoListHome",
      routes: {
        "/TodoListHome": (context)=> TodoListHome(),
        "/CheckedTodoList": (context) => CheckedTodoList(),
      },
    );
  }
}
