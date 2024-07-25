import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_las/core/models/todo_list_app_model.dart';

class TodoListDatabase {
  static final TodoListDatabase instance = TodoListDatabase._init();

  static Database? _database;

  TodoListDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  // inicializar o banco de dados
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    // await deleteDatabase(
    //     path); // limpar a base de dados na hora que iniciar o app
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  // criar banco de dados
  Future _createDb(Database db, int version) async {
    await db.execute('''
     CREATE TABLE notes (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      description TEXT NOT NULL
     )
     ''');
  }

  // criar os 4 metodos do CRUD

  // recuperar notas
  Future<List<TodoListAppModel>> getAll() async {
    final database = await instance.database;
    final result = await database.rawQuery('SELECT * FROM notes ORDER BY id');
    return result.map((json) => TodoListAppModel.fromJson(json)).toList();
  }

  // salvar notas
  Future<TodoListAppModel> save(TodoListAppModel note) async {
    final database = await instance.database;
    final id = await database.rawInsert(
      'INSERT INTO notes (description) VALUES (?)',
      [note.description],
    );
    return note.copyWith(id: id);
  }

  // atualizar notas
  Future<TodoListAppModel> update(TodoListAppModel note) async {
    final database = await instance.database;
    final id = await database.rawUpdate(
      'UPDATE notes SET description = ? WHERE id = ?',
      [note.description, note.id],
    );
    return note.copyWith(id: id);
  }

  // excluir nota
  Future<int> delete(int noteId) async {
    final database = await instance.database;
    final id = await database.rawDelete(
      'DELETE FROM notes WHERE id = ?',
      [noteId],
    );

    return id;
  }

  // excluir notas
  Future<void> deleteAll() async {
    final database = await instance.database;
    await database.rawDelete(
      'DELETE FROM notes',
    );
  }

  // fechar conexao com banco de dados
  // esse metodo é para fins didáticos, porque dificilmente vc vai querer fechar conexao com o banco de dados
  // enquanto o app estiver aberto.
  Future close() async {
    final database = await instance.database;
    database.close();
  }
}
