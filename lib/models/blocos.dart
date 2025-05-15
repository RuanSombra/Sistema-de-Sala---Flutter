class Blocos {
  String id;
  String nome;

  Blocos({required this.id, required this.nome});

  Blocos.fromMap(Map<String?, dynamic> map)
    : id = map['id'] as String? ?? '',
      nome = map['nome'] as String? ?? '';

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome};
  }
}
