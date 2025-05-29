import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Cadastra um novo usuário no Firebase Auth e salva os dados no Firestore
  Future<String?> cadastrarUsuarioNoFirestore({
    required String nome,
    required String senha,
    required String cargo,
    required String email,
    required String tipo,
  }) async {
    try {
      // 1. Criar usuário no Firebase Auth
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);

      // 2. Obter o UID do usuário criado
      String uid = userCredential.user!.uid;

      // 3. Atualizar o display name
      await userCredential.user!.updateDisplayName(nome);

      // 4. Salvar dados adicionais no Firestore
      await _firestore.collection('usuarios').doc(uid).set({
        'nome': nome,
        'cargo': cargo,
        'email': email,
        'tipo': tipo,
        'criadoEm': FieldValue.serverTimestamp(),
        'ativo': true,
      });

      print("Usuário cadastrado e salvo com sucesso!");
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      print("Erro de autenticação: ${e.code} - ${e.message}");

      switch (e.code) {
        case "email-already-in-use":
          return "O e-mail já está em uso.";
        case "weak-password":
          return "A senha é muito fraca.";
        case "invalid-email":
          return "O e-mail é inválido.";
        case "operation-not-allowed":
          return "Operação não permitida.";
        default:
          return "Erro ao cadastrar usuário: ${e.message}";
      }
    } catch (e) {
      print("Erro inesperado: $e");
      return "Erro inesperado ao cadastrar usuário.";
    }
  }

  /// Faz login do usuário
  Future<UserLoginResult> loginUser({
    required String email,
    required String senha,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: senha);

      // Verificar se o usuário existe no Firestore
      String? tipoUsuario = await buscarTipoUsuario(userCredential.user!.uid);

      if (tipoUsuario == null) {
        // Se não encontrar o usuário no Firestore, fazer logout
        await _firebaseAuth.signOut();
        return UserLoginResult(
          user: null,
          error: "Usuário não encontrado no sistema.",
        );
      }

      return UserLoginResult(
        user: userCredential.user,
        error: null,
        tipoUsuario: tipoUsuario,
      );
    } on FirebaseAuthException catch (e) {
      print('Erro de autenticação: ${e.code} - ${e.message}');

      String errorMessage;
      switch (e.code) {
        case "user-not-found":
          errorMessage = "Usuário não encontrado.";
          break;
        case "wrong-password":
          errorMessage = "Senha incorreta.";
          break;
        case "invalid-email":
          errorMessage = "E-mail inválido.";
          break;
        case "user-disabled":
          errorMessage = "Usuário desabilitado.";
          break;
        case "too-many-requests":
          errorMessage =
              "Muitas tentativas de login. Tente novamente mais tarde.";
          break;
        default:
          errorMessage = "Erro ao fazer login: ${e.message}";
      }

      return UserLoginResult(user: null, error: errorMessage);
    } catch (e) {
      print('Erro inesperado: $e');
      return UserLoginResult(
        user: null,
        error: "Erro inesperado ao fazer login.",
      );
    }
  }

  /// Busca o tipo de usuário no Firestore
  Future<String?> buscarTipoUsuario(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('usuarios').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return data['tipo'];
      } else {
        print('Documento do usuário não encontrado no Firestore');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar tipo de usuário: $e');
      return null;
    }
  }

  /// Busca dados completos do usuário
  Future<Map<String, dynamic>?> buscarDadosUsuario(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('usuarios').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        return doc.data() as Map<String, dynamic>;
      } else {
        print('Documento do usuário não encontrado no Firestore');
        return null;
      }
    } catch (e) {
      print('Erro ao buscar dados do usuário: $e');
      return null;
    }
  }

  /// Redefinir senha
  Future<String?> redefinirSenha({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      print("Erro ao redefinir senha: ${e.code} - ${e.message}");

      switch (e.code) {
        case "user-not-found":
          return "E-mail não encontrado.";
        case "invalid-email":
          return "E-mail inválido.";
        default:
          return "Erro ao enviar e-mail de redefinição: ${e.message}";
      }
    } catch (e) {
      print("Erro inesperado: $e");
      return "Erro inesperado ao redefinir senha.";
    }
  }

  /// Fazer logout
  Future<String?> deslogar() async {
    try {
      await _firebaseAuth.signOut();
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      print("Erro ao fazer logout: ${e.code} - ${e.message}");
      return "Erro ao fazer logout: ${e.message}";
    } catch (e) {
      print("Erro inesperado: $e");
      return "Erro inesperado ao fazer logout.";
    }
  }

  /// Verificar se o usuário está logado
  User? get currentUser => _firebaseAuth.currentUser;

  /// Stream para monitorar mudanças no estado de autenticação
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Atualizar dados do usuário no Firestore
  Future<String?> atualizarDadosUsuario({
    required String uid,
    required Map<String, dynamic> dados,
  }) async {
    try {
      dados['atualizadoEm'] = FieldValue.serverTimestamp();

      await _firestore.collection('usuarios').doc(uid).update(dados);
      return null; // Sucesso
    } catch (e) {
      print("Erro ao atualizar dados do usuário: $e");
      return "Erro ao atualizar dados do usuário.";
    }
  }

  /// Deletar conta do usuário (cuidado com esta função!)
  Future<String?> deletarConta() async {
    try {
      User? user = _firebaseAuth.currentUser;
      if (user != null) {
        // Primeiro deletar dados do Firestore
        await _firestore.collection('usuarios').doc(user.uid).delete();

        // Depois deletar a conta do Firebase Auth
        await user.delete();
      }
      return null; // Sucesso
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "requires-recent-login":
          return "Operação sensível. Faça login novamente antes de deletar a conta.";
        default:
          return "Erro ao deletar conta: ${e.message}";
      }
    } catch (e) {
      return "Erro inesperado ao deletar conta.";
    }
  }
}

/// Classe para retornar resultado do login com mais informações
class UserLoginResult {
  final User? user;
  final String? error;
  final String? tipoUsuario;

  UserLoginResult({required this.user, required this.error, this.tipoUsuario});

  bool get isSuccess => user != null && error == null;

  String? get uid => null;
}

/// Extensão para validações de email
extension EmailValidator on String {
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
}

/// Extensão para validações de senha
extension PasswordValidator on String {
  bool get isStrongPassword {
    // Pelo menos 8 caracteres, uma letra maiúscula, uma minúscula e um número
    return RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$',
    ).hasMatch(this);
  }

  bool get isValidPassword {
    // Pelo menos 6 caracteres
    return length >= 6;
  }
}
