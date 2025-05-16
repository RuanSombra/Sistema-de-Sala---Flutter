import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/service/authentication.dart';
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
    final Authentication authService = Authentication();

    return FutureBuilder<String?>(
      future: authService.buscarTipoUsuario(user.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
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

        // Redireciona após o frame atual ser concluído
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => nextPage));
        });

        return const Scaffold(body: Center(child: Text('Redirecionando...')));
      },
    );
  }
}
