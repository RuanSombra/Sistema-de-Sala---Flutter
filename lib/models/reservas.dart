import 'package:cloud_firestore/cloud_firestore.dart';

class Reserva {
  String id; // ID do documento da reserva no Firestore
  String idSala;
  String nomeSala; // Denormalizado para fácil exibição
  String idProfessor; // UID do professor que fez a reserva
  String nomeProfessor; // Denormalizado para fácil exibição
  String disciplinaMotivo;
  Timestamp dataInicio; // Data e hora de início da reserva
  Timestamp dataFim; // Data e hora de término da reserva
  String
  statusReserva; // Ex: "confirmada", "pendente_aprovacao", "recusada", "cancelada_professor", "cancelada_coordenador", "concluida"
  bool recorrente;
  String? idReservaPaiRecorrencia; // Para agrupar reservas recorrentes
  Timestamp criadoEm;
  String? aprovadoRecusadoPor; // UID do coordenador (se aplicável)
  Timestamp? dataAprovacaoRecusa;
  String? feedbackCoordenador;

  Reserva({
    required this.id,
    required this.idSala,
    required this.nomeSala,
    required this.idProfessor,
    required this.nomeProfessor,
    required this.disciplinaMotivo,
    required this.dataInicio,
    required this.dataFim,
    required this.statusReserva,
    this.recorrente = false,
    this.idReservaPaiRecorrencia,
    required this.criadoEm,
    this.aprovadoRecusadoPor,
    this.dataAprovacaoRecusa,
    this.feedbackCoordenador,
  });

  factory Reserva.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception("Dados da reserva não encontrados no snapshot!");
    }
    return Reserva(
      id: snapshot.id,
      idSala: data['idSala'] as String,
      nomeSala: data['nomeSala'] as String? ?? 'Sala não informada',
      idProfessor: data['idProfessor'] as String,
      nomeProfessor:
          data['nomeProfessor'] as String? ?? 'Professor não informado',
      disciplinaMotivo: data['disciplinaMotivo'] as String? ?? '',
      dataInicio: data['dataInicio'] as Timestamp,
      dataFim: data['dataFim'] as Timestamp,
      statusReserva: data['statusReserva'] as String? ?? 'pendente_aprovacao',
      recorrente: data['recorrente'] as bool? ?? false,
      idReservaPaiRecorrencia: data['idReservaPaiRecorrencia'] as String?,
      criadoEm:
          data['criadoEm'] as Timestamp? ??
          Timestamp.now(), // Melhor garantir que sempre exista
      aprovadoRecusadoPor: data['aprovadoRecusadoPor'] as String?,
      dataAprovacaoRecusa: data['dataAprovacaoRecusa'] as Timestamp?,
      feedbackCoordenador: data['feedbackCoordenador'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'idSala': idSala,
      'nomeSala': nomeSala,
      'idProfessor': idProfessor,
      'nomeProfessor': nomeProfessor,
      'disciplinaMotivo': disciplinaMotivo,
      'dataInicio': dataInicio,
      'dataFim': dataFim,
      'statusReserva': statusReserva,
      'recorrente': recorrente,
      if (idReservaPaiRecorrencia != null)
        'idReservaPaiRecorrencia': idReservaPaiRecorrencia,
      'criadoEm':
          criadoEm, // Pode ser FieldValue.serverTimestamp() na criação inicial
      if (aprovadoRecusadoPor != null)
        'aprovadoRecusadoPor': aprovadoRecusadoPor,
      if (dataAprovacaoRecusa != null)
        'dataAprovacaoRecusa': dataAprovacaoRecusa,
      if (feedbackCoordenador != null)
        'feedbackCoordenador': feedbackCoordenador,
    };
  }
}

Future<void> criarReserva({
  required String idSala,
  required String nomeSala,
  required String idProfessor, // UID do professor logado
  required String nomeProfessor, // Nome do professor logado
  required String disciplinaMotivo,
  required DateTime dataInicio,
  required DateTime dataFim,
  required bool isReservaProlongada, // Você precisa definir essa lógica
}) async {
  final firestore = FirebaseFirestore.instance;

  // Obter o usuário professor atual (você já deve ter essa lógica)
  // final userId = FirebaseAuth.instance.currentUser?.uid;
  // final nomeProfessor = FirebaseAuth.instance.currentUser?.displayName ?? "Nome não disponível";
  // if (userId == null) throw Exception("Usuário não autenticado.");

  String statusInicial =
      isReservaProlongada ? "pendente_aprovacao" : "confirmada";

  final novaReserva = Reserva(
    id: '', // O Firestore gerará o ID
    idSala: idSala,
    nomeSala: nomeSala,
    idProfessor: idProfessor,
    nomeProfessor: nomeProfessor,
    disciplinaMotivo: disciplinaMotivo,
    dataInicio: Timestamp.fromDate(dataInicio),
    dataFim: Timestamp.fromDate(dataFim),
    statusReserva: statusInicial,
    criadoEm:
        Timestamp.now(), // ou FieldValue.serverTimestamp() se for diretamente no add
  );

  // Idealmente, use uma transação ou uma Cloud Function para garantir atomicidade
  // e re-verificar a disponibilidade no momento exato da escrita para evitar conflitos.
  // Por simplicidade aqui, vamos adicionar diretamente:
  DocumentReference docRef = await firestore
      .collection('reservas')
      .add(novaReserva.toFirestore());
  print('Reserva criada com ID: ${docRef.id}');

  // Aqui você dispararia notificações para o professor e, se pendente, para o coordenador.
}
