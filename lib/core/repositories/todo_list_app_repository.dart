import 'package:todo_list_las/core/api/todo_list_database.dart';
import 'package:todo_list_las/core/models/todo_list_app_model.dart';

class TodoListAppRepository {
  final TodoListDatabase db;

  TodoListAppRepository({
    required this.db,
  });

  Future<List<TodoListAppModel>> getNotes() async {
    List<TodoListAppModel> notes = await db.getAll();
    return notes;
  }

  Future<void> saveNotes(String description) async {
    TodoListAppModel note = TodoListAppModel(description: description);
    await db.save(note);
  }

  Future<void> updateNote(TodoListAppModel note) async {
    await db.update(note);
  }

  Future<void> removeNote(int id) async {
    await db.delete(id);
  }

  Future<void> removeNotes() async {
    await db.deleteAll();
  }
}
