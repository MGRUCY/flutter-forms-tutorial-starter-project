import 'package:flutter/material.dart';
import 'package:flutter_forms_files/models/todo.dart';
import 'package:flutter_forms_files/todo_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Todo> todos = [
    const Todo(
        title: 'study flutter',
        description: 'something big is waiting for you',
        priority: Priority.urgent),
    const Todo(
        title: 'brush teath',
        description: 'you look handsome, lets look clean too',
        priority: Priority.high),
    const Todo(
        title: 'walk',
        description: 'breath some fresh air',
        priority: Priority.low),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        centerTitle: true,
        backgroundColor: Colors.grey[200],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(child: TodoList(todos: todos)),

            // form stuff below here
          ],
        ),
      ),
    );
  }
}
