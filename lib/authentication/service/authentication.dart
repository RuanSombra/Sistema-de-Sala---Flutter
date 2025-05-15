// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class Authentication {
//   final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> cadastrarUsuarioNoFirestore({
//     required String uid,
//     required String nome,
//     required String cargo,
//     required String email,
//     required String tipo,
//   }) async {
//     try {
//       await _firestore.collection('usuarios').doc(uid).set({
//         'nome': nome,
//         'cargo': cargo,
//         'email': email,
//         'tipo': tipo,
//       });
//       print("Usuário salvo no Firestore com sucesso!");
//     } catch (e) {
//       print("Erro ao salvar usuário no Firestore: $e");
//     }
//   }

//   Future<User?> loginUser({
//     required String email,
//     required String senha,
//   }) async {
//     try {
//       UserCredential userCredential = await _firebaseAuth
//           .signInWithEmailAndPassword(email: email, password: senha);

//       return userCredential.user;
//     } catch (e) {
//       print('Erro ao fazer login: $e');
//       throw e;
//     }
//   }

//   Future<String?> buscarTipoUsuario(String uid) async {
//     try {
//       DocumentSnapshot doc =
//           await _firestore.collection('usuarios').doc(uid).get();

//       if (doc.exists && doc.data() != null) {
//         return (doc.data() as Map<String, dynamic>)['tipo'];
//       }
//     } catch (e) {
//       print('Erro ao buscar tipo de usuário: $e');
//     }
//     return null;
//   }

//   Future<String?> redefinirSenha({required String email}) async {
//     try {
//       await _firebaseAuth.sendPasswordResetEmail(email: email);
//     } on FirebaseAuthException catch (e) {
//       return e.code;
//     }
//     return null;
//   }

//   Future<String?> deslogar() async {
//     try {
//       await _firebaseAuth.signOut();
//     } on FirebaseAuthException catch (e) {
//       return e.code;
//     }
//     return null;
//   }
// }
