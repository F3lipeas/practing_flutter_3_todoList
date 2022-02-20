import 'package:flutter/material.dart';
import 'package:praticando_udemy_todolist/models/todo.dart';
import 'package:praticando_udemy_todolist/widgets/todo_list_item.dart';

import '../repositories/todo_repository.dart';
import 'checked_list_page.dart';

class TodoListHome extends StatefulWidget {
  TodoListHome({Key? key}) : super(key: key);

  @override
  State<TodoListHome> createState() => _TodoListHomeState();
}

class _TodoListHomeState extends State<TodoListHome> {
  final TextEditingController todoController = TextEditingController();
  final TodoRepository todoRepository = TodoRepository();


  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;
  Todo? checkedTodo;
  int? checkedTodoPos;

  String? errorText;

  @override
  void initState() {
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: todoController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Adicione uma Tarefa",
                            errorText: errorText,
                            focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                              color: Colors.green,
                              width: 2,
                            )),
                            labelStyle: const TextStyle(
                              color: Colors.green,
                            )),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                        padding: const EdgeInsets.all(13),
                      ),
                      onPressed: () {
                        String text = todoController.text;

                        if (text.isEmpty) {
                          setState(() {
                            errorText = "O texto não pode ser vazio";
                          });
                          return;
                        }

                        setState(() {
                          Todo newTodo = Todo(
                            title: text,
                            dateTime: DateTime.now(),
                          );
                          todos.add(newTodo);
                          errorText = null;
                        });
                        todoController.clear();
                        todoRepository.saveTodoList(todos);
                      },
                      child: const Icon(Icons.add_circle_outline, size: 30),
                    )
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                            "Você possui ${todos.length} tarefas pendentes")),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(13),
                      ),
                      onPressed: showTodoConfirmationDialog,
                      child: const Text("Limpar Tudo"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onDelete(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    todoRepository.saveTodoList(todos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        "Tarefa ${todo.title} foi removida com sucesso!",
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.white,
      action: SnackBarAction(
        label: "Desfazer",
        onPressed: () {
          setState(() {
            todos.insert(deletedTodoPos!, deletedTodo!);
          });
          todoRepository.saveTodoList(todos);
        },
        textColor: Colors.green,
      ),
      duration: const Duration(seconds: 3),
    ));
  }

  void showTodoConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Limpar Tudo?"),
        content: Text("Você tem certeza que deseja apagar todas as tarefas?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(primary: Colors.green),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancelar"),
          ),
          TextButton(
            style: TextButton.styleFrom(primary: Colors.green),
            onPressed: () {
              Navigator.of(context).pop();
              deleteAllTodos();
            },
            child: Text("Confirmar"),
          ),
        ],
      ),
    );
  }

  void deleteAllTodos() {
    setState(() {
      todos.clear();
    });
    todoRepository.saveTodoList(todos);
  }
}

