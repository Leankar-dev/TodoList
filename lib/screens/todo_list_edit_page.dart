import 'package:flutter/material.dart';
import 'package:todo_list_las/core/controllers/todo_list_app_controller.dart';
import 'package:todo_list_las/core/models/todo_list_app_model.dart';
import 'package:todo_list_las/helpers/show_loading_dialog.dart';

class TodoListEditPage extends StatefulWidget {
  final TodoListAppModel? note;
  final TodoListAppController controller;

  const TodoListEditPage({
    super.key,
    required this.note,
    required this.controller,
  });

  @override
  State<TodoListEditPage> createState() => _TodoListEditPageState();
}

class _TodoListEditPageState extends State<TodoListEditPage> {
  final formKey = GlobalKey<FormState>();
  // final tEC = TextEditingController();
  final noteFieldController = TextEditingController();

  Future<void> insertNote(String description) async {
    FocusScope.of(context)
        .unfocus(); // faz o teclado sumir quando clica no botão salvar
    showLoadingDialog(context);
    await widget.controller.saveNotes(description).then((value) {
      Navigator.pop(context);
      const snackBar = SnackBar(
        content: Text('Nota incluida com sucesso.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context, true);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      SnackBar snackBar = SnackBar(
        content: Text(error.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future<void> updateNote(TodoListAppModel note) async {
    FocusScope.of(context)
        .unfocus(); // faz o teclado sumir quando clica no botão salvar
    showLoadingDialog(context);
    await widget.controller.updateNote(note).then((value) {
      Navigator.pop(context);
      const snackBar = SnackBar(
        content: Text('Nota atualizada com sucesso.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pop(context, true);
    }).onError((error, stackTrace) {
      Navigator.pop(context);
      SnackBar snackBar = SnackBar(
        content: Text(error.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  void initState() {
    super.initState();
    noteFieldController.text = widget.note?.description ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        // o titulo vai depender da tela (edição ou inclusão)
        title: Center(
          child: widget.note == null
              ? const Text('Inserir Nota!!')
              : const Text(
                  'Atualizar Nota.',
                ),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextFormField(
                controller: noteFieldController,
                validator: ((value) => (value == null || value.isEmpty)
                    ? 'Campo obrigatório!!'
                    : null),
                onFieldSubmitted: (_) async {
                  if (formKey.currentState!.validate()) {
                    widget.note == null
                        ? await insertNote(noteFieldController.text)
                        : await updateNote(
                            TodoListAppModel(
                                id: widget.note!.id,
                                description: noteFieldController.text),
                          );
                  }
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      widget.note == null
                          ? await insertNote(noteFieldController.text)
                          : await updateNote(
                              TodoListAppModel(
                                  id: widget.note!.id,
                                  description: noteFieldController.text),
                            );
                    }
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
