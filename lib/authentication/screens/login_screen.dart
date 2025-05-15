// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/authentication/screens/register_screen.dart';
// import 'package:flutter_application_1/components/textformfield.dart';
// import 'package:flutter_application_1/authentication/service/authentication.dart';
// import 'package:flutter_application_1/style/colors.dart';
// import 'package:flutter_application_1/style/images.dart';

// import 'home_screen.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   bool _obscureText = true;

//   final _formKey = GlobalKey<FormState>();

//   final Authentication authService = Authentication();

//   TextEditingController emailController = TextEditingController();
//   TextEditingController senhaController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // Para identificar o tamanho da tela do dispositivo
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       backgroundColor: branco,
//       body: SingleChildScrollView(
//         // Adicionei todos os elementos no sizedbox para ficar responsivo
//         child: SizedBox(
//           width: width,
//           height: height,
//           child: Padding(
//             padding: EdgeInsets.all(36),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Image.asset(LogoSenaiPreto),
//                 SizedBox(height: 20),
//                 SizedBox(
//                   width: 300,
//                   child: Text(
//                     'Bem-vindo ao aplicativo de reservas de salas do Senai-MA.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: preto,
//                       fontSize: 22,
//                       fontFamily: 'Poppins',
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 10),
//                 Text(
//                   'Faça seu login para reservar salas.',
//                   style: TextStyle(
//                     fontFamily: 'Inter',
//                     color: preto,
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),

