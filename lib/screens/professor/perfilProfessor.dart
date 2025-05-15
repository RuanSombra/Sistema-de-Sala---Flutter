import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/textformfield.dart';
import 'package:flutter_application_1/style/colors.dart';
import '../../components/drawer/drawer_professor.dart';
/* import '../components/blocos.dart';
import '../components/reservas/reservaLivre.dart';
import '../components/reservas/reservaOcupada.dart'; */
import '../../style/images.dart';

class PerfilProfessor extends StatelessWidget {
  const PerfilProfessor({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: branco,
      appBar: AppBar(
        title: Image.asset(LogoSenaiBranco, height: 25),
        centerTitle: true,
        backgroundColor: azulEscuro,
        iconTheme: IconThemeData(color: branco, size: 30),
      ),
      drawer: DrawerProfessor(),
      body: SizedBox(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              children: [
                TextFormField(
                  decoration: formDecoracao(
                    "Pesquisar por salas",
                    null,
                    Icon(Icons.manage_search_sharp),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mais salas: ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                /* blocos(
                  Text(
                    "Bloco A",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(child: Reservalivre()),
                  SizedBox(child: Reservaocupada()),
                  null,
                  null,
                ),
                blocos(
                  Text(
                    "Bloco B",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(child: Reservalivre()),
                  SizedBox(child: Reservalivre()),
                  SizedBox(child: Reservaocupada()),
                  null,
                ),
                blocos(
                  Text(
                    "Bloco C",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(child: Reservaocupada()),
                  SizedBox(child: Reservaocupada()),
                  SizedBox(child: Reservaocupada()),
                  SizedBox(child: Reservalivre()),
                ), */
              ],
            ),
          ),
        ),
      ),
    );
  }
}
