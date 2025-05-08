/* import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/colors.dart';

Card blocos(
  Widget titulo,
  SizedBox? sala,
  SizedBox? sala1,
  SizedBox? sala2,
  SizedBox? sala3,
) {
  return Card(
    color: cinzaClaro,
    shape: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(0),
      borderSide: BorderSide(color: Colors.transparent),
    ),
    child: ExpansionTile(
      title: titulo,
      textColor: branco,
      iconColor: branco,
      backgroundColor: azulEscuro,
      shape: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
      children: [
        SizedBox(child: sala),
        SizedBox(height: 2),
        SizedBox(child: sala1),
        SizedBox(height: 2),
        SizedBox(child: sala2),
        SizedBox(height: 2),
        SizedBox(child: sala3),
      ],
    ),
  );
} */