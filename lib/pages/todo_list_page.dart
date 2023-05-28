import 'dart:developer';

import 'package:app_tarefas/custom_widgets/todo_list_item.dart';
import 'package:app_tarefas/models/tarefas.dart';
import 'package:app_tarefas/repository/tarefa_repository.dart';
import 'package:flutter/material.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController tarefaController = TextEditingController();
  final TarefaRepository tarefaRepository = TarefaRepository();
  List<Tarefas> tarefas = [];

  @override
  void initState() {
    super.initState();
    tarefaRepository.getListaTarefas().then((value) {
      setState(() {
        tarefas = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lista de Tarefas'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: tarefaController,
                            onChanged: changedTask,
                            decoration: const InputDecoration(
                              labelText: 'Nova tarefa',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 7),
                        ElevatedButton(
                          onPressed: () {
                            addTask(tarefaController.text);
                            tarefaRepository.saveListaTarefas(tarefas);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shadowColor: Colors.redAccent,
                            elevation: 10,
                            padding: const EdgeInsets.all(10),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.white,
                          ),
                          // child: const Text('+', style: TextStyle(fontSize: 45)),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    reverse: true,
                    children: [
                      for (Tarefas tarefa in tarefas)
                        TodoListItem(
                          tarefa: tarefa,
                          onDelete: onDelete,
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Voce tem ${tarefas.length} tarefas',
                        style: Theme.of(context).textTheme.titleSmall,
                        textAlign: TextAlign.center,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          clearTask();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shadowColor: Colors.redAccent,
                          elevation: 10,
                          padding: const EdgeInsets.all(10),
                        ),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addTask(String text) {
    // add na lista de tarefas
    setState(() {
      Tarefas novaTarefa = Tarefas(
        nome: text,
        data: DateTime.now(),
        concluida: false,
      );
      tarefas.add(novaTarefa);
    });

    // limpar o campo de texto
    tarefaController.clear();
    log(tarefas.toString());
  }

  void changedTask(String text) {
    log('mudou para: $text');
    if (text == 'adelson') log('é o adelson');
  }

  void clearTask() {
    showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text('Apagar todas as tarefas?'),
      content: const Text('Tem certeza?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            deleteAll();
          },
          child: const Text('Apagar'),
        ),
      ],
    ),
    );
  }

  void deleteAll() {
    setState(() {
      tarefas.clear();
    });
  }

  void onDelete(Tarefas tarefa) {
    setState(() {
      tarefas.remove(tarefa);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa * ${tarefa.nome} * apagada'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.greenAccent,
          onPressed: () {
            setState(() {
              tarefas.add(tarefa);
            });
          },
        )
      ),
    );
  }
}
