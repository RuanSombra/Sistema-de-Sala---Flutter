import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/colors.dart';

ListTile Navegacao(
  Icon icone,
  String title,
  BuildContext contexto,
  Widget tela,
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
      Navigator.push(contexto, MaterialPageRoute(builder: (context) => tela));
    },
  );
}
