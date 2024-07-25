// vai conversar com o repository e com a interface (tela)

import 'package:todo_list_las/core/models/todo_list_app_model.dart';
import 'package:todo_list_las/core/repositories/todo_list_app_repository.dart';

class TodoListAppController {
  final TodoListAppRepository repository;

  TodoListAppController({
    required this.repository,
  });

  Future<List<TodoListAppModel>> getNotes() async {
    await Future.delayed(const Duration(seconds: 2));
    return await repository.getNotes();
  }

  Future<void> saveNotes(String description) async {
    await Future.delayed(const Duration(seconds: 1));
    await repository.saveNotes(description);
  }

  Future<void> updateNote(TodoListAppModel note) async {
    await Future.delayed(const Duration(seconds: 1));
    await repository.updateNote(note);
  }

  Future<void> removeNote(int id) async {
    await Future.delayed(const Duration(seconds: 1));
    await repository.removeNote(id);
  }

  Future<void> removeNotes() async {
    await Future.delayed(const Duration(seconds: 1));
    await repository.removeNotes();
  }
}
