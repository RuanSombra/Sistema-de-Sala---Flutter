// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_application_1/authentication/service/authentication.dart'; // Atualize o caminho conforme seu projeto
// import 'package:flutter_application_1/style/colors.dart';
// import 'package:flutter_application_1/components/textformfield.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final Authentication _authService = Authentication();

//   TextEditingController nomeController = TextEditingController();
//   TextEditingController cargoController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController senhaController = TextEditingController();

//   String? _tipoSelecionado;
//   bool _obscureText = true;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: branco,
//       appBar: AppBar(
//         title: Text("Cadastro de Usuário"),
//         backgroundColor: azulEscuro,
//         foregroundColor: branco,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(24.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               DropdownButtonFormField<String>(
//                 value: _tipoSelecionado,
//                 hint: Text("Selecione o tipo de usuário"),
//                 decoration: formDecoracao(null, null, null),
//                 items:
//                     ['Admin', 'Coordenador', 'Professor(a)']
//                         .map(
//                           (tipo) =>
//                               DropdownMenuItem(value: tipo, child: Text(tipo)),
//                         )
//                         .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _tipoSelecionado = value;
//                   });
//                 },
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Por favor, selecione um tipo de usuário';
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: nomeController,
//                 decoration: formDecoracao(
//                   "Nome de Usuário",
//                   IconButton(icon: Icon(Icons.person), onPressed: () {}),
//                   null,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Informe um nome válido";
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: cargoController,
//                 decoration: formDecoracao(
//                   "Cargo de Atuação",
//                   IconButton(icon: Icon(Icons.work), onPressed: () {}),
//                   null,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Informe um nome válido";
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: emailController,
//                 decoration: formDecoracao(
//                   "Email institucional",
//                   IconButton(icon: Icon(Icons.email), onPressed: () {}),
//                   null,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Informe um email válido";
//                   }
//                   if (!value.contains('@') || !value.endsWith('.senai.br')) {
//                     return "Use um email válido do Senai";
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 20),
//               TextFormField(
//                 controller: senhaController,
//                 obscureText: _obscureText,
//                 decoration: formDecoracao(
//                   "Senha",
//                   IconButton(
//                     icon: Icon(
//                       _obscureText ? Icons.visibility : Icons.visibility_off,
//                     ),
//                     onPressed: () {
//                       setState(() {
//                         _obscureText = !_obscureText;
//                       });
//                     },
//                   ),
//                   null,
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return "Informe uma senha";
//                   }
//                   if (value.length < 6) {
//                     return "A senha deve ter ao menos 6 caracteres";
//                   }
//                   return null;
//                 },
//               ),
//               SizedBox(height: 30),
//               ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(double.infinity, 50),
//                   backgroundColor: azulEscuro,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   "Cadastrar",
//                   style: TextStyle(color: branco, fontSize: 16),
//                 ),
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     try {
//                       UserCredential userCredential = await FirebaseAuth
//                           .instance
//                           .createUserWithEmailAndPassword(
//                             email: emailController.text.trim(),
//                             password: senhaController.text.trim(),
//                           );

//                       await _authService.cadastrarUsuarioNoFirestore(
//                         uid: userCredential.user!.uid,
//                         nome: nomeController.text.trim(),
//                         cargo: cargoController.text.trim(),
//                         email: emailController.text.trim(),
//                         tipo: _tipoSelecionado!,
//                       );

//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text('Usuário cadastrado com sucesso!'),
//                         ),
//                       );

//                       Navigator.pop(context); // Volta para tela de login
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Erro ao cadastrar: $e')),
//                       );
//                     }
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
