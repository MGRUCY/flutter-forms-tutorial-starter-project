import 'package:flutter/material.dart';
import 'package:flutter_forms_files/models/todo.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    required this.todos,
    required this.onDismiss,
    super.key,
  });

  final List<Todo> todos;
  final void Function(int index) onDismiss;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: todos.length,
      itemBuilder: (_, index) {
        final todo = todos[index];
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Dismissible(
              key: Key(todo.title + todo.priority.name),
              direction: DismissDirection.endToStart,
              onDismissed: (_) => onDismiss(index),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: todo.priority.color.withValues(alpha: 0.6),
                ),
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(todo.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        Text(todo.description),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: todo.priority.color,
                      ),
                      child: Text(todo.priority.title),
                    ),
                  ],
                ),
              ),
            ));
      },
    );
  }
}
