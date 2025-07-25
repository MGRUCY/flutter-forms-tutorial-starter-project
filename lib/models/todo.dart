
import 'package:flutter/material.dart';


enum Priority {
  urgent(color: Colors.red, title: 'Urgent'),
  high(color: Colors.orange, title: 'High'),
  medium(color: Colors.amber, title: 'Medium'),
  low(color: Colors.green, title: 'Low');

  const Priority({ required this.color, required this.title });
  final Color color;
  final String title;
}

class Todo {
  const Todo({ required this.title, required this.description, required this.priority });

  final String title;
  final String description;
  final Priority priority;

Map<String, dynamic> toJson() => {
  'title': title,
  'description': description,
  'priority': priority.name,
};

factory Todo.fromJson(Map<String, dynamic> json) {
  return Todo(
    title: json['title'],
    description: json['description'],
    priority: Priority.values.firstWhere((e) => e.name == json['priority']),
  );
}

}
