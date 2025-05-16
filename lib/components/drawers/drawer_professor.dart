import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/service/authentication.dart';
import 'package:flutter_application_1/components/drawers/drawer_coodenador.dart';

class DrawerProfessor extends StatefulWidget {
  final User user;
  const DrawerProfessor({super.key, required this.user});

  @override
  State<DrawerProfessor> createState() => _DrawerProfessorState();
}

class _DrawerProfessorState extends State<DrawerProfessor> {
  String? _nome;
  late User _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _carregarUsuarioDoFirestore();
  }

  // Future<void> _carregarUsuarioAtualizado() async {
  //   await _user.reload();
  //   setState(() {
  //     _user = FirebaseAuth.instance.currentUser!;
  //   });
  // }

  Future<void> _carregarUsuarioDoFirestore() async {
    final doc =
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(_user.uid)
            .get();
    if (doc.exists) {
      final data = doc.data();
      setState(() {
        _nome = data?['nome'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: Border.all(color: Colors.black),
      child: ListView(
        padding: const EdgeInsets.all(0.8),
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundImage: AssetImage('assets/images/professor.png'),
            ),
            decoration: const BoxDecoration(color: Color(0xFF0145B5)),
            accountName: Text(
              _user.displayName ?? '',
              overflow: TextOverflow.ellipsis,
            ),
            accountEmail: Text(
              _user.email ?? '',
              style: TextStylesOcupacao.cargostyle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          DrawerHeader(
            decoration: BoxDecoration(color: PrimaryColor.color),
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
                            widget.user.uid,
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
            leading: const Icon(Icons.checklist, size: 25, color: Colors.black),
            title: Text('Reservar Sala', style: TextStylesListTile.listtile),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(
              Icons.person_pin_outlined,
              size: 25,
              color: Colors.black,
            ),
            title: Text('Fila de Espera', style: TextStylesListTile.listtile),
          ),
          ListTile(
            onTap: () {},
            leading: const Icon(Icons.settings, size: 25, color: Colors.black),
            title: Text('Configuração', style: TextStylesListTile.listtile),
          ),
          ListTile(
            onTap: () async {
              final resultado = await Authentication().deslogar();
              if (resultado == null) {
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed('/login');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erro ao sair: $resultado')),
                );
              }
            },
            leading: const Icon(Icons.logout_rounded, color: Colors.black),
            title: Text('Sair', style: TextStylesListTile.listtile),
          ),
        ],
      ),
    );
  }
}
