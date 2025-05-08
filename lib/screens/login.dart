import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/textformfield.dart';
import 'package:flutter_application_1/screens/cadastro.dart';
import 'package:flutter_application_1/screens/perfilAdmin.dart';
import 'package:flutter_application_1/screens/perfilCoordenador.dart';
import 'package:flutter_application_1/screens/perfilProfessor.dart';
import 'package:flutter_application_1/service/authentication.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/images.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  String? _selectedOption;
  bool _obscureText = true;

  final _formKey = GlobalKey<FormState>();

  final Authentication _authService = Authentication();

  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

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
                              // Text(
                              //   'Como deseja entrar?',
                              //   style: TextStyle(
                              //     color: azulEscuro,
                              //     fontFamily: 'Poppins',
                              //     fontSize: 21,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              SizedBox(height: 10),
                              // DropdownButtonFormField<String>(
                              //   value: _selectedOption,
                              //   hint: Text('Selecione uma opção'),
                              //   style: TextStyle(
                              //     fontSize: 14,
                              //     fontFamily: 'Poppins',
                              //     fontWeight: FontWeight.w700,
                              //     color: azulEscuro,
                              //     backgroundColor: branco,
                              //   ),
                              //   borderRadius: BorderRadius.all(
                              //     Radius.circular(10),
                              //   ),
                              //   decoration: formDecoracao(null, null, null),
                              //   items:
                              //       [
                              //         'Admin',
                              //         'Coordenador',
                              //         'Professor(a)',
                              //       ].map<DropdownMenuItem<String>>((
                              //         String value,
                              //       ) {
                              //         return DropdownMenuItem<String>(
                              //           value: value,
                              //           child: Text(value),
                              //         );
                              //       }).toList(),
                              //   onChanged: (String? newValue) {
                              //     setState(() {
                              //       _selectedOption = newValue!;
                              //     });
                              //   },
                              //   validator: (value) {
                              //     if (value == null || value.isEmpty) {
                              //       return 'Por favor, escolha uma opção.';
                              //     }
                              //     return null;
                              //   },
                              // ),
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
                                      if (!value.contains('@')) {
                                        return 'O email não é válido';
                                      }
                                      return null;
                                    },
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: formDecoracao(
                                      "Insira seu email senai.",
                                      IconButton(
                                        icon: Icon(Icons.person_2),
                                        onPressed: () {},
                                      ),
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
                                    obscureText: _obscureText,
                                    controller: senhaController,
                                    decoration: formDecoracao(
                                      "Insira sua senha.",

                                      // Ocultar ou mostrar senha
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _obscureText = !_obscureText;
                                          });
                                        },
                                        icon: Icon(
                                          _obscureText
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                        ),
                                      ),
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
                                onPressed: () async {
                                  String email = emailController.text.trim();
                                  String senha = senhaController.text.trim();

                                  if (_formKey.currentState!.validate()) {
                                    try {
                                      // Faz login
                                      final user = await _authService.loginUser(
                                        email: email,
                                        senha: senha,
                                      );

                                      if (user != null) {
                                        // Busca tipo no Firestore
                                        String? tipo = await _authService
                                            .buscarTipoUsuario(user.uid);

                                        if (tipo == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Tipo de usuário não encontrado.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        // Redireciona com base no tipo
                                        Widget nextPage;

                                        if (tipo == "Coordenador") {
                                          nextPage = PerfilCoordenador();
                                        } else if (tipo == "Professor(a)") {
                                          nextPage = PerfilProfessor();
                                        } else if (tipo == "Admin") {
                                          nextPage = PerfilAdmin();
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Tipo de usuário inválido.',
                                              ),
                                            ),
                                          );
                                          return;
                                        }

                                        // Navega
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => nextPage,
                                          ),
                                        );

                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Login realizado com sucesso!',
                                            ),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Erro de login: $e'),
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                              SizedBox(height: 5),
                              Column(
                                children: [
                                  TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Esqueceu sua senha?",
                                      style: TextStyle(
                                        color: azulEscuro,
                                        decoration: TextDecoration.underline,
                                        decorationColor: azulEscuro,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => TelaCadastro(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Não tem uma conta? Cadastre-se",
                                      style: TextStyle(
                                        color: azulEscuro,
                                        decoration: TextDecoration.underline,
                                        decorationColor: azulEscuro,
                                      ),
                                    ),
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
