import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/reservas/reservaLivre.dart';
import 'package:flutter_application_1/components/reservas/reservaOcupada.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/screens/login.dart';
import 'package:flutter_application_1/screens/perfilAdmin.dart';
import 'package:flutter_application_1/screens/perfilProfessor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());

  FirebaseFirestore firestore = FirebaseFirestore.instance;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Reservaocupada(),
    );
  }
}
