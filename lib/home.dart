import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/todo.dart';
import 'search_bar.dart';
import 'todo_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Todo> todos = [];
  List<Todo> filteredTodos = [];

  Priority _selectedPriority = Priority.low;
  final _formGlobalKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';

  void saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final todoJsonList =
        todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('todos', todoJsonList);
  }

  void loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoJsonList = prefs.getStringList('todos') ?? [];
    final loadedTodos = todoJsonList
        .map((jsonStr) => Todo.fromJson(jsonDecode(jsonStr)))
        .toList();

    setState(() {
      todos.clear();
      todos.addAll(loadedTodos);
      filteredTodos = List.from(todos);
    });
  }

  @override
  void initState() {
    loadTodos();
    super.initState();
  }

  void searchChanged(String query) {
    final filtered = todos.where((todo) {
      final lowerQuery = query.toLowerCase();
      return todo.title.toLowerCase().contains(lowerQuery);
    }).toList();
    setState(() {
      filteredTodos = filtered;
    });
  }

  void sortByPriority() {
    setState(() {
      filteredTodos.sort((a, b) => a.priority.index.compareTo(b.priority.index));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List',style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 32, 42, 64),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            SearchBars(
              onChanged: searchChanged,
              onSortPressed: sortByPriority,
            ),
            const SizedBox(height: 5),
            Expanded(
              child: TodoList(
                todos: filteredTodos,
                onDismiss: (index) {
                  final removedTodo = filteredTodos[index];
                  setState(() {
                    todos.remove(removedTodo);
                    filteredTodos.removeAt(index);
                  });
                  saveTodos(todos);
                },
              ),
            ),
            Form(
              key: _formGlobalKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    maxLength: 20,
                    decoration: const InputDecoration(
                      label: Text('Todo title'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Type something bud';
                      }
                      return null;
                    },
                    onSaved: (value) => _title = value!,
                  ),
                  TextFormField(
                    maxLength: 40,
                    decoration: const InputDecoration(
                      label: Text('Description'),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value.length < 5) {
                        return 'Type a description at least 5 letters';
                      }
                      return null;
                    },
                    onSaved: (value) => _description = value!,
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField(
                    value: _selectedPriority,
                    decoration: const InputDecoration(
                      label: Text('Priority'),
                    ),
                    items: Priority.values.map((p) {
                      return DropdownMenuItem(
                        value: p,
                        child: Text(p.title),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 5),
                  FilledButton(
                    onPressed: () {
                      if (_formGlobalKey.currentState!.validate()) {
                        _formGlobalKey.currentState!.save();
                        setState(() {
                          todos.add(Todo(
                            title: _title,
                            description: _description,
                            priority: _selectedPriority,
                          ));
                        });
                        saveTodos(todos);
                        _formGlobalKey.currentState!.reset();
                        _selectedPriority = Priority.low;
                        loadTodos();
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
