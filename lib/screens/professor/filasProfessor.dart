import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/reservas/reservaOcupada.dart';
import 'package:flutter_application_1/style/colors.dart';

class Filasprofessor extends StatefulWidget {
  const Filasprofessor({super.key});

  @override
  State<Filasprofessor> createState() => _FilasprofessorState();
}

class _FilasprofessorState extends State<Filasprofessor> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: branco,
      appBar: AppBar(
        backgroundColor: azulEscuro,
        title: Text(
          "Fila de espera",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: branco,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),

      body: Container(
        width: width,
        height: height,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 13),
                      child: Text(
                        "Aguardando na fila:",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter',
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                Reservaocupada(),
                Reservaocupada(),
                Reservaocupada(),
                Reservaocupada(),
                Reservaocupada(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
