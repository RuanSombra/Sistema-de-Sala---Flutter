// screens/gerenciar_reservas_coordenador_screen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Para obter o ID do coordenador
import '../models/reservas.dart';
import '../service/reserva_service.dart';
import '../style/colors.dart'; // Suas cores

class GerenciarReservasCoordenadorScreen extends StatefulWidget {
  final User user; // Coordenador logado
  const GerenciarReservasCoordenadorScreen({Key? key, required this.user})
    : super(key: key);

  @override
  State<GerenciarReservasCoordenadorScreen> createState() =>
      _GerenciarReservasCoordenadorScreenState();
}

class _GerenciarReservasCoordenadorScreenState
    extends State<GerenciarReservasCoordenadorScreen> {
  final ReservaService _reservaService = ReservaService();

  void _showFeedbackDialog(Reserva reserva, bool aprovar) {
    final TextEditingController feedbackController = TextEditingController(
      text: aprovar ? 'Reserva aprovada.' : '',
    ); // Texto padrão para aprovação

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(aprovar ? 'Aprovar Reserva' : 'Rejeitar Reserva'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Reserva para ${reserva.nomeSala} por ${reserva.nomeProfessor} em ${reserva.dataInicio.toDate().toLocaleDateString()}',
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: feedbackController,
                decoration: InputDecoration(
                  labelText:
                      aprovar
                          ? 'Feedback (opcional)'
                          : 'Motivo da Rejeição (obrigatório)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (!aprovar && (value == null || value.trim().isEmpty)) {
                    return 'O motivo é obrigatório para rejeitar.';
                  }
                  return null;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (!aprovar && (feedbackController.text.trim().isEmpty)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Motivo da rejeição é obrigatório.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                try {
                  if (aprovar) {
                    await _reservaService.aprovarReserva(
                      reservaId: reserva.id,
                      coordenadorId: widget.user.uid,
                      nomeCoordenador: widget.user.displayName,
                      feedback: feedbackController.text.trim(),
                    );
                  } else {
                    await _reservaService.rejeitarReserva(
                      reservaId: reserva.id,
                      coordenadorId: widget.user.uid,
                      nomeCoordenador: widget.user.displayName,
                      feedback: feedbackController.text.trim(),
                    );
                  }
                  Navigator.of(ctx).pop(); // Fecha o dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Reserva ${aprovar ? "aprovada" : "rejeitada"}!',
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text(aprovar ? 'Aprovar' : 'Rejeitar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: aprovar ? Colors.green : Colors.red,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solicitações de Reserva'),
        backgroundColor: azulEscuro, // Sua cor
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<List<Reserva>>(
        stream: _reservaService.getReservasPendentesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma solicitação pendente.'));
          }

          List<Reserva> solicitacoes = snapshot.data!;

          return ListView.builder(
            itemCount: solicitacoes.length,
            itemBuilder: (context, index) {
              Reserva reserva = solicitacoes[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('${reserva.nomeSala} - ${reserva.nomeProfessor}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data: ${reserva.dataInicio.toDate().toLocaleDateString()} ${reserva.dataInicio.toDate().toLocaleTimeString()} - ${reserva.dataFim.toDate().toLocaleTimeString()}',
                      ),
                      Text('Motivo: ${reserva.disciplinaMotivo}'),
                      Text('Status: ${reserva.statusReserva}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onPressed:
                            () => _showFeedbackDialog(reserva, true), // Aprovar
                        tooltip: 'Aprovar',
                      ),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed:
                            () =>
                                _showFeedbackDialog(reserva, false), // Rejeitar
                        tooltip: 'Rejeitar',
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

// Helper para formatar data, se precisar
extension DateTimeExtension on DateTime {
  String toLocaleDateString() =>
      "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";
  String toLocaleTimeString() =>
      "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
}
