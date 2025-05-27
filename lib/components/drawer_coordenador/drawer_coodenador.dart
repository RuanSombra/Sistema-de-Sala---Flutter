import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../authentication/service/authentication.dart';
import '../../style/images.dart';

class DrawerCoodenador extends StatefulWidget {
  final User user;
  const DrawerCoodenador({super.key, required this.user});

  @override
  State<DrawerCoodenador> createState() => _DrawerCoodenadorState();
}

class _DrawerCoodenadorState extends State<DrawerCoodenador> {
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
              widget.user.displayName!,
              style: TextStylesPerfil.perfilstyle,
              overflow: TextOverflow.ellipsis,
            ),
            accountEmail: Text(
              widget.user.email!,
              style: TextStylesOcupacao.cargostyle,
              overflow: TextOverflow.ellipsis,
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

class TextStylesListTile {
  static const TextStyle listtile = TextStyle(
    fontSize: 16,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
  );
}

class TextStylesPerfil {
  static const TextStyle perfilstyle = TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
}

class TextStylesOcupacao {
  static const TextStyle cargostyle = TextStyle(
    fontSize: 12,
    color: Colors.white70,
    fontWeight: FontWeight.bold,
    fontFamily: 'Poppins',
  );
}

class PrimaryColor {
  static const Color color = Color(0xFF0145B5);
}
