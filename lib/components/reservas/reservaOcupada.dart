import 'package:flutter/material.dart';
import 'package:path/path.dart';
import '../../style/colors.dart';
import '../../style/images.dart';

class Reservaocupada extends StatefulWidget {
  const Reservaocupada({super.key});

  @override
  State<Reservaocupada> createState() => _ReservaocupadaState();
}

class _ReservaocupadaState extends State<Reservaocupada> {
  bool _pressed = false;

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
                        // Sessão 'Mais informações'
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: branco,
                              content: SizedBox(
                                width: 300,
                                height: 190,
                                child: StatefulBuilder(
                                  builder: (context, setState) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              width: 135,
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 22,
                                                    backgroundImage: AssetImage(
                                                      Perfil,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Lorem ipsum",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13,
                                                        ),
                                                      ),
                                                      Text(
                                                        "Lorem ipsum",
                                                        style: TextStyle(
                                                          fontSize: 11,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(width: 90),
                                            Text(
                                              "Sala A1",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 20),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "07:30 às 12:30",
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 390,
                                              child: Text(
                                                "Descrição: Sala reservada para a turma de excel avançado.",
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            minimumSize: Size(257, 40),
                                            backgroundColor:
                                                _pressed ? verde : azulEscuro,
                                          ),
                                          child: Text(
                                            _pressed
                                                ? "Na fila"
                                                : "Entrar na fila de espera",
                                            style: TextStyle(
                                              color: _pressed ? preto : branco,
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _pressed = !_pressed;
                                            });
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        );
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
