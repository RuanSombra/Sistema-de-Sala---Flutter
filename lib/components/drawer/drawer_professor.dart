import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/drawer/drawer_coodenador.dart';
import 'package:flutter_application_1/components/navegacao.dart';
import 'package:flutter_application_1/screens/configuracoes/configuracoes.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/configuracoes/meuPerfil.dart';
import 'package:flutter_application_1/screens/professor/filasProfessor.dart';
import 'package:flutter_application_1/screens/professor/minhasReservas.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/drawerTexts.dart';
import 'package:flutter_application_1/style/images.dart';

class DrawerProfessor extends StatefulWidget {
  const DrawerProfessor({super.key});

  @override
  State<DrawerProfessor> createState() => _DrawerProfessorState();
}

class _DrawerProfessorState extends State<DrawerProfessor> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: branco,
      width: 250,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: ListView(
        padding: EdgeInsets.all(0),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: azulEscuro,
              border: Border.all(width: 0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Container(
              width: 240,
              child: GestureDetector(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(FotoProfessor),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Eduardo Almeida',
                            style: TextStyleUsuario.usuario,
                            overflow: TextOverflow.ellipsis,
                          ), //FEITO PELO SISTEMA DO SENAI - NÃO SUJEITO A ALTERAÇÕES
                          Text(
                            'Técnico em TI',
                            style: TextStyleCargo.cargo,
                            overflow: TextOverflow.ellipsis,
                          ), //FEITO PELO SISTEMA DO SENAI - NÃO SUJEITO A ALTERAÇÕES
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Meuperfil()),
                  );
                },
              ),
            ),
          ),
          Navegacao(
            Icon(Icons.checklist_outlined, size: 25),
            "Minhas reservas",
            context,
            Minhasreservas(),
          ),
          Navegacao(
            Icon(Icons.person_add_alt_1_sharp, size: 25),
            "Fila de espera",
            context,
            Filasprofessor(),
          ),
          Navegacao(
            Icon(Icons.settings, size: 25),
            "Configurações",
            context,
            Configuracoes(),
          ),
          Navegacao(
            Icon(Icons.exit_to_app_sharp, size: 25),
            "Sair",
            context,
            TelaLogin(),
          ),
        ],
      ),
    );
  }
}
