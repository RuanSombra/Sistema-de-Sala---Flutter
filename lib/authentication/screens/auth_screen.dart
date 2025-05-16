// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/authentication/components/show_snackbar.dart';
// import 'package:flutter_application_1/authentication/service/auth_service.dart';
// import 'package:flutter_application_1/components/textformfield.dart';
// import 'package:flutter_application_1/style/images.dart';

// import '../../style/colors.dart';

// class AuthScreen extends StatefulWidget {
//   const AuthScreen({super.key});

//   @override
//   State<AuthScreen> createState() => _AuthScreenState();
// }

// class _AuthScreenState extends State<AuthScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final AuthService authService = AuthService();
//   final List<String> tiposUsuario = ['aluno', 'professor', 'admin'];

//   bool obscureText = true;
//   bool isEntrando = true;
//   String? _tipoSelecionado;

//   TextEditingController emailController = TextEditingController();
//   TextEditingController nameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   TextEditingController confirmedpasswordController = TextEditingController();
//   TextEditingController occupationController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     // Para identificar o tamanho da tela do dispositivo
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: ListView(
//         children: [
//           SizedBox(
//             width: width,
//             height: height,
//             child: Padding(
//               padding: EdgeInsets.all(36),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(LogoSenaiPreto),

//                   Padding(
//                     padding: const EdgeInsets.only(top: 20),
//                     child: SizedBox(
//                       width: 300,
//                       child: Text(
//                         (isEntrando)
//                             ? 'Bem vindo ao aplicativo de reservas de salas do Senai-MA.'
//                             : 'Vamos começar?',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: preto,
//                           fontSize: 22,
//                           fontFamily: 'Poppins',
//                         ),
//                       ),
//                     ),
//                   ),

//                   Padding(
//                     padding: const EdgeInsets.only(top: 10),
//                     child: Text(
//                       (isEntrando)
//                           ? 'Faça seu login para reservar salas.'
//                           : 'Faça seu cadastro para poder reservar salas',
//                       style: TextStyle(
//                         fontFamily: 'Inter',
//                         color: preto,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),

//                   Visibility(
//                     visible: !isEntrando,
//                     child: Column(
//                       children: [
//                         DropdownButtonFormField<String>(
//                           decoration: const InputDecoration(
//                             labelText: 'Tipo de usuário',
//                           ),
//                           value: _tipoSelecionado,
//                           onChanged: (value) {
//                             setState(() {
//                               _tipoSelecionado = value!;
//                             });
//                           },
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Selecione o tipo de usuário';
//                             }
//                             return null;
//                           },
//                           items:
//                               tiposUsuario.map((tipo) {
//                                 return DropdownMenuItem(
//                                   value: tipo,
//                                   child: Text(
//                                     tipo[0].toUpperCase() + tipo.substring(1),
//                                   ),
//                                 );
//                               }).toList(),
//                         ),
//                       ],
//                     ),
//                   ),

//                   SizedBox(
//                     width: 270,
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 10),
//                           child: SizedBox(
//                             width: 303,
//                             child: Form(
//                               key: _formKey,
//                               child: Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 10),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           'Email: ',
//                                           style: TextStyle(
//                                             fontSize: 15,
//                                             fontFamily: 'Poppins',
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),

//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                             top: 5,
//                                           ),
//                                           child: TextFormField(
//                                             validator: (value) {
//                                               if (value == null ||
//                                                   value.isEmpty) {
//                                                 return 'Por favor, insira um email.';
//                                               }
//                                               if (!value.endsWith(
//                                                 '.senai.br',
//                                               )) {
//                                                 return 'Insira um email válido da instituição.';
//                                               }
//                                               if (!value.contains('@')) {
//                                                 return 'Insira um email válido.';
//                                               }
//                                               return null;
//                                             },
//                                             controller: emailController,
//                                             keyboardType:
//                                                 TextInputType.emailAddress,
//                                             decoration: formDecoracao(
//                                               'Insira seu e-mail: ',
//                                               IconButton(
//                                                 onPressed: () {},
//                                                 icon: Icon(Icons.person_2),
//                                               ),
//                                               null,
//                                             ),
//                                           ),
//                                         ),
//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                             top: 10,
//                                             bottom: 5,
//                                           ),
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 'Senha: ',
//                                                 style: TextStyle(
//                                                   fontSize: 15,
//                                                   fontFamily: 'Poppins',
//                                                   fontWeight: FontWeight.bold,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),

//                                         Padding(
//                                           padding: const EdgeInsets.only(
//                                             bottom: 20,
//                                           ),
//                                           child: TextFormField(
//                                             validator: (value) {
//                                               if (value == null ||
//                                                   value.isEmpty) {
//                                                 return 'Por favor, insira uma senha';
//                                               }
//                                               if (value.length < 6) {
//                                                 return 'Digite uma senha maior que 6 dígitos';
//                                               }
//                                               return null;
//                                             },
//                                             obscureText: obscureText,
//                                             controller: passwordController,
//                                             decoration: formDecoracao(
//                                               'Insira a senha: ',
//                                               IconButton(
//                                                 onPressed: () {
//                                                   setState(() {
//                                                     obscureText = !obscureText;
//                                                   });
//                                                 },
//                                                 icon: Icon(
//                                                   obscureText
//                                                       ? Icons.visibility
//                                                       : Icons.visibility_off,
//                                                 ),
//                                               ),
//                                               null,
//                                             ),
//                                           ),
//                                         ),

