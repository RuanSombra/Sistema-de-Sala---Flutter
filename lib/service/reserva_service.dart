// service/reserva_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reservas.dart'; // Certifique-se que o caminho está correto

class ReservaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'reservas';

  // Função para criar reserva (você já tem uma global, pode adaptar ou mover para cá)
  // Se for manter a global, não precisa duplicar.
  // Apenas garanta que ela use 'pendente_aprovacao' como status quando necessário.

  // Stream para o Coordenador ver reservas pendentes
  Stream<List<Reserva>> getReservasPendentesStream() {
    return _firestore
        .collection('reservas')
        .where(
          'statusReserva',
          isEqualTo: 'pendente_aprovacao',
        ) // CONFIRA O VALOR EXATO
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => Reserva.fromFirestore(
                      doc as DocumentSnapshot<Map<String, dynamic>>,
                    ),
                  )
                  .toList(),
        );
  }

  // Stream para o Professor ver suas próprias reservas
  Stream<List<Reserva>> getMinhasReservasStream(String idProfessor) {
    return _firestore
        .collection(_collectionPath)
        .where('idProfessor', isEqualTo: idProfessor)
        .orderBy('criadoEm', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map(
                    (doc) => Reserva.fromFirestore(
                      doc as DocumentSnapshot<Map<String, dynamic>>,
                    ),
                  )
                  .toList(),
        );
  }

  // Ação do Coordenador: Aprovar Reserva
  Future<void> aprovarReserva({
    required String reservaId,
    required String coordenadorId,
    String? nomeCoordenador, // Opcional
    String? feedback,
  }) async {
    await _firestore.collection(_collectionPath).doc(reservaId).update({
      'statusReserva': 'aprovada', // CONFIRA O VALOR EXATO
      'aprovadoRecusadoPor': coordenadorId,
      'dataAprovacaoRecusa': Timestamp.now(),
      'feedbackCoordenador': feedback ?? 'Reserva aprovada pelo coordenador.',
    });
  }

  // Ação do Coordenador: Rejeitar Reserva
  Future<void> rejeitarReserva({
    required String reservaId,
    required String coordenadorId,
    String? nomeCoordenador, // Opcional
    required String feedback,
  }) async {
    if (feedback.isEmpty) {
      throw Exception('O motivo da rejeição é obrigatório.');
    }
    await _firestore.collection(_collectionPath).doc(reservaId).update({
      'statusReserva': 'rejeitada', // CONFIRA O VALOR EXATO
      'aprovadoRecusadoPor': coordenadorId,
      'dataAprovacaoRecusa': Timestamp.now(),
      'feedbackCoordenador': feedback,
    });
  }

  // (Opcional) Ação do Professor: Cancelar Reserva
  Future<void> cancelarReservaProfessor(String reservaId) async {
    // Adicione regras aqui: um professor só pode cancelar se a reserva for dele
    // e se o status permitir (ex: 'pendente_aprovacao' ou 'aprovada' com antecedência)
    await _firestore.collection(_collectionPath).doc(reservaId).update({
      'statusReserva': 'cancelada_professor', // CONFIRA O VALOR EXATO
      // 'dataCancelamento': Timestamp.now(), // Opcional
    });
  }
}
