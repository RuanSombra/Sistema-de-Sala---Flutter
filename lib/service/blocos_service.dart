import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/blocos.dart'; // Ajuste o caminho
import 'package:uuid/uuid.dart';

import 'salas_service.dart';

class BlocoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'blocos';
  // ignore: unused_field
  final Uuid _uuid = const Uuid();
  final SalaService _salaService = SalaService(); // Para operações em cascata

  // Cadastrar ou Atualizar Bloco
  Future<void> salvarBloco(Blocos bloco) async {
    // Se o bloco.id está vazio, é um novo bloco, gere um ID.
    // Se você já gera o ID na UI antes de chamar aqui, pode pular esta linha.
    // No seu código atual, o ID já vem preenchido com Uuid.
    // String blocoId = bloco.id.isEmpty ? _uuid.v1() : bloco.id;

    await _firestore
        .collection(_collectionPath)
        .doc(bloco.id) // Usa o ID do objeto Bloco (que veio do Uuid)
        .set(
          {
            ...bloco.toMap(), // ou bloco.toFirestore() se você criou esse
            'atualizadoEm':
                FieldValue.serverTimestamp(), // Opcional: para rastreamento
            if (bloco.id.isEmpty ||
                await _isNovoDocumento(_collectionPath, bloco.id))
              'criadoEm':
                  FieldValue.serverTimestamp(), // Opcional: para rastreamento
          },
          SetOptions(merge: true),
        ); // merge: true para não sobrescrever campos não mencionados
  }

  Future<bool> _isNovoDocumento(String collection, String docId) async {
    final doc = await _firestore.collection(collection).doc(docId).get();
    return !doc.exists;
  }

  // Buscar Todos os Blocos
  Future<List<Blocos>> buscarTodosBlocos() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore
            .collection(_collectionPath)
            .orderBy('nome')
            .get(); // Ordenar por nome, por exemplo
    return snapshot.docs.map((doc) {
      // Se seu fromMap já espera o 'id' de dentro do data, está ok.
      // Se não, você precisa garantir que o 'id' do documento seja atribuído.
      Map<String, dynamic> dataComId = doc.data();
      if (dataComId['id'] == null || dataComId['id'] != doc.id) {
        dataComId['id'] =
            doc.id; // Garante que o ID do objeto é o ID do documento
      }
      return Blocos.fromMap(dataComId); // ou Blocos.fromFirestore(doc)
    }).toList();
  }

  // Remover Bloco e suas Salas
  Future<void> removerBloco(String blocoId) async {
    // 1. Remover todas as salas da subcoleção deste bloco
    await _salaService.removerTodasSalasDoBloco(blocoId);

    // 2. Remover o documento do bloco
    await _firestore.collection(_collectionPath).doc(blocoId).delete();
  }
}
