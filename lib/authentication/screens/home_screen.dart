import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/service/auth_service.dart';
import 'package:flutter_application_1/screens/perfil_admin.dart';
import 'package:flutter_application_1/screens/perfil_coordenador.dart';
import 'package:flutter_application_1/screens/perfil_professor.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  Widget? getPagina(String tipo, User user) {
    final map = {
      'Admin': PerfilAdmin(user: user),
      'Coordenador': PerfilCoordenador(user: user),
      'Professor(a)': PerfilProfessor(user: user),
    };

    return map[tipo];
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return FutureBuilder<String?>(
      future: authService.searchTypeUser(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Scaffold(
            body: Center(child: Text('Erro ao carregar tipo de usuário.')),
          );
        }

        final tipo = snapshot.data!;
        final nextPage = getPagina(tipo, user);

        if (nextPage == null) {
          return Scaffold(
            body: Center(child: Text('Tipo de usuário inválido: $tipo')),
          );
        }

        // Redireciona para a tela correta (substitui a atual)
        Future.microtask(() {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => nextPage));
        });

        return Scaffold(body: Center(child: Text('Redirecionando...')));
      },
    );
  }
}
