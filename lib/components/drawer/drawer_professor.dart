import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/drawer/drawer_coodenador.dart';
import 'package:flutter_application_1/screens/login.dart';


class DrawerProfessor extends StatefulWidget {
  const DrawerProfessor({super.key});

  @override
  State<DrawerProfessor> createState() => _DrawerProfessorState();
}

class _DrawerProfessorState extends State<DrawerProfessor> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: Border.all(color: Colors.black),
      child: ListView(
        padding: EdgeInsets.all(0.8),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0145B5)),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage('assets/images/professor.png'),
                  ),

                  SizedBox(width: 20),

                  SizedBox(
                    width: 173,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Eduardo Almeida',
                          style: TextStylesPerfil.perfilstyle,
                        ), //FEITO PELO SISTEMA DO SENAI - NÃO SUJEITO A ALTERAÇÕES
                        Text(
                          'Técnico em Eletroeletronica',
                          style: TextStylesOcupacao.cargostyle,
                          overflow: TextOverflow.ellipsis,
                        ), //FEITO PELO SISTEMA DO SENAI - NÃO SUJEITO A ALTERAÇÕES
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.checklist,
              size: 25,
              color: Colors.black,
              semanticLabel: 'Reserva Sala',
            ),
            title: Text('Reservar Sala', style: TextStylesListTile.listtile),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.person_pin_outlined,
              size: 25,
              color: Colors.black,
              semanticLabel: 'Fila de Espera',
            ),
            title: Text('Fila de Espera', style: TextStylesListTile.listtile),
          ),
          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.settings,
              size: 25,
              color: Colors.black,
              semanticLabel: 'Configuração',
            ),
            title: Text('Configuração', style: TextStylesListTile.listtile),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaLogin()),
              );
            },
            leading: Icon(
              Icons.logout_rounded,
              color: Colors.black,
              semanticLabel: 'Sair',
            ),
            title: Text('Sair', style: TextStylesListTile.listtile),
          ),
        ],
      ),
    );
  }
}
