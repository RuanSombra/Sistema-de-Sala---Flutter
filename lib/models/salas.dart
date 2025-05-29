import 'package:cloud_firestore/cloud_firestore.dart';

class Salas {
  String id; // Armazenará o ID do documento do Firestore
  String nome;
  String blocoId; // ID do documento do bloco relacionado
  String? nomeBloco; // Denormalizado: nome do bloco para fácil exibição
  int capacidade;
  String status; // Opcional
  Timestamp? criadoEm;
  Timestamp? atualizadoEm;

  Salas({
    required this.id,
    required this.nome,
    required this.blocoId,
    this.nomeBloco,
    required this.capacidade,
    required this.status,
    this.criadoEm,
    this.atualizadoEm,
  });

  /// Cria uma instância de Sala a partir de um DocumentSnapshot do Firestore.
  factory Salas.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception("Dados da sala não encontrados no snapshot!");
    }
    return Salas(
      id: snapshot.id,
      nome: data['nome'] as String? ?? 'Nome não informado',
      blocoId: data['blocoId'] as String? ?? '',
      nomeBloco: data['nomeBloco'] as String?,
      capacidade: data['capacidade'] as int? ?? 0,
      status: data['status'] as String? ?? 'indisponivel',
      criadoEm: data['criadoEm'] as Timestamp?,
      atualizadoEm: data['atualizadoEm'] as Timestamp?,
    );
  }

  /// Converte a instância de Sala para um Map<String, dynamic> para ser salvo no Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'blocoId': blocoId,
      if (nomeBloco != null) 'nomeBloco': nomeBloco,
      'capacidade': capacidade,
      'status': status,
      // 'criadoEm' e 'atualizadoEm' idealmente gerenciados com FieldValue.serverTimestamp()
    };
  }

  // Seus construtores e métodos originais
  Salas.fromMap(Map<String, dynamic> map)
    : id = map['id'] as String? ?? '',
      nome = map['nome'] as String? ?? '',
      blocoId =
          map['blocoId'] as String? ?? '', // Adicione se necessário no seu map
      nomeBloco = map['nomeBloco'] as String?, // Adicione se necessário
      capacidade =
          map['capacidade'] as int? ?? 0, // Adicione se necessário// Adicione
      status = map['status'] as String? ?? 'indisponivel'; // Adicione

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'blocoId': blocoId, // Adicione
      'nomeBloco': nomeBloco, // Adicione
      'capacidade': capacidade, // Adicione
      'status': status, // Adicione
    };
  }
}

// class Salas {
//   String id;
//   String nome;
//   String especializacao;

//   Salas({required this.id, required this.nome, required this.especializacao});

//   Salas.fromMap(Map<String, dynamic> map)
//     : id = map['id'],
//       nome = map['nome'],
//       especializacao = map['especializacao'];

//   Map<String, dynamic> toMap() {
//     return {'id': id, 'nome': nome, 'especializacao': especializacao};
//   }
// }
