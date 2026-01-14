import 'package:flutter/material.dart';
import 'package:flutter_todo_app/data/models/todo_list_item.dart';

import '../data/database/database.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  late AppDatabase database;

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  TodoPriority? _priority;

  @override
  void initState() {
    super.initState();
    database = AppDatabase.instance;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<bool> _saveTodo() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Title is required')),
        );
      }
      return false;
    }

    await database.addTodo(
      title: title,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      priority: _priority,
    );

    return true;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new todo'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text(
                      'Priority',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<TodoPriority>(
                        segments: const [
                          ButtonSegment(
                            value: TodoPriority.low,
                            label: Text('Low'),
                          ),
                          ButtonSegment(
                            value: TodoPriority.medium,
                            label: Text('Medium'),
                          ),
                          ButtonSegment(
                            value: TodoPriority.high,
                            label: Text('High'),
                          ),
                        ],
                        selected:
                        _priority == null ? {} : {_priority!},
                        onSelectionChanged: (value) {
                          setState(() {
                            _priority =
                            value.isEmpty ? null : value.first;
                          });
                        },
                        emptySelectionAllowed: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () async {
                    final navigator = Navigator.of(context);

                    final success = await _saveTodo();

                    if (!mounted || !success) return;
                    navigator.pop();
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
