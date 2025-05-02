import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/drawer_admin.dart';
import 'package:flutter_application_1/components/drawer_coodenador.dart';
import 'package:flutter_application_1/models/reservas.dart';
import 'package:flutter_application_1/style/colors.dart';

class PerfilAdmin extends StatefulWidget {
  const PerfilAdmin({super.key});

  @override
  State<PerfilAdmin> createState() => _PerfilAdminState();
}

class _PerfilAdminState extends State<PerfilAdmin> {
  final List<Reservas> listReservas = [
    Reservas(categoria: "Bloco A", bloco: "A1", id: "001"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/senai.png', height: 25),
        centerTitle: true,
        backgroundColor: azulEscuro,
        iconTheme: IconThemeData(color: Colors.white, size: 30),
      ),
      drawer: DrawerAdmin(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: azulEscuro,
        shape: CircleBorder(),
        onPressed: () {
          showModalSala();
        },
        child: Icon(Icons.add, color: branco),
      ),
      body:
          (listReservas.isEmpty)
              ? Center(
                child: Text(
                  "Nenhuma sala registrada!! \nAdicione a sua primeira sala.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView(
                children: List.generate(listReservas.length, (index) {
                  Reservas model = listReservas[index];
                  return Card(
                    color: Color(0xFF0145B5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    margin: EdgeInsets.all(10),
                    child: ExpansionTile(
                      backgroundColor: azulEscuro,
                      collapsedIconColor: branco,
                      iconColor: branco,
                      title: Text(
                        model.categoria,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          color: Colors.white,
                        ),
                      ),
                      children: [
                        Card(
                          margin: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 9,
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Livre para reservas',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          model.bloco,
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Icon(
                                          Icons.circle,
                                          color: verde,
                                          size: 15,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
    );
  }

  showModalSala() {
    String title = "Adicionar Sala";
    String confirmationButton = "Salvar";
    String skipButton = "Cancelar";

    TextEditingController categoriaController = TextEditingController();
    TextEditingController blocoController = TextEditingController();

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
              TextFormField(
                controller: categoriaController,
                decoration: InputDecoration(label: Text("Categoria do Bloco")),
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
                    onPressed: () {},
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
}
