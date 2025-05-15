import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/colors.dart';

void modalReservas(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Adicionar reserva",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
              ),
            ),
            SizedBox(height: 5),
            Text(
              "A reserva será das: 07:30 até às 12:30.",
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Inter',
                color: cinzaEscuro,
              ),
            ),
            TextFormField(
              decoration: InputReservas(
                "Das:",
                Icon(Icons.access_time_filled, weight: 1.4),
              ),
            ),
            SizedBox(height: 25),
            TextFormField(
              decoration: InputReservas(
                "Até:",
                Icon(Icons.access_time_filled, weight: 1.4),
              ),
            ),
            SizedBox(height: 25),
            TextFormField(decoration: InputReservas("Descrição:", null)),
            SizedBox(height: 29),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(450, 50),
                backgroundColor: azulEscuro,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              child: Text(
                "Salvar",
                style: TextStyle(
                  color: branco,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                print("Está funcionando!!");
              },
            ),
          ],
        ),
      );
    },
  );
}

InputReservas(String? text, Icon? suffixIcon) {
  return InputDecoration(
    labelText: text,
    labelStyle: TextStyle(
      color: preto,
      fontFamily: 'Inter',
      fontWeight: FontWeight.bold,
    ),
    suffixIcon: suffixIcon,
    suffixIconColor: preto,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: preto, width: 1.2),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: preto, width: 1.2),
    ),
  );
}
