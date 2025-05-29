/* O QUE ERA ANTES
obs: atencao ao mudar a funcionalidade de deslogar

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
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/screens/register_screen.dart';
import 'package:flutter_application_1/components/drawer_professor/components/config/config.dart';
import 'package:flutter_application_1/components/drawer_professor/components/minhas_reservas.dart';
import 'package:flutter_application_1/screens/gerenciar_solicitacoes.dart';
import '../../authentication/service/authentication.dart';
import '../../style/colors.dart';
import '../drawer_professor/drawer_professor.dart';

class DrawerCoodenador extends StatefulWidget {
  final User user;
  const DrawerCoodenador({super.key, required this.user});

  @override
  State<DrawerCoodenador> createState() => _DrawerCoodenadorState();
}

class _DrawerCoodenadorState extends State<DrawerCoodenador> {
  String? _nomeUsuarioFirestore; // Renomeado para clareza
  String? _cargoUsuarioFirestore; // Para exibir o cargo também, se desejar
  late User _userAuth; // Usuário do Firebase Auth

  bool _isLoadingProfile = true; // Para feedback de carregamento

  @override
  void initState() {
    super.initState();
    _userAuth = widget.user;
    _carregarDadosDoFirestore();
  }

  Future<void> _carregarDadosDoFirestore() async {
    if (!mounted) return;
    setState(() {
      _isLoadingProfile = true;
    });
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection(
                'usuarios',
              ) // Certifique-se que 'usuarios' é o nome correto da sua coleção
              .doc(_userAuth.uid)
              .get();

      if (doc.exists) {
        final data = doc.data();
        if (mounted) {
          setState(() {
            _nomeUsuarioFirestore =
                data?['nome'] as String? ??
                _userAuth.displayName ??
                'Nome não encontrado';
            _cargoUsuarioFirestore =
                data?['cargo'] as String? ??
                'Cargo não informado'; // Exemplo, se tiver 'cargo'
            _isLoadingProfile = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            // Se não encontrar no Firestore, tenta usar o displayName do Auth
            // ou um placeholder
            _nomeUsuarioFirestore = _userAuth.displayName ?? 'Usuário';
            _cargoUsuarioFirestore = 'Informação não disponível';
            _isLoadingProfile = false;
          });
        }
        print(
          "Documento do usuário não encontrado no Firestore para UID: ${_userAuth.uid}",
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingProfile = false;
          _nomeUsuarioFirestore =
              _userAuth.displayName ?? 'Erro ao carregar nome';
          _cargoUsuarioFirestore = 'Erro';
        });
      }
      print("Erro ao carregar dados do usuário do Firestore: $e");
    }
  }

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/images/professor.png'),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _isLoadingProfile
                          ? const Text(
                            "Carregando...",
                            style: TextStyle(color: Colors.white70),
                          )
                          : Text(
                            _nomeUsuarioFirestore ??
                                _userAuth.displayName ??
                                'Nome do Professor', // Usa o nome do Firestore
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                      SizedBox(width: 40),
                      Text(
                        _isLoadingProfile ? "" : (_cargoUsuarioFirestore ?? ''),
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context); // Fecha o drawer
              // Se a tela atual já é PerfilProfessor, não faz nada ou recarrega
              // Se não, Navigator.pushReplacementNamed(context, '/perfilProfessor');
            },
            leading: const Icon(
              Icons.home_work_outlined,
              size: 25,
              color: Colors.black,
            ),
            title: Text(
              'Salas Disponíveis',
              style: TextStylesListTile.listtile,
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegisterScreen()),
              );
            },
            leading: const Icon(
              Icons.supervised_user_circle,
              size: 25,
              color: Colors.black,
            ),
            title: Text(
              'Cadastrar Usuário',
              style: TextStylesListTile.listtile,
            ),
          ),

          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          GerenciarReservasCoordenadorScreen(user: _userAuth),
                ),
              );
            },
            leading: Icon(Icons.gesture, size: 25, color: Colors.black),
            title: Text(
              'Gerenciar Solicitações',
              style: TextStylesListTile.listtile,
            ),
          ),

          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Minhasreservas()),
              );
              // TODO: Navegar para a tela de Minhas Reservas
              // Navigator.pushNamed(context, '/minhasReservas');
            },
            leading: const Icon(
              Icons.checklist_rtl_outlined,
              size: 25,
              color: Colors.black,
            ),
            title: Text('Minhas Reservas', style: TextStylesListTile.listtile),
          ),
          const Divider(),
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Configuracoes()),
              );
              // TODO: Navegar para Configurações
              // Navigator.pushNamed(context, '/configuracoes');
            },
            leading: const Icon(
              Icons.settings_outlined,
              size: 25,
              color: Colors.black,
            ),
            title: Text('Configurações', style: TextStylesListTile.listtile),
          ),
          ListTile(
            onTap: () async {
              Navigator.pop(context); // Fecha o drawer antes de deslogar
              final resultado = await Authentication().deslogar();
              if (resultado == null) {
                // Não precisa do if(!mounted) aqui se o pop já foi chamado
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false,
                );
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Erro ao sair: $resultado'),
                    backgroundColor: Colors.red,
                  ),
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
