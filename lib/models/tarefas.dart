class Tarefas{
  String nome;
  DateTime data;
  bool concluida;

  Tarefas({required this.nome, required this.data, required this.concluida});

  Tarefas.fromJson(Map<String, dynamic> json)
      : nome = json['nome'] as String? ?? '',
        data = DateTime.parse(json['data'] as String),
        concluida = json['concluida'] as bool? ?? false;

  Map<String, dynamic> toJson() => {
    'nome': nome,
    'data': data.toIso8601String(),
    'concluida': concluida,
  };

}