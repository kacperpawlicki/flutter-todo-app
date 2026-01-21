import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/models/todo_list_item.dart';
import 'package:flutter_todo_app/data/database/database.dart';
import 'package:drift/drift.dart' as drift;

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  late AppDatabase database;

  @override
  void initState() {
    super.initState();
    database = AppDatabase.instance;
  }

  @override
  void dispose() {
    database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: StreamBuilder<List<TodoListItem>>(
        stream: database.watchActiveTodos(),
        builder: (context, activeSnapshot) {
          return StreamBuilder<List<TodoListItem>>(
            stream: database.watchCompletedTodos(),
            builder: (context, completedSnapshot) {
              if (!activeSnapshot.hasData || !completedSnapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final activeTodos = activeSnapshot.data!;
              final completedTodos = completedSnapshot.data!;

              if (activeTodos.isEmpty && completedTodos.isEmpty) {
                return const Center(
                  child: Text('No todos yet. Add one!'),
                );
              }

              return ListView(
                children: [

                  ...activeTodos.map((todo) => _buildTodoCard(todo, false)),

                  if (completedTodos.isNotEmpty) ...[
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      child: Divider(),
                    ),

                    ...completedTodos.map((todo) => _buildTodoCard(todo, true)),
                  ],
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTodoCard(TodoListItem todo, bool isCompleted) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      color: isCompleted
          ? const Color.fromARGB(255, 66, 73, 77).withOpacity(0.5)
          : const Color.fromARGB(255, 66, 73, 77),
      child: InkWell(
        onTap: () async {
          final updated = todo.copyWith(isChecked: !todo.isChecked);
          await database.updateTodo(updated);
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
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        decoration: isCompleted
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                  ),
                  Checkbox(
                    activeColor: Colors.blueAccent,
                    checkColor: Colors.white,
                    value: todo.isChecked,
                    onChanged: (value) async {
                      final updated = todo.copyWith(
                        isChecked: value ?? false,
                      );
                      await database.updateTodo(updated);
                    },
                  ),
                ],
              ),
              if (todo.description != null || todo.priorityEnum != null) ...[
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
                    if (todo.priorityEnum != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: todo.priorityEnum!.color,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            todo.priorityEnum!.label,
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
  }
}