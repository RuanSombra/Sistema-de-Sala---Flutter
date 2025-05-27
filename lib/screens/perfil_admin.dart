import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/blocos.dart';
import 'package:flutter_application_1/models/salas.dart';
// AJUSTE OS CAMINHOS DE IMPORTAÇÃO CONFORME SUA ESTRUTURA DE PASTAS
import 'package:flutter_application_1/style/colors.dart'; // Suas cores
import 'package:uuid/uuid.dart';

import '../components/drawer_admin/drawer_admin.dart';
import '../service/blocos_service.dart';
import '../service/salas_service.dart';

class PerfilAdmin extends StatefulWidget {
  final User user;
  const PerfilAdmin({super.key, required this.user});

  @override
  State<PerfilAdmin> createState() => _PerfilAdminState();
}

class _PerfilAdminState extends State<PerfilAdmin> {
  List<Blocos> listBlocos = [];
  Map<String, List<Salas>> blocoSalas = {};
  bool isLoading = true;
  final Uuid _uuid = const Uuid(); // Para gerar IDs para novos itens

  // --- 1. Instancie seus serviços ---
  final BlocoService _blocoService = BlocoService();
  final SalaService _salaService = SalaService();

  // bool customTileExpanded = false; // Removido se não usado criticamente

  @override
  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/senai.png', height: 25),
        centerTitle: true,
        backgroundColor: azulEscuro, // Usando sua cor
        iconTheme: const IconThemeData(color: Colors.white, size: 30),
        elevation: 2,
      ),
      drawer: DrawerAdmin(user: widget.user),
      floatingActionButton: FloatingActionButton(
        backgroundColor: azulEscuro, // Usando sua cor
        shape: const CircleBorder(),
        onPressed: () => showModalBloco(),
        child: Icon(Icons.add, color: branco), // Usando sua cor
        heroTag: "addBloco",
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(),
    );
  }

  Widget _buildBody() {
    if (listBlocos.isEmpty && !isLoading) {
      // Adicionado !isLoading para evitar mostrar msg enquanto carrega
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.domain, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              "Nenhum bloco registrado!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Adicione o seu primeiro bloco tocando no botão +",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: refresh,
      child: ListView.builder(
        itemCount: listBlocos.length,
        padding: const EdgeInsets.all(8),
        itemBuilder: (context, index) {
          Blocos model = listBlocos[index];
          return _buildBlocoCard(model);
        },
      ),
    );
  }

  Widget _buildBlocoCard(Blocos bloco) {
    List<Salas> salasDoBloco = blocoSalas[bloco.id] ?? [];
    // A estrutura visual do seu _buildBlocoCard permanece a mesma
    // As chamadas onPressed nos botões internos já chamam os métodos corretos (showModal, _showDeleteConfirmation)
    // que agora usarão os serviços.
    return Card(
      color: const Color(0xFF0145B5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 4,
      child: ExpansionTile(
        // onExpansionChanged: (bool expanded) {
        //   setState(() {
        //     customTileExpanded = expanded; // Se for usar essa variável, descomente
        //   });
        // },
        backgroundColor: azulEscuro,
        collapsedBackgroundColor: azulEscuro,
        collapsedIconColor: branco,
        iconColor: branco,
        title: Text(
          bloco.nome,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          '${salasDoBloco.length} sala(s) cadastrada(s)',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Inter',
            color: Colors.white70,
          ),
        ),
        children: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Container(
                  // Header Ações do Bloco
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.domain, color: azulEscuro),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Gerenciar Bloco',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: azulEscuro,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed:
                            () => showModalBloco(
                              model: bloco,
                            ), // Passa o bloco para edição
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Editar'),
                        style: TextButton.styleFrom(
                          foregroundColor: azulEscuro,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => _showDeleteBlocoConfirmation(bloco),
                        icon: const Icon(Icons.delete, size: 16),
                        label: const Text('Excluir'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // Header Salas do Bloco
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(Icons.meeting_room, color: azulEscuro),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Salas do Bloco',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed:
                            () => showModalSala(
                              blocoId: bloco.id,
                              nomeBloco: bloco.nome,
                            ),
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Nova Sala'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azulEscuro,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (salasDoBloco.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.meeting_room_outlined,
                          size: 40,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Nenhuma sala cadastrada neste bloco.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...salasDoBloco.map(
                    (sala) => _buildSalaItem(sala, bloco.id, bloco.nome),
                  ), // Passa nomeBloco
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalaItem(Salas sala, String blocoId, String nomeBloco) {
    // A estrutura visual do seu _buildSalaItem permanece a mesma
    // As chamadas onPressed no PopupMenuButton já chamam os métodos corretos
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: azulEscuro.withOpacity(0.1),
          child: Icon(Icons.meeting_room, color: azulEscuro, size: 20),
        ),
        title: Text(
          sala.nome,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Especialização: ${sala.especializacao}\nCapacidade: ${sala.capacidade} - Status: ${sala.status}",
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        isThreeLine: true, // Para acomodar mais informações no subtitle
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              showModalSala(
                blocoId: blocoId,
                nomeBloco: nomeBloco,
                sala: sala,
              ); // Passa a sala para edição
            } else if (value == 'delete') {
              _showDeleteSalaConfirmation(sala, blocoId);
            }
          },
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, size: 16),
                      SizedBox(width: 8),
                      Text('Editar'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, size: 16, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Excluir', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
        ),
      ),
    );
  }

  // --- 2. Métodos da UI agora usam os SERVIÇOS ---

  Future<void> refresh() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    try {
      List<Blocos> tempBlocos = await _blocoService.buscarTodosBlocos();
      Map<String, List<Salas>> tempBlocoSalas = {};
      for (var bloco in tempBlocos) {
        // Assumindo que buscarSalasPorBloco retorne uma lista de Salas já com o nomeBloco (se aplicável)
        // ou você pode buscar o nome do bloco aqui se precisar e não estiver denormalizado na sala.
        tempBlocoSalas[bloco.id] = await _salaService.buscarSalasPorBloco(
          bloco.id,
        );
      }
      if (mounted) {
        setState(() {
          listBlocos = tempBlocos;
          blocoSalas = tempBlocoSalas;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showDeleteBlocoConfirmation(Blocos bloco) {
    List<Salas> salasDoBloco =
        blocoSalas[bloco.id] ?? []; // Pega as salas já carregadas
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // Usar ctx para o contexto do Dialog
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Deseja realmente excluir o bloco "${bloco.nome}"?'),
              if (salasDoBloco.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Atenção: Este bloco possui ${salasDoBloco.length} sala(s) que também serão excluídas.',
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop(); // Fecha o dialog de confirmação
                setState(() {
                  isLoading = true;
                });
                try {
                  await _blocoService.removerBloco(bloco.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Bloco removido com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  await refresh(); // Recarrega a lista
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao remover bloco: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteSalaConfirmation(Salas sala, String blocoId) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        // Usar ctx para o contexto do Dialog
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: Text('Deseja realmente excluir a sala "${sala.nome}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(ctx).pop(); // Fecha o dialog de confirmação
                setState(() {
                  isLoading = true;
                });
                try {
                  await _salaService.removerSala(blocoId, sala.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sala removida com sucesso!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  await refresh(); // Recarrega a lista
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao remover sala: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } finally {
                  if (mounted) {
                    setState(() {
                      isLoading = false;
                    });
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }

  // MODAL E LÓGICA PARA SALVAR BLOCO
  void showModalBloco({Blocos? model}) {
    String title = model == null ? "Adicionar Bloco" : "Editando ${model.nome}";
    TextEditingController blocoController = TextEditingController(
      text: model?.nome ?? '',
    );
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 32,
            right: 32,
            top: 32,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        model != null ? Icons.edit : Icons.add,
                        color: azulEscuro,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(
                            ctx,
                          ).textTheme.headlineSmall?.copyWith(
                            color: azulEscuro,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: blocoController,
                    decoration: InputDecoration(
                      labelText: "Nome do Bloco",
                      hintText: "Ex: Bloco A, Laboratório 1...",
                      prefixIcon: const Icon(Icons.domain),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: azulEscuro, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty)
                        return 'Por favor, insira o nome do bloco';
                      if (value.trim().length < 2)
                        return 'Nome deve ter pelo menos 2 caracteres';
                      return null;
                    },
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text("Cancelar"),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            _salvarBlocoHandler(
                              blocoController.text,
                              model,
                            ); // Chama o handler
                            // Navigator.pop(ctx); // Fechar o modal é feito no handler após sucesso/erro
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azulEscuro,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(model == null ? "Salvar" : "Atualizar"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _salvarBlocoHandler(String nomeBloco, Blocos? blocoExistente) async {
    Navigator.pop(context); // Fecha o Modal primeiro
    setState(() {
      isLoading = true;
    });

    try {
      String idBloco = blocoExistente?.id ?? _uuid.v1();
      Blocos blocoParaSalvar = Blocos(
        id: idBloco,
        nome: nomeBloco.trim(),
        // criadoEm e atualizadoEm são gerenciados pelo serviço
      );

      await _blocoService.salvarBloco(blocoParaSalvar); // Chama o serviço

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            blocoExistente != null
                ? 'Bloco atualizado com sucesso!'
                : 'Bloco adicionado com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      await refresh(); // Recarrega a lista para mostrar as mudanças
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar bloco: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  // MODAL E LÓGICA PARA SALVAR SALA
  void showModalSala({
    required String blocoId,
    required String nomeBloco,
    Salas? sala,
  }) {
    String modalTitle =
        sala == null ? "Adicionar Sala ao $nomeBloco" : "Editando ${sala.nome}";
    TextEditingController nomeSalaController = TextEditingController(
      text: sala?.nome ?? '',
    );
    TextEditingController especializacaoController = TextEditingController(
      text: sala?.especializacao ?? '',
    );
    TextEditingController capacidadeController = TextEditingController(
      text: sala?.capacidade.toString() ?? '',
    );
    List<String> tempRecursos = List<String>.from(
      sala?.recursos ?? [],
    ); // Cria uma cópia editável
    String tempStatus = sala?.status ?? 'disponivel';
    TextEditingController observacoesController = TextEditingController(
      text: sala?.observacoes ?? '',
    );

    final GlobalKey<FormState> formKeySala = GlobalKey<FormState>();

    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctxModal) {
        return StatefulBuilder(
          // Necessário para atualizar estado dentro do modal (ex: chips de recursos)
          builder: (BuildContext modalContext, StateSetter modalSetState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctxModal).viewInsets.bottom,
                left: 24,
                right: 24,
                top: 24,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: formKeySala,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            sala != null ? Icons.edit : Icons.add,
                            color: azulEscuro,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              modalTitle,
                              style: Theme.of(
                                ctxModal,
                              ).textTheme.headlineSmall?.copyWith(
                                color: azulEscuro,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: nomeSalaController,
                        decoration: const InputDecoration(
                          labelText: "Nome da Sala",
                          prefixIcon: Icon(Icons.meeting_room_outlined),
                        ),
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? "Nome obrigatório"
                                    : null,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: especializacaoController,
                        decoration: const InputDecoration(
                          labelText: "Especialização/Tipo",
                          prefixIcon: Icon(Icons.category_outlined),
                        ),
                        validator:
                            (v) =>
                                (v == null || v.trim().isEmpty)
                                    ? "Especialização obrigatória"
                                    : null,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: capacidadeController,
                        decoration: const InputDecoration(
                          labelText: "Capacidade",
                          prefixIcon: Icon(Icons.people_alt_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (v) {
                          if (v == null || v.isEmpty)
                            return "Capacidade obrigatória";
                          if (int.tryParse(v) == null || int.parse(v) <= 0)
                            return "Valor inválido";
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Recursos:",
                        style: Theme.of(ctxModal).textTheme.titleSmall,
                      ),
                      Wrap(
                        spacing: 8.0,
                        children:
                            <String>[
                              'Projetor',
                              'Quadro Branco',
                              'Ar Condicionado',
                              'Computadores',
                              'Internet',
                            ].map((recurso) {
                              return FilterChip(
                                label: Text(recurso),
                                selected: tempRecursos.contains(recurso),
                                onSelected: (selected) {
                                  modalSetState(() {
                                    if (selected) {
                                      tempRecursos.add(recurso);
                                    } else {
                                      tempRecursos.remove(recurso);
                                    }
                                  });
                                },
                                selectedColor: azulEscuro.withOpacity(0.3),
                                checkmarkColor: azulEscuro,
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: tempStatus,
                        decoration: const InputDecoration(
                          labelText: "Status",
                          prefixIcon: Icon(Icons.toggle_on_outlined),
                        ),
                        items:
                            ['disponivel', 'em_manutencao', 'indisponivel'].map(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value[0].toUpperCase() + value.substring(1),
                                  ),
                                );
                              },
                            ).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            modalSetState(() {
                              tempStatus = newValue;
                            });
                          }
                        },
                        validator:
                            (v) =>
                                (v == null || v.isEmpty)
                                    ? "Status obrigatório"
                                    : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: observacoesController,
                        decoration: const InputDecoration(
                          labelText: "Observações (Opcional)",
                          prefixIcon: Icon(Icons.notes_outlined),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctxModal),
                            child: const Text("Cancelar"),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (formKeySala.currentState!.validate()) {
                                _salvarSalaHandler(
                                  blocoId: blocoId,
                                  nomeBloco: nomeBloco,
                                  salaExistente: sala,
                                  nome: nomeSalaController.text,
                                  especializacao: especializacaoController.text,
                                  capacidade: int.parse(
                                    capacidadeController.text,
                                  ),
                                  recursos: tempRecursos,
                                  status: tempStatus,
                                  observacoes: observacoesController.text,
                                );
                                // Navigator.pop(ctxModal); // Fechar o modal é feito no handler
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: azulEscuro,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(sala == null ? "Salvar" : "Atualizar"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _salvarSalaHandler({
    required String blocoId,
    required String nomeBloco, // Para denormalização no objeto Sala
    Salas? salaExistente,
    required String nome,
    required String especializacao,
    required int capacidade,
    required List<String> recursos,
    required String status,
    String? observacoes,
  }) async {
    Navigator.pop(context); // Fecha o Modal primeiro
    setState(() {
      isLoading = true;
    });

    try {
      String idSala = salaExistente?.id ?? _uuid.v1();

      Salas salaParaSalvar = Salas(
        id: idSala,
        nome: nome.trim(),
        especializacao: especializacao.trim(),
        blocoId: blocoId, // Importante para o modelo, mesmo sendo subcoleção
        nomeBloco: nomeBloco, // Denormalizado
        capacidade: capacidade,
        recursos: recursos,
        status: status,
        observacoes: observacoes?.trim(),
        // criadoEm e atualizadoEm são gerenciados pelo serviço
      );

      await _salaService.salvarSala(blocoId, salaParaSalvar); // Chama o serviço

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            salaExistente != null
                ? 'Sala atualizada com sucesso!'
                : 'Sala adicionada com sucesso!',
          ),
          backgroundColor: Colors.green,
        ),
      );
      await refresh(); // Recarrega a lista para mostrar as mudanças
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar sala: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}
