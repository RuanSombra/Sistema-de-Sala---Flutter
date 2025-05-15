import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/drawers/drawer_admin.dart';
import 'package:flutter_application_1/models/blocos.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:uuid/uuid.dart';

class PerfilAdmin extends StatefulWidget {
  final User user;
  const PerfilAdmin({super.key, required this.user});

  @override
  State<PerfilAdmin> createState() => _PerfilAdminState();
}

class _PerfilAdminState extends State<PerfilAdmin> {
  List<Blocos> listBlocos = [];
  bool customTileExpanded = false;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/senai.png', height: 25),
        centerTitle: true,
        backgroundColor: azulEscuro,
        iconTheme: IconThemeData(color: Colors.white, size: 30),
      ),
      drawer: DrawerAdmin(user: widget.user),
      floatingActionButton: FloatingActionButton(
        backgroundColor: azulEscuro,
        shape: CircleBorder(),
        onPressed: () {
          showModalSala();
        },
        child: Icon(Icons.add, color: branco),
      ),
      body:
          (listBlocos.isEmpty)
              ? Center(
                child: Text(
                  "Nenhuma sala registrada!! \nAdicione a sua primeira sala.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              )
              : RefreshIndicator(
                onRefresh: () {
                  return refresh();
                },
                child: ListView(
                  children: List.generate(listBlocos.length, (index) {
                    Blocos model = listBlocos[index];
                    return Card(
                      color: Color(0xFF0145B5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      margin: EdgeInsets.all(10),
                      child: ExpansionTile(
                        onExpansionChanged: (bool expanded) {
                          setState(() {
                            customTileExpanded = expanded;
                          });
                        },
                        backgroundColor: azulEscuro,
                        collapsedIconColor: branco,
                        iconColor: branco,
                        title: Text(
                          model.nome,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.white,
                          ),
                        ),
                        children: [
                          Dismissible(
                            key: ValueKey<Blocos>(model),
                            onDismissed: (direction) {
                              remove(model);
                            },
                            child: GestureDetector(
                              onTap: () {
                                showModalSala(model: model);
                              },
                              child: Card(
                                margin: EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 9,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Livre para reservas',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      // Column(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.start,
                                      //   children: [
                                      //     Row(
                                      //       children: [
                                      //         Text(
                                      //           model.sala,
                                      //           style: TextStyle(
                                      //             fontFamily: 'Inter',
                                      //             fontSize: 10,
                                      //             fontWeight: FontWeight.bold,
                                      //           ),
                                      //         ),
                                      //         Icon(
                                      //           Icons.circle,
                                      //           color: verde,
                                      //           size: 15,
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
    );
  }

  showModalSala({Blocos? model}) {
    // Labels à serem mostradas no Modal
    String title = "Adicionar Bloco";
    String confirmationButton = "Salvar";
    String skipButton = "Cancelar";

    // Controlador do campo que receberá o nome
    TextEditingController blocoController = TextEditingController();

    // Caso esteja editando
    if (model != null) {
      title = "Editando ${model.nome}";
      blocoController.text = model.nome;
    }

    // Função do Flutter que mostra o modal na tela
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.all(32.0),

          child: ListView(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              TextFormField(
                controller: blocoController,
                decoration: InputDecoration(label: Text("Bloco da Sala")),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(skipButton),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Criar um objeto Reservas com as infos
                      Blocos blocos = Blocos(
                        id: Uuid().v1(),
                        nome: blocoController.text,
                      );

                      // Usar o ID do model
                      if (model != null) {
                        blocos.id = model.id;
                      }

                      // Atualizar as Reservas
                      refresh();

                      // Salvar no Firestore
                      firestore
                          .collection("reservas")
                          .doc(blocos.id)
                          .set(blocos.toMap());

                      // Fechar o modal
                      Navigator.pop(context);
                    },
                    child: Text(confirmationButton),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  refresh() async {
    List<Blocos> temp = [];
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection("reservas").get();

    for (var doc in snapshot.docs) {
      temp.add(Blocos.fromMap(doc.data()));
    }

    setState(() {
      listBlocos = temp;
    });
  }

  void remove(Blocos model) {
    firestore.collection("reservas").doc(model.id).delete();
  }
}
