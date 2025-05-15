class Salas {
  String id;
  String nome;
  String especializacao;

  Salas({required this.id, required this.nome, required this.especializacao});

  Salas.fromMap(Map<String, dynamic> map)
    : id = map['id'],
      nome = map['nome'],
      especializacao = map['especializacao'];

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'especializacao': especializacao};
  }
}
