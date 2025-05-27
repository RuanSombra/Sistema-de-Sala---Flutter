import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/models/salas.dart'; // Ajuste o caminho
import 'package:uuid/uuid.dart';

class SalaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // ignore: unused_field
  final Uuid _uuid = const Uuid();

  // Cadastrar ou Atualizar Sala em um Bloco específico
  Future<void> salvarSala(String blocoId, Salas sala) async {
    // String salaId = sala.id.isEmpty ? _uuid.v1() : sala.id; // ID já vem do Uuid.

    await _firestore
        .collection('blocos')
        .doc(blocoId)
        .collection('salas')
        .doc(sala.id) // Usa o ID do objeto Sala (que veio do Uuid)
        .set({
          ...sala.toMap(), // ou sala.toFirestore()
          'atualizadoEm': FieldValue.serverTimestamp(),
          if (sala.id.isEmpty ||
              await _isNovoDocumento('blocos/$blocoId/salas', sala.id))
            'criadoEm': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
  }

  Future<bool> _isNovoDocumento(String collectionPath, String docId) async {
    final doc = await _firestore.collection(collectionPath).doc(docId).get();
    return !doc.exists;
  }

  // Buscar Todas as Salas de um Bloco específico
  Future<List<Salas>> buscarSalasPorBloco(String blocoId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _firestore
            .collection('blocos')
            .doc(blocoId)
            .collection('salas')
            .orderBy('nome') // Ordenar por nome, por exemplo
            .get();

    return snapshot.docs.map((doc) {
      Map<String, dynamic> dataComId = doc.data();
      if (dataComId['id'] == null || dataComId['id'] != doc.id) {
        dataComId['id'] = doc.id;
      }
      return Salas.fromMap(dataComId); // ou Salas.fromFirestore(doc)
    }).toList();
  }

  // Remover uma Sala específica
  Future<void> removerSala(String blocoId, String salaId) async {
    await _firestore
        .collection('blocos')
        .doc(blocoId)
        .collection('salas')
        .doc(salaId)
        .delete();
  }

  // Remover Todas as Salas de um Bloco (usado pelo BlocoService)
  Future<void> removerTodasSalasDoBloco(String blocoId) async {
    QuerySnapshot salasSnapshot =
        await _firestore
            .collection('blocos')
            .doc(blocoId)
            .collection('salas')
            .get();

    for (var doc in salasSnapshot.docs) {
      await doc.reference.delete();
    }
  }
}
