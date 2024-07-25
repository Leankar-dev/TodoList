import 'package:flutter/material.dart';
import 'package:todo_list_las/core/api/todo_list_database.dart';
import 'package:todo_list_las/core/app/todo_list_app.dart';
import 'package:todo_list_las/core/controllers/todo_list_app_controller.dart';
import 'package:todo_list_las/core/repositories/todo_list_app_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = TodoListAppRepository(db: TodoListDatabase.instance);
  final controller = TodoListAppController(repository: repository);
  runApp(TodoListApp(
    controller: controller,
  ));
}

