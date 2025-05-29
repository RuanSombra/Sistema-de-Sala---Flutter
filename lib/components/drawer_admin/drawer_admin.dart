import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/service/authentication.dart';

import '../../style/colors.dart';
import '../drawer_professor/drawer_professor.dart';

class DrawerAdmin extends StatefulWidget {
  final User user;
  const DrawerAdmin({super.key, required this.user});

  @override
  State<DrawerAdmin> createState() => _DrawerAdminState();
}

class _DrawerAdminState extends State<DrawerAdmin> {
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
      shape: Border.all(color: Colors.black),
      child: ListView(
        padding: EdgeInsets.all(0.8),
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: azulEscuro,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 3,
                  offset: Offset(0, 3),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/images/coordenador.png'),
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
                                'Nome do Admin', // Usa o nome do Firestore
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
              Navigator.pop(context);
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
              Navigator.pop(context);
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

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/authentication/screens/login_screen.dart';
// import 'package:flutter_application_1/components/drawer_professor/components/config/config.dart';
// import 'package:flutter_application_1/components/drawer_professor/components/meu_perfil.dart';
// import 'package:flutter_application_1/components/drawer_professor/components/minhas_reservas.dart';
// import 'package:flutter_application_1/style/drawer_text.dart';
// import '../../style/colors.dart';
// import '../navegacao.dart';

// class DrawerAdmin extends StatefulWidget {
//   late User user;
//   DrawerAdmin({super.key, required this.user});

//   @override
//   State<DrawerAdmin> createState() => _DrawerAdminState();
// }

// class _DrawerAdminState extends State<DrawerAdmin> {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       backgroundColor: branco,
//       width: 250,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//       child: ListView(
//         padding: EdgeInsets.all(0),
//         children: [
//           DrawerHeader(
//             decoration: BoxDecoration(
//               color: azulEscuro,
//               border: Border.all(width: 0),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 6,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Container(
//               width: 240,
//               child: GestureDetector(
//                 child: Row(
//                   children: [
//                     UserAccountsDrawerHeader(
//                       currentAccountPicture: CircleAvatar(
//                         radius: 30,
//                         backgroundImage: AssetImage(
//                           'assets/images/professor.png',
//                         ),
//                       ),
//                       accountName: Text(
//                         (widget.user.displayName != null)
//                             ? widget.user.displayName!
//                             : "",
//                         style: TextStyleUsuario.usuario,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       accountEmail: Text(
//                         widget.user.email!,
//                         style: TextStyleCargo.cargo,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                     ),
//                     /* COMO ESTAVA ANTES

//                     SizedBox(width: 8),
//                     SizedBox(
//                       width: 150,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             'Lorem Ipsum',
//                             style: TextStyleUsuario.usuario,
//                             overflow: TextOverflow.ellipsis,
//                           ), //FEITO PELO SISTEMA DO SENAI - NÃO SUJEITO A ALTERAÇÕES
//                           Text(
//                             'Administrador',
//                             style: TextStyleCargo.cargo,
//                             overflow: TextOverflow.ellipsis,
//                           ), //FEITO PELO SISTEMA DO SENAI - NÃO SUJEITO A ALTERAÇÕES
//                         ],
//                       ),
//                     ), */
//                   ],
//                 ),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => Meuperfil()),
//                   );
//                 },
//               ),
//             ),
//           ),
//           Navegacao(
//             Icon(Icons.checklist_outlined, size: 25),
//             "Reservas",
//             context,
//             Minhasreservas(),
//           ),
//           Navegacao(
//             Icon(Icons.person_add_alt_1_sharp, size: 25),
//             "Filas de espera",
//             context,
//             null,
//           ),
//           Navegacao(
//             Icon(Icons.notification_add, size: 25),
//             "Notificações",
//             context,
//             null,
//           ),
//           Navegacao(
//             Icon(Icons.settings, size: 25),
//             "Configurações",
//             context,
//             Configuracoes(),
//           ),
//           Navegacao(
//             Icon(Icons.exit_to_app_sharp, size: 25),
//             "Sair",
//             context,
//             LoginScreen(),
//           ),
//         ],
//       ),
//     );
//   }
// }
