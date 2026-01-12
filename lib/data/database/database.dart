import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_todo_app/data/models/todo_list_item.dart';

part 'database.g.dart';

@UseRowClass(TodoListItem)
class TodoItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  IntColumn get priority => integer().nullable()();
  BoolColumn get isChecked => boolean().withDefault(const Constant(false))();
}

@DriftDatabase(tables: [TodoItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<TodoListItem>> getAllTodos() => select(todoItems).get();

  Stream<List<TodoListItem>> watchAllTodos() => select(todoItems).watch();

  Future<int> addTodo({
    required String title,
    String? description,
    TodoPriority? priority,
  }) {
    return into(todoItems).insert(
      TodoItemsCompanion.insert(
        title: title,
        description: Value.absentIfNull(description),
        priority: Value.absentIfNull(priority?.value),
      ),
    );
  }

  Future<int> updateTodo(TodoListItem todo) {
    final updateStatement = update(todoItems);
    updateStatement.where((t) => t.id.equals(todo.id));

    return updateStatement.write(
      TodoItemsCompanion(
        title: Value(todo.title),
        description: Value(todo.description),
        priority: Value(todo.priority),
        isChecked: Value(todo.isChecked),
      ),
    );
  }

  Future<int> deleteTodo(int id) {
    final deleteStatement = delete(todoItems);
    deleteStatement.where((t) => t.id.equals(id));
    return deleteStatement.go();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'todos.sqlite'));
    return NativeDatabase(file);
  });
}