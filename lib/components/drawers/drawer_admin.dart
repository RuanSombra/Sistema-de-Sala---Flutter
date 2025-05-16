import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/service/authentication.dart';
import 'package:flutter_application_1/components/drawers/drawer_coodenador.dart';

import '../../style/images.dart';

class DrawerAdmin extends StatefulWidget {
  late User user;
  DrawerAdmin({super.key, required this.user});

  @override
  State<DrawerAdmin> createState() => _DrawerAdminState();
}

class _DrawerAdminState extends State<DrawerAdmin> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: Border.all(color: Colors.black),
      child: ListView(
        padding: EdgeInsets.all(0.8),
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage(IconeProfessor),
            ),
            decoration: BoxDecoration(color: Color(0xFF0145B5)),
            accountName: Text(
              (widget.user.displayName != null) ? widget.user.displayName! : "",
              overflow: TextOverflow.ellipsis,
            ),
            accountEmail: Text(
              widget.user.email!,
              style: TextStylesOcupacao.cargostyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // DrawerHeader(
          //   decoration: BoxDecoration(color: PrimaryColor.color),
          //   child: Container(
          //     padding: EdgeInsets.symmetric(vertical: 30),
          //     child: Row(
          //       children: [
          //         CircleAvatar(
          //           radius: 35,
          //           backgroundImage: AssetImage(
          //             'assets/images/coordenador.png',
          //           ),
          //         ),

          //         SizedBox(height: 20),

          //         Padding(
          //           padding: const EdgeInsets.all(10),
          //           child: SizedBox(
          //             width: 173,
          //             child: Column(
          //               crossAxisAlignment: CrossAxisAlignment.start,
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: [
          //                 Text(
          //                   'Admin',
          //                   style: TextStylesPerfil.perfilstyle,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //                 Text(
          //                   'Administrador',
          //                   style: TextStylesOcupacao.cargostyle,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
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
              setState(() {
                Authentication().deslogar();
              });
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
    );
  }
}
