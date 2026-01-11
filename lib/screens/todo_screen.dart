import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/models/todo_list_item.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TodoListItem> todos = [
    TodoListItem(id: "1", title: "Fold the laundry"),
    TodoListItem(id: "2", title: "Clean the room"),
    TodoListItem(id: "3", title: "Do the dishes"),
    TodoListItem(id: "4", title: "Buy groceries", description: "Milk, bread", priority: TodoPriority.medium),
    TodoListItem(id: "5", title: "Pay electricity bill", priority: TodoPriority.high),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12.0),
            color: const Color.fromARGB(255, 66, 73, 77),
            child: InkWell(
              onTap: () {
                setState(() {
                  todos[index] = todo.copyWith(isChecked: !todo.isChecked);
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            todo.title,
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Checkbox(
                          activeColor: Colors.blueAccent,
                          checkColor: Colors.white,
                          value: todo.isChecked,
                          onChanged: (value) {
                            setState(() {
                              todos[index] = todo.copyWith(
                                isChecked: value ?? false,
                              );
                            });
                          },
                        ),
                      ],
                    ),

                    if (todo.description != null || todo.priority != null) ...[
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (todo.description != null &&
                              todo.description!.isNotEmpty)
                            Expanded(
                              child: Text(
                                todo.description!,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),

                          if (todo.priority != null)
                            Padding(
                              padding: EdgeInsetsGeometry.symmetric(
                                horizontal: 12,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: todo.priority!.color,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  todo.priority!.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
