import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/perfilCoordenador.dart';
import 'package:flutter_application_1/screens/perfilProfessor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PerfilCoordenador(),
    );
  }
}
