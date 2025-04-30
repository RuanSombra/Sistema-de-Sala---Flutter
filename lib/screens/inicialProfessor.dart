import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/textformfield.dart';
import 'package:flutter_application_1/style/colors.dart';
import '../components/drawer_professor.dart';
import '../style/images.dart';

class telaInicialProfessor extends StatelessWidget {
  const telaInicialProfessor({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: branco,
      appBar: AppBar(
        title: Image.asset(LogoSenaiBranco, height: 25),
        centerTitle: true,
        backgroundColor: azulEscuro,
        iconTheme: IconThemeData(color: branco, size: 30),
      ),
      drawer: DrawerProfessor(),
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              children: [
                TextFormField(
                  decoration: formDecoracao(
                    "Pesquisar por salas",
                    null,
                    Icon(Icons.manage_search_sharp),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mais salas: ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),

                Card(
                  color: Color(0xFF0145B5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  margin: EdgeInsets.all(10),
                  child: ExpansionTile(
                    backgroundColor: Color(0xFF0145B5),
                    collapsedIconColor: Colors.white,
                    iconColor: Colors.white,
                    title: Text(
                      'Bloco A: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Inter',
                        color: Colors.white,
                      ),
                    ),
                    children: [
                      Card(
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 9,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Livre para reservas',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'A1',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.circle,
                                        color: Colors.green,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      Card(
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 9,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 25,
                                      backgroundImage: AssetImage(
                                        IconeProfessor,
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Eduardo Almeida',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Técnico em TI',
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 10,
                                              fontWeight: FontWeight.w100,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'A2',
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.circle,
                                        color: Colors.red,
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Mais informações',
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 10,
                                        fontWeight: FontWeight.w100,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