//                 SizedBox(
//                   width: 270,
//                   child: Column(
//                     children: [
//                       SizedBox(height: 10),
//                       SizedBox(
//                         width: 303,
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             children: [
//                               SizedBox(height: 10),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Email: ',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       fontFamily: 'Poppins',
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(height: 5),
//                                   TextFormField(
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Por favor, insira um email';
//                                       }
//                                       if (!value.endsWith('.senai.br')) {
//                                         return 'Por favor, insira um email válido do Senai';
//                                       }
//                                       if (!value.contains('@')) {
//                                         return 'O email não é válido';
//                                       }
//                                       return null;
//                                     },
//                                     controller: emailController,
//                                     keyboardType: TextInputType.emailAddress,
//                                     decoration: formDecoracao(
//                                       "Insira seu email senai.",
//                                       IconButton(
//                                         icon: Icon(Icons.person_2),
//                                         onPressed: () {},
//                                       ),
//                                       null,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 10),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Senha: ',
//                                     style: TextStyle(
//                                       fontSize: 15,
//                                       fontFamily: 'Poppins',
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(height: 5),
//                                   TextFormField(
//                                     validator: (value) {
//                                       if (value == null || value.isEmpty) {
//                                         return 'Por favor, digite uma senha!!';
//                                       }
//                                       return null;
//                                     },
//                                     obscureText: _obscureText,
//                                     controller: senhaController,
//                                     decoration: formDecoracao(
//                                       "Insira sua senha.",

//                                       // Ocultar ou mostrar senha
//                                       IconButton(
//                                         onPressed: () {
//                                           setState(() {
//                                             _obscureText = !_obscureText;
//                                           });
//                                         },
//                                         icon: Icon(
//                                           _obscureText
//                                               ? Icons.visibility
//                                               : Icons.visibility_off,
//                                         ),
//                                       ),
//                                       null,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: 20),
//                               ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   minimumSize: Size(303, 59),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(13),
//                                   ),
//                                   backgroundColor: azulEscuro,
//                                 ),
//                                 child: Text(
//                                   'Entrar na conta',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     letterSpacing: 0.8,
//                                     fontWeight: FontWeight.w500,
//                                     color: branco,
//                                   ),
//                                 ),
//                                 onPressed: () async {
//                                   String email = emailController.text.trim();
//                                   String senha = senhaController.text.trim();

//                                   if (_formKey.currentState!.validate()) {
//                                     try {
//                                       // Faz login
//                                       final user = await authService.loginUser(
//                                         email: email,
//                                         senha: senha,
//                                       );

//                                       if (user != null) {
//                                         // Busca tipo no Firestore
//                                         String? tipo = await authService
//                                             .buscarTipoUsuario(user.uid);

//                                         if (tipo == null) {
//                                           ScaffoldMessenger.of(
//                                             context,
//                                           ).showSnackBar(
//                                             SnackBar(
//                                               content: Text(
//                                                 'Tipo de usuário não encontrado.',
//                                               ),
//                                             ),
//                                           );
//                                           return;
//                                         }

//                                         // Redireciona com base no tipo

//                                         // Widget nextPage;

//                                         // if (tipo == "Coordenador") {
//                                         //   nextPage = PerfilCoordenador();
//                                         // } else if (tipo == "Professor(a)") {
//                                         //   nextPage = PerfilProfessor();
//                                         // } else if (tipo == "Admin") {
//                                         //   nextPage = PerfilAdmin();
//                                         // } else {
//                                         //   ScaffoldMessenger.of(
//                                         //     context,
//                                         //   ).showSnackBar(
//                                         //     SnackBar(
//                                         //       content: Text(
//                                         //         'Tipo de usuário inválido.',
//                                         //       ),
//                                         //     ),
//                                         //   );
//                                         //   return;
//                                         // }

//                                         // Navega
//                                         // Navigator.pushReplacement(
//                                         //   context,
//                                         //   MaterialPageRoute(
//                                         //     builder:
//                                         //         (context) =>
//                                         //             HomeScreen(user: user),
//                                         //   ),
//                                         // );

//                                         if (mounted) {
//                                           ScaffoldMessenger.of(
//                                             context,
//                                           ).showSnackBar(
//                                             SnackBar(
//                                               content: Text(
//                                                 'Login realizado com sucesso!',
//                                               ),
//                                             ),
//                                           );

//                                           Future.delayed(
//                                             Duration(seconds: 1),
//                                             () {
//                                               Navigator.pushReplacement(
//                                                 context,
//                                                 MaterialPageRoute(
//                                                   builder:
//                                                       (context) => HomeScreen(
//                                                         user: user,
//                                                       ),
//                                                 ),
//                                               );
//                                             },
//                                           );
//                                         }
//                                       }
//                                     } catch (e) {
//                                       ScaffoldMessenger.of(
//                                         context,
//                                       ).showSnackBar(
//                                         SnackBar(
//                                           content: Text('Erro de login: $e'),
//                                         ),
//                                       );
//                                     }
//                                   }
//                                 },
//                               ),
//                               SizedBox(height: 5),
//                               Column(
//                                 children: [
//                                   TextButton(
//                                     onPressed: () {
//                                       esqueciSenha();
//                                     },
//                                     child: Text(
//                                       "Esqueceu sua senha?",
//                                       style: TextStyle(
//                                         color: azulEscuro,
//                                         decoration: TextDecoration.underline,
//                                         decorationColor: azulEscuro,
//                                       ),
//                                     ),
//                                   ),
//                                   TextButton(
//                                     onPressed: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder:
//                                               (context) => RegisterScreen(),
//                                         ),
//                                       );
//                                     },
//                                     child: Text(
//                                       "Não tem uma conta? Cadastre-se",
//                                       style: TextStyle(
//                                         color: azulEscuro,
//                                         decoration: TextDecoration.underline,
//                                         decorationColor: azulEscuro,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void esqueciSenha() {
//     String email = emailController.text;

//     showDialog(
//       context: context,
//       builder: (context) {
//         TextEditingController redefinirSenhaController =
//             TextEditingController();

//         return AlertDialog(
//           title: Text('Você realmente deseja redefinir sua senha?'),
//           content: TextFormField(
//             controller: redefinirSenhaController,
//             decoration: InputDecoration(label: Text('Digite o e-mail')),
//           ),
//           actions: [
//             TextButton(onPressed: () {}, child: Text('Redefinir Senha')),
//           ],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(32),
//           ),
//         );
//       },
//     );

//     authService.redefinirSenha(email: email).then((String? erro) {
//       if (erro == null) {}
//     });
//   }
// }
