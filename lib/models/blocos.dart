import 'package:cloud_firestore/cloud_firestore.dart';

class Blocos {
  String id;
  String nome;
  String especializacao;
  Timestamp? criadoEm;
  Timestamp? atualizadoEm;

  Blocos({
    required this.id,
    required this.nome,
    required this.especializacao,
    this.criadoEm,
    this.atualizadoEm,
  });

  /// Cria uma instância de Bloco a partir de um DocumentSnapshot do Firestore

  factory Blocos.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception("Dados do bloco não encontrados no snapshot!");
    }
    return Blocos(
      id: snapshot.id, // Pega o ID do documento
      nome: data['nome'] as String? ?? 'Nome não informado',
      especializacao:
          data['especializacao'] as String? ?? 'Especialização não informada',
      criadoEm: data['criadoEm'] as Timestamp?,
      atualizadoEm: data['atualizadoEm'] as Timestamp?,
    );
  }

  /// Converte a instância de Bloco para um Map<String, dynamic> para ser salvo no Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      // O 'id' não é incluído aqui porque ele é o identificador do documento.
      // 'criadoEm' pode ser gerenciado pelo FieldValue.serverTimestamp() na criação.
      // 'atualizadoEm' pode ser gerenciado pelo FieldValue.serverTimestamp() na atualização.
    };
  }

  // Seus construtores e métodos originais podem ser mantidos se você os usa
  // para outras conversões ou lógica de UI, mas os acima são específicos para o Firestore.
  Blocos.fromMap(Map<String, dynamic> map)
    : id = map['id'] as String? ?? '', // Assume que o ID está no mapa
      nome = map['nome'] as String? ?? '',
      especializacao = map['especializacao'] as String? ?? '';

  Map<String, dynamic> toMap() {
    return {'id': id, 'nome': nome, 'especializacao': especializacao};
  }
}
