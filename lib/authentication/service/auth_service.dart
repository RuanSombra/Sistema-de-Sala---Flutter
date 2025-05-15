import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // As instâncias do FirebaseFirestore e FirebaseAuth.
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função responsável por fazer o cadastro dos usuários.
  Future<String?> registerUser({
    required String email,
    required String password,
    required String confirmedpassword,
    required String name,
    required String occupation,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user!.updateDisplayName(name);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'E-mail já está em uso';
      }
      return e.code;
    }
    return null;
  }

  // Função responsável por fazer o login.
  Future<String?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return 'Usuário não cadastrado!';
        case 'wrong-password':
          return 'Senha Incorreta!!';
      }
      return e.code;
    }
    return null;
  }

  // Função para buscar o tipo de usuário (admin, professor, coordenador).
  Future<String?> searchTypeUser(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('usuários').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return (doc.data() as Map<String, dynamic>)['tipo'];
      }
    } catch (e) {
      return 'Erro ao buscar esse tipo de usuário';
    }
    return null;
  }

  // Função para redefinir senha.
  Future<String?> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  // Função para realizar a saída do usuário.
  Future<String?> logoutUser() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }
}
