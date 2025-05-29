import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/service/authentication.dart';
import 'package:flutter_application_1/style/colors.dart';

ListTile Navegacao(
  Icon icone,
  String title,
  BuildContext? contexto,
  Widget? tela,
) {
  return ListTile(
    leading: icone,
    iconColor: preto,
    title: Text(
      title,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 15,
        fontWeight: FontWeight.w900,
      ),
    ),
    onTap: () {
      Navigator.push(contexto!, MaterialPageRoute(builder: (context) => tela!));
    },
  );
}

class deslogar extends StatefulWidget {
  const deslogar({super.key});

  @override
  State<deslogar> createState() => _deslogarState();
}

class _deslogarState extends State<deslogar> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        setState(() {
          Authentication().deslogar();
        });
      },
      leading: Icon(Icons.exit_to_app_sharp, size: 25),
      iconColor: preto,
      title: Text(
        "Sair",
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
