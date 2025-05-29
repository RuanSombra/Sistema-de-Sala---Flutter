// screens/minhas_reservas_professor_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/gerenciar_solicitacoes.dart';
import '../../models/reservas.dart';
import '../../service/reserva_service.dart';
import '../../style/colors.dart';

class MinhasReservasProfessorScreen extends StatefulWidget {
  final User user; // Professor logado
  const MinhasReservasProfessorScreen({Key? key, required this.user})
    : super(key: key);

  @override
  State<MinhasReservasProfessorScreen> createState() =>
      _MinhasReservasProfessorScreenState();
}

class _MinhasReservasProfessorScreenState
    extends State<MinhasReservasProfessorScreen> {
  final ReservaService _reservaService = ReservaService();

  Color _getStatusColor(String status) {
    switch (status) {
      case 'aprovada':
      case 'confirmada': // Se você usar 'confirmada' como auto-aprovada
        return Colors.green;
      case 'pendente_aprovacao':
        return Colors.orange;
      case 'rejeitada':
      case 'cancelada_professor': // Adicione outros status de cancelamento/rejeição
      case 'cancelada_coordenador':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Reservas'),
        backgroundColor: azulEscuro, // Sua cor
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<Reserva>>(
        stream: _reservaService.getMinhasReservasStream(widget.user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Você ainda não fez nenhuma reserva.'),
            );
          }

          List<Reserva> minhasReservas = snapshot.data!;

          return ListView.builder(
            itemCount: minhasReservas.length,
            itemBuilder: (context, index) {
              Reserva reserva = minhasReservas[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reserva.nomeSala,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Data: ${reserva.dataInicio.toDate().toLocaleDateString()} ${reserva.dataInicio.toDate().toLocaleTimeString()} - ${reserva.dataFim.toDate().toLocaleTimeString()}',
                      ),
                      Text('Motivo: ${reserva.disciplinaMotivo}'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'Status: ',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(
                                reserva.statusReserva,
                              ).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              reserva.statusReserva
                                  .replaceAll('_', ' ')
                                  .toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(reserva.statusReserva),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (reserva.statusReserva == 'rejeitada' &&
                          reserva.feedbackCoordenador != null &&
                          reserva.feedbackCoordenador!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Feedback da Coordenação: ${reserva.feedbackCoordenador}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                      // Opcional: Botão para cancelar reserva
                      if (reserva.statusReserva == 'pendente_aprovacao' ||
                          reserva.statusReserva == 'aprovada')
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () async {
                              bool confirmarCancelamento =
                                  await showDialog(
                                    context: context,
                                    builder:
                                        (ctx) => AlertDialog(
                                          title: const Text(
                                            'Cancelar Reserva?',
                                          ),
                                          content: const Text(
                                            'Tem certeza que deseja cancelar esta reserva?',
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(
                                                    ctx,
                                                  ).pop(false),
                                              child: const Text('Não'),
                                            ),
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.of(
                                                    ctx,
                                                  ).pop(true),
                                              child: const Text(
                                                'Sim, Cancelar',
                                              ),
                                            ),
                                          ],
                                        ),
                                  ) ??
                                  false;

                              if (confirmarCancelamento) {
                                try {
                                  await _reservaService
                                      .cancelarReservaProfessor(reserva.id);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Reserva cancelada.'),
                                      backgroundColor: Colors.orange,
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Erro ao cancelar: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Cancelar Reserva',
                              style: TextStyle(color: Colors.red[700]),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Reutilize a extensão DateTimeExtension se ela não estiver acessível globalmente.
// extension DateTimeExtension on DateTime {
// String toLocaleDateString() => "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";
// String toLocaleTimeString() => "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
// }
