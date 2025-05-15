import 'package:flutter/material.dart';
import '../../components/reservas/reservaOcupada.dart';
import '../../style/colors.dart';

class Minhasreservas extends StatelessWidget {
  const Minhasreservas({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: branco,
      appBar: AppBar(
        backgroundColor: azulEscuro,
        title: Text(
          "Minhas reservas",
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
                        "Total de reservas: 1/3",
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
              ],
            ),
          ),
        ),
      ),
    );
    ();
  }
}