//                                         ElevatedButton(
//                                           style: ElevatedButton.styleFrom(
//                                             minimumSize: Size(303, 59),
//                                             shape: RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.circular(13),
//                                             ),
//                                             backgroundColor: azulEscuro,
//                                           ),
//                                           child: Text(
//                                             (isEntrando)
//                                                 ? 'Entrar'
//                                                 : 'Cadastrar',
//                                             style: TextStyle(
//                                               fontSize: 16,
//                                               letterSpacing: 0.8,
//                                               fontWeight: FontWeight.w500,
//                                               color: branco,
//                                             ),
//                                           ),
//                                           onPressed: () {
//                                             sendButton();
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   Visibility(
//                     visible: isEntrando,
//                     child: TextButton(
//                       onPressed: () {
//                         forgotPassword();
//                       },
//                       child: Text(
//                         'Esqueci minha senha.',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),

//                   Visibility(
//                     visible: !isEntrando,
//                     child: Column(
//                       children: [
//                         TextFormField(
//                           controller: confirmedpasswordController,
//                           obscureText: true,
//                           decoration: formDecoracao(
//                             'Confirme sua senha: ',
//                             IconButton(
//                               onPressed: () {},
//                               icon: Icon(
//                                 obscureText
//                                     ? Icons.visibility
//                                     : Icons.visibility_off,
//                               ),
//                             ),
//                             null,
//                           ),
//                           validator: (value) {
//                             if (value == null || value.length < 6) {
//                               return 'Insira uma senha válida';
//                             }
//                             if (value != passwordController.text) {
//                               return 'As senhas devem ser iguais';
//                             }
//                             return null;
//                           },
//                         ),
//                         TextFormField(
//                           controller: nameController,
//                           decoration: const InputDecoration(
//                             label: Text("Nome"),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.length < 3) {
//                               return "Insira um nome maior.";
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ),
//                   ),

//                   TextButton(
//                     onPressed: () {
//                       setState(() {
//                         isEntrando = !isEntrando;
//                       });
//                     },
//                     child: Text(
//                       (isEntrando)
//                           ? 'Ainda não tem conta? \nCadastra-se já!!'
//                           : 'Já tem conta? Clique aqui para entrar!!',
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         color: Colors.blue,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   sendButton() {
//     String email = emailController.text;
//     String name = nameController.text;
//     String occupation = occupationController.text;
//     String password = passwordController.text;
//     String confirmedpassword = confirmedpasswordController.text;

//     if (_formKey.currentState!.validate()) {
//       if (isEntrando) {
//         _loginUser(email: email, password: password);
//       } else {
//         _registerUser(
//           email: email,
//           password: password,
//           confirmedpassword: confirmedpassword,
//           name: name,
//           occupation: occupation,
//         );
//       }
//     }
//   }

//   _loginUser({required String email, required String password}) {
//     authService.loginUser(email: email, password: password).then((
//       String? erro,
//     ) {
//       if (erro != null) {
//         showSnackBar(context: context, mensagem: erro, isErro: true);
//       }
//     });
//   }

//   _registerUser({
//     required String email,
//     required String password,
//     required String confirmedpassword,
//     required String name,
//     required String occupation,
//   }) {
//     authService
//         .registerUser(
//           email: email,
//           password: password,
//           confirmedpassword: confirmedpassword,
//           name: name,
//           occupation: occupation,
//           tipo: _tipoSelecionado!, // 👈 aqui
//         )
//         .then((String? erro) {
//           if (erro != null) {
//             showSnackBar(context: context, mensagem: erro, isErro: true);
//           }
//         });
//   }

//   forgotPassword() {
//     String email = emailController.text;

//     showDialog(
//       context: context,
//       builder: (context) {
//         TextEditingController resetpasswordController = TextEditingController(
//           text: email,
//         );

//         return AlertDialog(
//           title: Text('Confirme o e-mail que deseje redefinir senha: '),
//           content: TextFormField(
//             controller: resetpasswordController,
//             decoration: InputDecoration(label: Text('Insira o E-mail: ')),
//           ),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(32),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 authService.resetPassword(email: email).then((String? erro) {
//                   if (erro == null) {
//                     showSnackBar(
//                       context: context,
//                       mensagem: 'Redefinição Enviada',
//                       isErro: false,
//                     );
//                   } else {
//                     showSnackBar(
//                       context: context,
//                       mensagem: erro,
//                       isErro: true,
//                     );
//                   }

//                   Navigator.pop(context);
//                 });
//               },
//               child: Text('Enviar'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
