import 'package:flutter/material.dart';
import 'package:todo_list_las/core/controllers/todo_list_app_controller.dart';
import 'package:todo_list_las/core/enums/todo_list_app_status_enum.dart';
import 'package:todo_list_las/core/models/todo_list_app_model.dart';
import 'package:todo_list_las/helpers/show_confirmation_dialog.dart';
import 'package:todo_list_las/screens/todo_list_edit_page.dart';

class HomePage extends StatefulWidget {
  final TodoListAppController controller;
  const HomePage({
    super.key,
    required this.controller,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoListAppStatusEnum state = TodoListAppStatusEnum.loading;
  List<TodoListAppModel> notes = <TodoListAppModel>[];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    getNotes();
  }

  // função para recuperar as notas
  // chama o getNotes pelo InitState
  Future<void> getNotes() async {
    setState(() {
      state = TodoListAppStatusEnum.loading;
    });
    await widget.controller
        .getNotes()
        .then(
          (value) => setState(
            () {
              notes = value;
              state = TodoListAppStatusEnum.success;
            },
          ),
        )
        .onError(
          (error, stackTrace) => setState(() {
            errorMessage = error.toString();
            state = TodoListAppStatusEnum.failure;
          }),
        );
  }

  Future<void> removeNote(id) async {
    setState(() {
      state = TodoListAppStatusEnum.loading;
    });
    await widget.controller.removeNote(id).then((value) async {
      const snackBar = SnackBar(
        content: Text('Nota excluida com sucesso.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      await getNotes();
    }).onError((error, stackTrace) {
      setState(() {
        errorMessage = error.toString();
        state = TodoListAppStatusEnum.failure;
      });
    });
  }

  Future<void> removeNotes() async {
    if (notes.isEmpty) {
      const snackBar = SnackBar(
        content: Text('Não há notas para excluir.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      setState(() {
        state = TodoListAppStatusEnum.loading;
      });
      await widget.controller.removeNotes().then((value) async {
        const snackBar = SnackBar(
          content: Text('Notas excluídas com sucesso.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          notes = [];
          state = TodoListAppStatusEnum.success;
        });
      }).onError((error, stackTrace) {
        setState(() {
          errorMessage = error.toString();
          state = TodoListAppStatusEnum.failure;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: const Center(
          child: Text('Home Page'),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (await showConfirmationDialog(context) == true) {
                await removeNotes();
              }
              // chamar a função removeNotes para deletar todas as notas
            },
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: Builder(builder: (context) {
        switch (state) {
          case TodoListAppStatusEnum.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case TodoListAppStatusEnum.failure:
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(errorMessage),
                  ElevatedButton(
                    onPressed: () async => await getNotes(),
                    child: const Text(
                      'Atualizar',
                    ),
                  ),
                ],
              ),
            );
          case TodoListAppStatusEnum.success:
            if (notes.isEmpty) {
              return const Center(
                child: Text('Não há notas cadastradas.'),
              );
            }
            return RefreshIndicator(
              onRefresh: () async => await getNotes(),
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (BuildContext context, int index) {
                  TodoListAppModel note = notes[index];
                  // Dismissible remove o item arrastando para o lado
                  return Dismissible(
                    key: ObjectKey(note),
                    child: ListTile(
                      title: Text('${note.id} - ${note.description}'),
                      onTap: () async {
                        final bool? refresh = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TodoListEditPage(
                              note: note,
                              controller: widget.controller,
                            ),
                          ),
                        );
                        if (refresh == true) {
                          getNotes();
                        }
                      },
                    ),
                    // confirmar a exclusao do item
                    confirmDismiss: (direction) async {
                      if (await showConfirmationDialog(context) == true) {
                        await removeNote(note.id);
                        return true;
                      } else {
                        return false;
                      }
                    },
                  );
                },
              ),
            );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? refresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TodoListEditPage(
                note: null,
                controller: widget.controller,
              ),
            ),
          );
          if (refresh == true) {
            getNotes();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
