import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/textformfield.dart';
import 'package:flutter_application_1/screens/perfilAdmin.dart';
import 'package:flutter_application_1/screens/perfilCoordenador.dart';
import 'package:flutter_application_1/screens/perfilProfessor.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/images.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  String? _selectedOption;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Para identificar o tamanho da tela do dispositivo
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: branco,
      body: SingleChildScrollView(
        // Adicionei todos os elementos no sizedbox para ficar responsivo
        child: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: EdgeInsets.all(36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(LogoSenaiPreto),
                SizedBox(height: 20),
                SizedBox(
                  width: 300,
                  child: Text(
                    'Bem-vindo ao aplicativo de reservas de salas do Senai-MA.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: preto,
                      fontSize: 22,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                SizedBox(
                  width: 270,
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      SizedBox(
                        width: 303,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Text(
                                'Como deseja entrar?',
                                style: TextStyle(
                                  color: azulEscuro,
                                  fontFamily: 'Poppins',
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                value: _selectedOption,
                                hint: Text('Selecione uma opção'),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w700,
                                  color: azulEscuro,
                                  backgroundColor: branco,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                decoration: formDecoracao(null, null, null),
                                items:
                                    [
                                      'Admin',
                                      'Coordenador',
                                      'Professor(a)',
                                    ].map<DropdownMenuItem<String>>((
                                      String value,
                                    ) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedOption = newValue!;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, escolha uma opção.';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email: ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, insira um email';
                                      }
                                      if (!value.endsWith('.senai.br')) {
                                        return 'Por favor, insira um email válido do Senai';
                                      }
                                      return null;
                                    },
                                    /* validator: (String? text) {
                                    if (text?.isEmpty ?? false) {
                                      return null;
                                    } if(text?.endsWith('.senai.br') ?? false){
                                      return null;
                                    }
                                        return 'Por favor, adicione um email válido.';
                                  },
                                  
                                  Não está funcionando! */
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: formDecoracao(
                                      "Insira seu email senai.",
                                      Icon(Icons.person_2),
                                      null,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Senha: ',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Por favor, digite uma senha!!';
                                      }
                                      return null;
                                    },
                                    controller: senhaController,
                                    decoration: formDecoracao(
                                      "Insira sua senha.",
                                      Icon(Icons.remove_red_eye),
                                      null,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(303, 59),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  backgroundColor: azulEscuro,
                                ),
                                child: Text(
                                  'Entrar na conta',
                                  style: TextStyle(
                                    fontSize: 16,
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w500,
                                    color: branco,
                                  ),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Login Concluído'),
                                      ),
                                    );

                                    // Realizando a navegação com base na opção selecionada
                                    Widget nextPage;

                                    if (_selectedOption == "Coordenador") {
                                      nextPage = PerfilCoordenador();
                                    } else if (_selectedOption ==
                                        "Professor(a)") {
                                      nextPage = PerfilProfessor();
                                    } else {
                                      nextPage = PerfilAdmin();
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => nextPage,
                                      ),
                                    );
                                  }
                                },
                                // onPressed: () {
                                //   if (_formKey.currentState!.validate()) {
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(
                                //         content: Text('Login Concluído'),
                                //       ),
                                //     );

                                //     setState(() {
                                //       Navigator.push(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (context) {
                                //             if (_selectedOption ==
                                //                 "Coordenador") {
                                //               Navigator.push(
                                //                 context,
                                //                 MaterialPageRoute(
                                //                   builder:
                                //                       (context) =>
                                //                           PerfilCoordenador(),
                                //                 ),
                                //               );
                                //               if (_selectedOption ==
                                //                   "Professor") {
                                //                 Navigator.push(
                                //                   context,
                                //                   MaterialPageRoute(
                                //                     builder:
                                //                         (context) =>
                                //                             PerfilProfessor(),
                                //                   ),
                                //                 );
                                //               }
                                //             } else {
                                //               Navigator.push(
                                //                 context,
                                //                 MaterialPageRoute(
                                //                   builder:
                                //                       (context) =>
                                //                           PerfilAdmin(),
                                //                 ),
                                //               );
                                //             }
                                //           },
                                //         ),
                                //       );
                                //     });
                                //   }
                                // },
                              ),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  GestureDetector(
                                    child: Text(
                                      "Esqueceu sua senha?",
                                      style: TextStyle(
                                        color: azulEscuro,
                                        decoration: TextDecoration.underline,
                                        decorationColor: azulEscuro,
                                      ),
                                    ),
                                    onTap: () {
                                      print("Está funcionando corretamente!!");
                                    },
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
