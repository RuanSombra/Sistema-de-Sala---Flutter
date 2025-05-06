import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/images.dart';

class Reservaocupada extends StatelessWidget {
  const Reservaocupada({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 370,
      height: 70,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(Perfil),
                    ),
                    SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Lorem ipsum",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text("Lorem ipsum", style: TextStyle(fontSize: 11)),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "A1",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.circle, size: 15, color: vermelho),
                      ],
                    ),
                    GestureDetector(
                      child: Text(
                        "Mais Informações",
                        style: TextStyle(
                          fontSize: 12,
                          color: cinzaEscuro,
                          decoration: TextDecoration.underline,
                          decorationColor: cinzaEscuro,
                        ),
                      ),
                      onTap: () {
                        print("Está funcionando!");
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
