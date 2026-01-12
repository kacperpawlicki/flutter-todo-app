import 'package:flutter/material.dart';

class TodoListItem {
  final int id;
  final String title;
  final String? description;
  final int? priority;
  final bool isChecked;

  TodoListItem({
    required this.id,
    required this.title,
    this.description,
    this.priority,
    this.isChecked = false,
  });

  TodoListItem copyWith({bool? isChecked}) {
    return TodoListItem(
      id: id,
      title: title,
      description: description,
      priority: priority,
      isChecked: isChecked ?? this.isChecked,
    );
  }

  TodoPriority? get priorityEnum {
    switch (priority) {
      case 1:
        return TodoPriority.low;
      case 2:
        return TodoPriority.medium;
      case 3:
        return TodoPriority.high;
      default:
        return null;
    }
  }
}

enum TodoPriority {
  low(1, 'Low', Colors.green),
  medium(2, 'Medium', Colors.orange),
  high(3, 'High', Colors.red);

  final int value;
  final String label;
  final Color color;

  const TodoPriority(this.value, this.label, this.color);
}