import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/colors.dart';

void modalReservas(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: branco,
    builder: (BuildContext context) {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;

      return SizedBox(
        width: width,
        height: height,
        child: Padding(
          padding: EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Adicionar reserva",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      "A reserva será das: 07:30 até às 12:30.",
                      style: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Inter',
                        color: cinzaEscuro,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      decoration: InputReservas(
                        "Das:",
                        Icon(Icons.access_time_filled, weight: 1.4),
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.datetime,
                      decoration: InputReservas(
                        "Até:",
                        Icon(Icons.access_time_filled, weight: 1.4),
                      ),
                    ),
                    TextFormField(
                      decoration: InputReservas("Descrição:", null),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: ElevatedButton(
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
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: branco,
                          content: SizedBox(
                            width: 300,
                            height: 80,
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Deseja confirmar sua reserva?",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                  SizedBox(height: 7),
                                  Text(
                                    "Dia 16/05/2025 das 07:30 até às 12:30.",
                                    style: TextStyle(fontSize: 15),
                                    overflow: TextOverflow.clip,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: Text(
                                "Cancelar",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: vermelho,
                                ),
                              ),
                              onPressed: () {},
                            ),
                            TextButton(
                              child: Text(
                                "Confirmar",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: azulEscuro,
                                ),
                              ),
                              onPressed: () {
                                // Aqui é aonde vai salvar de fato a reserva
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
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
