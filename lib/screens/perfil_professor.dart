import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/reserva_screen.dart';
// Remova TextFormField se não for usado diretamente para pesquisa complexa AGORA
// import 'package:flutter_application_1/components/textformfield.dart';
import 'package:flutter_application_1/style/colors.dart';
import '../components/drawer_professor/drawer_professor.dart';
import '../models/blocos.dart';
import '../models/salas.dart'; // Precisa importar o modelo Salas
// Importe seus SERVIÇOS
import '../service/blocos_service.dart';
import '../service/salas_service.dart';
import '../style/images.dart'; // Suas imagens

class PerfilProfessor extends StatefulWidget {
  final User user;

  const PerfilProfessor({super.key, required this.user});

  @override
  State<PerfilProfessor> createState() => _PerfilProfessorState();
}

class _PerfilProfessorState extends State<PerfilProfessor> {
  List<Blocos> listBlocos = [];
  Map<String, List<Salas>> blocoSalasMap =
      {}; // Para armazenar salas por ID de bloco
  bool isLoading = true; // Para o indicador de carregamento
  String _searchTerm = ""; // Para a pesquisa

  // Instancie seus serviços
  final BlocoService _blocoService = BlocoService();
  final SalaService _salaService = SalaService();

  @override
  void initState() {
    super.initState();
    _fetchData(); // Carrega os dados ao iniciar a tela
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    try {
      List<Blocos> blocosCarregados = await _blocoService.buscarTodosBlocos();
      Map<String, List<Salas>> salasTemporarias = {};

      for (var bloco in blocosCarregados) {
        salasTemporarias[bloco.id] = await _salaService.buscarSalasPorBloco(
          bloco.id,
        );
      }

      if (mounted) {
        setState(() {
          listBlocos = blocosCarregados;
          blocoSalasMap = salasTemporarias;
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

  // Filtra os blocos e salas com base no _searchTerm
  List<Blocos> get _filteredBlocos {
    if (_searchTerm.isEmpty) {
      return listBlocos;
    }
    // Filtra blocos cujo nome contém o termo de busca OU que contêm salas que correspondem
    return listBlocos.where((bloco) {
      final salasDoBloco = blocoSalasMap[bloco.id] ?? [];
      final blocoMatch = bloco.nome.toLowerCase().contains(
        _searchTerm.toLowerCase(),
      );
      final salasMatch = salasDoBloco.any(
        (sala) => sala.nome.toLowerCase().contains(_searchTerm.toLowerCase()),
      );
      return blocoMatch || salasMatch;
    }).toList();
  }

  Map<String, List<Salas>> get _filteredSalasMap {
    if (_searchTerm.isEmpty) {
      return blocoSalasMap;
    }
    Map<String, List<Salas>> filteredMap = {};
    for (var bloco in _filteredBlocos) {
      // Usa os blocos já filtrados
      final salasDoBloco = blocoSalasMap[bloco.id] ?? [];
      filteredMap[bloco.id] =
          salasDoBloco
              .where(
                (sala) =>
                    sala.nome.toLowerCase().contains(
                      _searchTerm.toLowerCase(),
                    ) ||
                    bloco.nome.toLowerCase().contains(
                      _searchTerm.toLowerCase(),
                    ), // Se o bloco deu match, inclui todas as suas salas se a busca não for específica para sala
              )
              .toList();

      // Se o bloco deu match mas nenhuma sala individualmente, mas queremos mostrar o bloco,
      // precisamos garantir que suas salas (mesmo que não filtradas individualmente) apareçam
      // if (bloco.nome.toLowerCase().contains(_searchTerm.toLowerCase()) && filteredMap[bloco.id]!.isEmpty) {
      //    filteredMap[bloco.id] = salasDoBloco;
      // }
    }
    return filteredMap;
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width; // Removido se não usado diretamente
    // double height = MediaQuery.of(context).size.height; // Removido se não usado diretamente

    final blocosParaExibir = _filteredBlocos;
    final salasParaExibirMap = _filteredSalasMap;

    return Scaffold(
      backgroundColor: branco,
      appBar: AppBar(
        title: Image.asset(
          LogoSenaiBranco,
          height: 25,
        ), // Use sua constante de imagem
        centerTitle: true,
        backgroundColor: azulEscuro,
        iconTheme: IconThemeData(color: branco, size: 30),
      ),
      drawer: DrawerProfessor(user: widget.user),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  // Usando InputDecoration diretamente
                  hintText: "Pesquisar por salas, blocos, recursos...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 10.0,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchTerm = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              if (!isLoading &&
                  blocosParaExibir.isEmpty &&
                  _searchTerm.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Text("Nenhum resultado para '$_searchTerm'."),
                  ),
                )
              else if (!isLoading &&
                  listBlocos.isEmpty &&
                  _searchTerm.isEmpty) // Alterado para listBlocos aqui
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Text("Nenhuma sala ou bloco cadastrado no sistema."),
                  ),
                )
              else
                Expanded(
                  // Para a ListView ocupar o espaço restante
                  child:
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ListView.builder(
                            itemCount: blocosParaExibir.length,
                            itemBuilder: (context, index) {
                              Blocos bloco = blocosParaExibir[index];
                              List<Salas> salasDoBloco =
                                  salasParaExibirMap[bloco.id] ?? [];
                              // Se o bloco foi filtrado pelo nome, mas nenhuma sala individualmente, mostramos todas as salas dele
                              if (_searchTerm.isNotEmpty &&
                                  bloco.nome.toLowerCase().contains(
                                    _searchTerm.toLowerCase(),
                                  ) &&
                                  salasDoBloco.every(
                                    (s) =>
                                        !(s.nome.toLowerCase().contains(
                                          _searchTerm.toLowerCase(),
                                        )),
                                  )) {
                                salasDoBloco = blocoSalasMap[bloco.id] ?? [];
                              }

                              if (_searchTerm.isNotEmpty &&
                                  salasDoBloco.isEmpty &&
                                  !bloco.nome.toLowerCase().contains(
                                    _searchTerm.toLowerCase(),
                                  )) {
                                return Container(); // Não mostra o bloco se nenhuma sala dele corresponde à pesquisa E o nome do bloco também não
                              }

                              return Card(
                                color: Color(0xFF0145B5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: ExpansionTile(
                                  backgroundColor: Color(0xFF0145B5),
                                  collapsedIconColor: Colors.white,
                                  iconColor: Colors.white,
                                  title: Text(
                                    bloco.nome,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Inter',
                                      color: Colors.white,
                                    ),
                                  ),
                                  subtitle: Text(
                                    '${salasDoBloco.length} sala(s) ${_searchTerm.isNotEmpty && salasDoBloco.isNotEmpty ? "encontrada(s)" : "disponível(is)"}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Inter',
                                      color: Colors.white70,
                                    ),
                                  ),
                                  children:
                                      salasDoBloco
                                          .map(
                                            (sala) =>
                                                _buildSalaCard(sala, bloco),
                                          )
                                          .toList(),
                                ),
                              );
                            },
                          ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSalaCard(Salas sala, Blocos bloco) {
    // Card para exibir informações da sala
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      color: Colors.white,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: azulEscuro.withOpacity(0.2),
          child: Icon(Icons.meeting_room_outlined, color: azulEscuro),
        ),
        title: Text(
          sala.nome,
          style: TextStyle(fontWeight: FontWeight.bold, color: azulEscuro),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Bloco: ${bloco.nome}",
            ), // Usa nomeBloco denormalizado da sala, ou nome do bloco
            Text("Capacidade: ${sala.capacidade}"),

            Text(
              "Status: ${sala.status}",
              style: TextStyle(
                color:
                    sala.status == 'disponivel'
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed:
              sala.status == 'disponivel'
                  ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                ReservaScreen(sala: sala, bloco: bloco),
                      ),
                    );
                  }
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: azulEscuro,
            foregroundColor: branco,
          ),
          child: const Text('Reservar'),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
      ),
    );
  }
}
