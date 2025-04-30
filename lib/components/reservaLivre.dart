import 'package:flutter/material.dart';
import 'package:flutter_application_1/style/colors.dart';

class Reservalivre extends StatelessWidget {
  const Reservalivre({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: preto,
      body: SizedBox(
        width: 320,
        height: 70,
        child: Card(
          child: SizedBox(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 25),
                GestureDetector(
                  child: Text(
                    "Livre para reservas.",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      decoration: TextDecoration.underline,
                      decorationColor: preto,
                    ),
                  ),
                  onTap: () {
                    print("Está funcionando!");
                  },
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 2),
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
                        Icon(Icons.circle, size: 15, color: Colors.green),
                      ],
                    ),
                    /* Text("Mais Informações"), */
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
