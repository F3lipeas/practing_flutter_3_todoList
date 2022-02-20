import 'package:flutter/material.dart';
import 'package:praticando_udemy_todolist/models/todo.dart';

import '../widgets/todo_list_item.dart';

class CheckedTodoList extends StatefulWidget {
  const CheckedTodoList({Key? key}) : super(key: key);

  @override
  State<CheckedTodoList> createState() => _CheckedTodoListState();
}

class _CheckedTodoListState extends State<CheckedTodoList> {
  List<Todo> checked = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Tela de tarefas concluídas"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 50,
          height: 50,
          color: Colors.red,
        ),
      ),
    );
  }

}
