import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/blocos.dart';
import '../models/reservas.dart';
import '../models/salas.dart';
import '../service/blocos_service.dart';
import '../service/salas_service.dart';
import '../style/colors.dart';
import '../style/images.dart';

class ReservaScreen extends StatefulWidget {
  final Salas? salaSelecionada;
  final Blocos? blocoSelecionado;

  const ReservaScreen({
    Key? key,
    this.salaSelecionada,
    this.blocoSelecionado,
    required Salas sala,
    required Blocos bloco,
  }) : super(key: key);

  @override
  State<ReservaScreen> createState() => _ReservaScreenState();
}

class _ReservaScreenState extends State<ReservaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _disciplinaMotivoController = TextEditingController();

  final BlocoService _blocoService = BlocoService();
  final SalaService _salaService = SalaService();

  Blocos? _blocoSelecionado;
  Salas? _salaSelecionada;
  DateTime? _dataInicio;
  DateTime? _dataFim;
  TimeOfDay? _horaInicio;
  TimeOfDay? _horaFim;

  bool _isLoading = false;
  bool _verificandoDisponibilidade = false;
  bool _recorrente = false;

  List<Blocos> _blocos = [];
  List<Salas> _salasDisponiveis = [];

  @override
  void initState() {
    super.initState();
    _blocoSelecionado = widget.blocoSelecionado;
    _salaSelecionada = widget.salaSelecionada;
    _carregarBlocos();
    if (_blocoSelecionado != null) {
      _carregarSalas(_blocoSelecionado!.id);
    }
  }

  Future<void> _carregarBlocos() async {
    try {
      final blocos = await _blocoService.buscarTodosBlocos();
      setState(() {
        _blocos = blocos;
      });
    } catch (e) {
      _mostrarErro('Erro ao carregar blocos: $e');
    }
  }

  Future<void> _carregarSalas(String blocoId) async {
    try {
      final salas = await _salaService.buscarSalasPorBloco(blocoId);
      setState(() {
        _salasDisponiveis =
            salas.where((sala) => sala.status == 'disponivel').toList();
        // Se a sala selecionada não está na lista de disponíveis, reseta
        if (_salaSelecionada != null &&
            !_salasDisponiveis.any((s) => s.id == _salaSelecionada!.id)) {
          _salaSelecionada = null;
        }
      });
    } catch (e) {
      _mostrarErro('Erro ao carregar salas: $e');
    }
  }

  Future<bool> _verificarDisponibilidade() async {
    if (_salaSelecionada == null ||
        _dataInicio == null ||
        _horaInicio == null ||
        _horaFim == null) {
      return false;
    }

    setState(() => _verificandoDisponibilidade = true);

    try {
      final dataInicioCompleta = DateTime(
        _dataInicio!.year,
        _dataInicio!.month,
        _dataInicio!.day,
        _horaInicio!.hour,
        _horaInicio!.minute,
      );

      final dataFimCompleta = DateTime(
        _dataInicio!.year,
        _dataInicio!.month,
        _dataInicio!.day,
        _horaFim!.hour,
        _horaFim!.minute,
      );

      // Verificar conflitos de horário
      final conflitos =
          await FirebaseFirestore.instance
              .collection('reservas')
              .where('idSala', isEqualTo: _salaSelecionada!.id)
              .where(
                'statusReserva',
                whereIn: ['confirmada', 'pendente_aprovacao'],
              )
              .get();

      for (var doc in conflitos.docs) {
        final reserva = Reserva.fromFirestore(doc);
        final inicioExistente = reserva.dataInicio.toDate();
        final fimExistente = reserva.dataFim.toDate();

        // Verifica se há sobreposição
        if (dataInicioCompleta.isBefore(fimExistente) &&
            dataFimCompleta.isAfter(inicioExistente)) {
          return false;
        }
      }

      return true;
    } catch (e) {
      _mostrarErro('Erro ao verificar disponibilidade: $e');
      return false;
    } finally {
      setState(() => _verificandoDisponibilidade = false);
    }
  }

  Future<void> _criarReserva() async {
    if (!_formKey.currentState!.validate()) return;

    // Validações adicionais
    if (_horaFim!.hour < _horaInicio!.hour ||
        (_horaFim!.hour == _horaInicio!.hour &&
            _horaFim!.minute <= _horaInicio!.minute)) {
      _mostrarErro('Hora de fim deve ser posterior à hora de início');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Usuário não autenticado');
      }

      // Verificar disponibilidade
      final disponivel = await _verificarDisponibilidade();
      if (!disponivel) {
        _mostrarErro('Sala não disponível no horário selecionado');
        return;
      }

      final dataInicioCompleta = DateTime(
        _dataInicio!.year,
        _dataInicio!.month,
        _dataInicio!.day,
        _horaInicio!.hour,
        _horaInicio!.minute,
      );

      final dataFimCompleta = DateTime(
        _dataInicio!.year,
        _dataInicio!.month,
        _dataInicio!.day,
        _horaFim!.hour,
        _horaFim!.minute,
      );

      // Verificar se é reserva prolongada (mais de 2 horas)
      final duracao = dataFimCompleta.difference(dataInicioCompleta);
      final isReservaProlongada = duracao.inHours > 2;

      await criarReserva(
        idSala: _salaSelecionada!.id,
        nomeSala: _salaSelecionada!.nome,
        idProfessor: user.uid,
        nomeProfessor: user.displayName ?? 'Professor',
        disciplinaMotivo: _disciplinaMotivoController.text,
        dataInicio: dataInicioCompleta,
        dataFim: dataFimCompleta,
        isReservaProlongada: isReservaProlongada,
      );

      _mostrarSucesso(
        isReservaProlongada
            ? 'Reserva criada! Aguardando aprovação da coordenação.'
            : 'Reserva confirmada com sucesso!',
      );

      // Volta para a tela anterior após sucesso
      Navigator.of(context).pop();
    } catch (e) {
      _mostrarErro('Erro ao criar reserva: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.red),
    );
  }

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: branco,
      appBar: AppBar(
        title: Image.asset(LogoSenaiBranco, height: 25),
        centerTitle: true,
        backgroundColor: azulEscuro,
        iconTheme: IconThemeData(color: branco, size: 30),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Título
              Text(
                'Nova Reserva de Sala',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: azulEscuro,
                  fontFamily: 'Inter',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Seleção de Bloco
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.business, color: azulEscuro),
                          const SizedBox(width: 8),
                          Text(
                            'Selecionar Bloco',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: azulEscuro,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<Blocos>(
                        value: _blocoSelecionado,
                        decoration: InputDecoration(
                          labelText: 'Bloco',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: azulEscuro, width: 2),
                          ),
                        ),
                        items:
                            _blocos.map((bloco) {
                              return DropdownMenuItem(
                                value: bloco,
                                child: Text(
                                  '${bloco.nome} - ${bloco.especializacao}',
                                  style: const TextStyle(fontFamily: 'Inter'),
                                ),
                              );
                            }).toList(),
                        onChanged: (bloco) {
                          setState(() {
                            _blocoSelecionado = bloco;
                            _salaSelecionada = null;
                          });
                          if (bloco != null) {
                            _carregarSalas(bloco.id);
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione um bloco';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Seleção de Sala
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.meeting_room, color: azulEscuro),
                          const SizedBox(width: 8),
                          Text(
                            'Selecionar Sala',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: azulEscuro,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<Salas>(
                        value: _salaSelecionada,
                        decoration: InputDecoration(
                          labelText: 'Sala',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: azulEscuro, width: 2),
                          ),
                        ),
                        items:
                            _salasDisponiveis.map((sala) {
                              return DropdownMenuItem(
                                value: sala,
                                child: Text(
                                  '${sala.nome} (Cap: ${sala.capacidade})',
                                  style: const TextStyle(fontFamily: 'Inter'),
                                ),
                              );
                            }).toList(),
                        onChanged: (sala) {
                          setState(() {
                            _salaSelecionada = sala;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione uma sala';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Data e Hora
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.schedule, color: azulEscuro),
                          const SizedBox(width: 8),
                          Text(
                            'Data e Horário',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: azulEscuro,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Data
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Data da Reserva',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: azulEscuro, width: 2),
                          ),
                          suffixIcon: Icon(
                            Icons.calendar_today,
                            color: azulEscuro,
                          ),
                        ),
                        readOnly: true,
                        controller: TextEditingController(
                          text:
                              _dataInicio != null
                                  ? '${_dataInicio!.day.toString().padLeft(2, '0')}/${_dataInicio!.month.toString().padLeft(2, '0')}/${_dataInicio!.year}'
                                  : '',
                        ),
                        onTap: () async {
                          final data = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().add(
                              const Duration(days: 1),
                            ),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                            builder: (context, child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: ColorScheme.light(
                                    primary: azulEscuro,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (data != null) {
                            setState(() {
                              _dataInicio = data;
                            });
                          }
                        },
                        validator: (value) {
                          if (_dataInicio == null) {
                            return 'Selecione a data da reserva';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // Horários
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Hora de Início',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: azulEscuro,
                                    width: 2,
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.access_time,
                                  color: azulEscuro,
                                ),
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                text:
                                    _horaInicio != null
                                        ? '${_horaInicio!.hour.toString().padLeft(2, '0')}:${_horaInicio!.minute.toString().padLeft(2, '0')}'
                                        : '',
                              ),
                              onTap: () async {
                                final hora = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: azulEscuro,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (hora != null) {
                                  setState(() {
                                    _horaInicio = hora;
                                  });
                                }
                              },
                              validator: (value) {
                                if (_horaInicio == null) {
                                  return 'Selecione a hora de início';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Hora de Fim',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: azulEscuro,
                                    width: 2,
                                  ),
                                ),
                                suffixIcon: Icon(
                                  Icons.access_time,
                                  color: azulEscuro,
                                ),
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                text:
                                    _horaFim != null
                                        ? '${_horaFim!.hour.toString().padLeft(2, '0')}:${_horaFim!.minute.toString().padLeft(2, '0')}'
                                        : '',
                              ),
                              onTap: () async {
                                final hora = await showTimePicker(
                                  context: context,
                                  initialTime: _horaInicio ?? TimeOfDay.now(),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: azulEscuro,
                                        ),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (hora != null) {
                                  setState(() {
                                    _horaFim = hora;
                                  });
                                }
                              },
                              validator: (value) {
                                if (_horaFim == null) {
                                  return 'Selecione a hora de fim';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Disciplina/Motivo
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.subject, color: azulEscuro),
                          const SizedBox(width: 8),
                          Text(
                            'Disciplina/Motivo',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: azulEscuro,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _disciplinaMotivoController,
                        decoration: InputDecoration(
                          labelText: 'Ex: Aula de Matemática, Reunião, etc.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: azulEscuro, width: 2),
                          ),
                        ),
                        maxLines: 2,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe a disciplina ou motivo da reserva';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Botão de Verificar Disponibilidade
              if (_salaSelecionada != null &&
                  _dataInicio != null &&
                  _horaInicio != null &&
                  _horaFim != null)
                ElevatedButton.icon(
                  onPressed:
                      _verificandoDisponibilidade
                          ? null
                          : _verificarDisponibilidade,
                  icon:
                      _verificandoDisponibilidade
                          ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: branco,
                            ),
                          )
                          : Icon(Icons.search, color: branco),
                  label: Text(
                    _verificandoDisponibilidade
                        ? 'Verificando...'
                        : 'Verificar Disponibilidade',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      color: branco,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: azulEscuro,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),

              const SizedBox(height: 10),

              // Botão Confirmar Reserva
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _criarReserva,
                icon:
                    _isLoading
                        ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: branco,
                          ),
                        )
                        : Icon(Icons.check_circle, color: branco),
                label: Text(
                  _isLoading ? 'Criando Reserva...' : 'Confirmar Reserva',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: branco,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _disciplinaMotivoController.dispose();
    super.dispose();
  }
}
