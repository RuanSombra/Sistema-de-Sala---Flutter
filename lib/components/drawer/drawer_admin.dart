import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/drawer/drawer_coodenador.dart';
import 'package:flutter_application_1/screens/login.dart';
import '../../screens/configuracoes/configuracoes.dart';
import '../../screens/configuracoes/meuPerfil.dart';
import '../../screens/professor/filasProfessor.dart';
import '../../screens/professor/minhasReservas.dart';
import '../../style/colors.dart';
import '../../style/drawerTexts.dart';
import '../../style/images.dart';
import '../navegacao.dart';

class DrawerAdmin extends StatefulWidget {
  const DrawerAdmin({super.key});

  @override
  State<DrawerAdmin> createState() => _DrawerAdminState();
}

class _DrawerAdminState extends State<DrawerAdmin> {
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
                      backgroundImage: AssetImage(Perfil),
                    ),
                    SizedBox(width: 8),
                    SizedBox(
                      width: 150,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Lorem Ipsum',
                            style: TextStyleUsuario.usuario,
                            overflow: TextOverflow.ellipsis,
                          ), //FEITO PELO SISTEMA DO SENAI - NÃO SUJEITO A ALTERAÇÕES
                          Text(
                            'Administrador',
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
            "Reservas",
            context,
            Minhasreservas(),
          ),
          Navegacao(
            Icon(Icons.person_add_alt_1_sharp, size: 25),
            "Filas de espera",
            context,
            Filasprofessor(),
          ),
          Navegacao(
            Icon(Icons.notification_add, size: 25),
            "Notificações",
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

/* Drawer(
      shape: Border.all(color: Colors.black),
      child: ListView(
        padding: EdgeInsets.all(0.8),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: az),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: AssetImage(
                      'assets/images/coordenador.png',
                    ),
                  ),

                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SizedBox(
                      width: 173,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Admin',
                            style: TextStylesPerfil.perfilstyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Administrador',
                            style: TextStylesOcupacao.cargostyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
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
              semanticLabel: 'Reservas',
            ),
            title: Text('Reservas', style: TextStylesListTile.listtile),
          ),

          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.format_line_spacing_outlined,
              size: 25,
              color: Colors.black,
              semanticLabel: 'Fila de Espera',
            ),
            title: Text('Fila de Espera', style: TextStylesListTile.listtile),
          ),

          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.notification_add,
              size: 25,
              color: Colors.black,
              semanticLabel: 'Notificações',
            ),
            title: Text('Notificações', style: TextStylesListTile.listtile),
          ),

          ListTile(
            onTap: () {},
            leading: Icon(
              Icons.settings,
              size: 25,
              color: Colors.black,
              semanticLabel: 'Configurações',
            ),
            title: Text('Configurações', style: TextStylesListTile.listtile),
          ),

          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TelaLogin()),
              );
            },
            leading: Icon(
              Icons.logout,
              size: 25,
              color: Colors.black,
              semanticLabel: 'Sair',
            ),
            title: Text('Sair', style: TextStylesListTile.listtile),
          ),
        ],
      ),
    ); */
