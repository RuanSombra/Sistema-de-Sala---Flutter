import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/textformfield.dart';
import 'package:flutter_application_1/screens/inicialProfessor.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/images.dart';
import 'perfilProfessor.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  String? _selectedOption;

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
                SizedBox(height: 30),
                SizedBox(
                  width: 270,
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
                      SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedOption,
                        hint: Text('Escolha uma opção'),
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          color: azulEscuro,
                          backgroundColor: branco,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        decoration: formDecoracao(null, null, null),
                        items:
                            [
                              'Coordenador',
                              'Professor(a)',
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedOption = newValue;
                          });
                        },
                        /* validator: (value) {
                        if (value == null) {
                          return 'Por favor, selecione uma opção';
                        }
                        return null;
                      }, 
                      
                      Não está funcionando!! */
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: 303,
                        child: Form(
                          child: Column(
                            children: [
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => telaInicialProfessor(),
                                    ),
                                  );
                                },
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
