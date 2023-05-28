import 'dart:convert';
import 'dart:developer';

import 'package:app_tarefas/models/tarefas.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String TAREFAS_KEY = 'listaTarefas';

class TarefaRepository {

  late SharedPreferences sharedPreferences;

  Future<List<Tarefas>> getListaTarefas() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString(TAREFAS_KEY) ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    final List<Tarefas> tarefas = jsonDecoded.map((e) => Tarefas.fromJson(e)).toList();

    return tarefas;
  }


  saveListaTarefas(List<Tarefas> listaTarefas) {
    final String jsonString = json.encode(listaTarefas);
    sharedPreferences.setString(TAREFAS_KEY, jsonString);
    log('Lista de tarefas salva');
  }
}
