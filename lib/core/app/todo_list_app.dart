import 'package:flutter/material.dart';
import 'package:todo_list_las/core/controllers/todo_list_app_controller.dart';
import 'package:todo_list_las/screens/home_page.dart';

class TodoListApp extends StatelessWidget {
  final TodoListAppController controller;
  const TodoListApp({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List - LAS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(controller: controller),
    );
  }
}
