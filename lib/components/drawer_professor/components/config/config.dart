import 'package:flutter/material.dart';

import '../../../../style/colors.dart';
import '../../../navegacao.dart';
import '../meu_perfil.dart';
import 'acessibilidade.dart';
import 'tema.dart';

class Configuracoes extends StatelessWidget {
  const Configuracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: branco),
        backgroundColor: azulEscuro,
        title: Text(
          "Configurações",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: branco,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Navegacao(
            Icon(Icons.account_circle_rounded, size: 28),
            "Conta",
            context,
            Meuperfil(),
          ),
          Navegacao(Icon(Icons.light_mode, size: 28), "Tema", context, Tema()),
          Navegacao(
            Icon(Icons.more_horiz, size: 28),
            "Acessibilidade",
            context,
            Acessibilidade(),
          ),
          Navegacao(
            Icon(Icons.storage, size: 28),
            "Armazenamento de dados",
            context,
            Acessibilidade(),
          ),
          Navegacao(
            Icon(Icons.contact_page, size: 28),
            "Permissões do aplicativo",
            context,
            Acessibilidade(),
          ),
          Navegacao(
            Icon(Icons.policy, size: 28),
            "Termos e política de uso",
            context,
            Acessibilidade(),
          ),
        ],
      ),
    );
  }
}
