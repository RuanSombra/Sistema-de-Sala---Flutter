import 'package:flutter/material.dart';
import 'package:flutter_application_1/authentication/screens/register_screen.dart';
import 'package:flutter_application_1/components/textformfield.dart';
import 'package:flutter_application_1/authentication/service/authentication.dart';
import 'package:flutter_application_1/style/colors.dart';
import 'package:flutter_application_1/style/images.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final Authentication _authService = Authentication();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: branco,
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.all(36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(LogoSenaiPreto),
                const SizedBox(height: 20),
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
                const SizedBox(height: 10),
                Text(
                  'Faça seu login para reservar salas.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: preto,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: 303,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildEmailField(),
                        const SizedBox(height: 15),
                        _buildPasswordField(),
                        const SizedBox(height: 25),
                        _buildLoginButton(),
                        const SizedBox(height: 10),
                        _buildForgotPasswordButton(),
                        _buildRegisterButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email:',
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          enabled: !_isLoading,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Por favor, insira um email';
            }

            String email = value.trim();

            if (!email.isValidEmail) {
              return 'O email não é válido';
            }

            if (!email.endsWith('.senai.br')) {
              return 'Por favor, insira um email válido do Senai';
            }

            return null;
          },
          decoration: formDecoracao(
            "Insira seu email senai.",
            IconButton(onPressed: () {}, icon: Icon(Icons.person_2)),
            null,
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Senha:',
          style: TextStyle(
            fontSize: 15,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: _senhaController,
          obscureText: _obscureText,
          enabled: !_isLoading,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, digite uma senha!';
            }
            if (value.length < 6) {
              return 'A senha deve ter pelo menos 6 caracteres';
            }
            return null;
          },
          decoration: formDecoracao(
            "Insira sua senha.",
            IconButton(
              onPressed:
                  _isLoading
                      ? null
                      : () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
            ),
            null,
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return SizedBox(
      width: 303,
      height: 59,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
          ),
          backgroundColor: azulEscuro,
          disabledBackgroundColor: azulEscuro.withOpacity(0.6),
        ),
        onPressed: _isLoading ? null : _handleLogin,
        child:
            _isLoading
                ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                : const Text(
                  'Entrar na conta',
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return TextButton(
      onPressed: _isLoading ? null : _showForgotPasswordDialog,
      child: Text(
        "Esqueceu sua senha?",
        style: TextStyle(
          color: _isLoading ? azulEscuro.withOpacity(0.5) : azulEscuro,
          decoration: TextDecoration.underline,
          decorationColor:
              _isLoading ? azulEscuro.withOpacity(0.5) : azulEscuro,
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return TextButton(
      onPressed:
          _isLoading
              ? null
              : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterScreen(),
                  ),
                );
              },
      child: Text(
        "Não tem uma conta? Cadastre-se",
        style: TextStyle(
          color: _isLoading ? azulEscuro.withOpacity(0.5) : azulEscuro,
          decoration: TextDecoration.underline,
          decorationColor:
              _isLoading ? azulEscuro.withOpacity(0.5) : azulEscuro,
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      String email = _emailController.text.trim();
      String senha = _senhaController.text.trim();

      // Usa o novo método loginUser que retorna UserLoginResult
      UserLoginResult result = await _authService.loginUser(
        email: email,
        senha: senha,
      );

      if (!mounted) return;

      if (result.isSuccess) {
        _showSuccessMessage('Login realizado com sucesso!');

        // Aguarda um pouco antes de navegar
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(user: result.user!),
            ),
          );
        }
      } else {
        _showErrorMessage(result.error ?? 'Erro desconhecido no login');
      }
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Erro inesperado: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showForgotPasswordDialog() {
    final TextEditingController emailResetController = TextEditingController();

    // Pre-preenche com o email já digitado
    if (_emailController.text.isNotEmpty) {
      emailResetController.text = _emailController.text;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Redefinir Senha',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Digite seu email para receber o link de redefinição de senha:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: emailResetController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                String email = emailResetController.text.trim();

                if (email.isEmpty) {
                  _showErrorMessage('Por favor, digite um email');
                  return;
                }

                if (!email.isValidEmail) {
                  _showErrorMessage('Email inválido');
                  return;
                }

                Navigator.of(context).pop(); // Fecha o dialog

                // Mostra loading
                _showLoadingDialog();

                try {
                  String? erro = await _authService.redefinirSenha(
                    email: email,
                  );

                  Navigator.of(context).pop(); // Fecha o loading

                  if (erro == null) {
                    _showSuccessMessage(
                      'Email de redefinição enviado! Verifique sua caixa de entrada.',
                    );
                  } else {
                    _showErrorMessage(erro);
                  }
                } catch (e) {
                  Navigator.of(context).pop(); // Fecha o loading
                  _showErrorMessage('Erro ao enviar email: $e');
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: azulEscuro),
              child: const Text(
                'Enviar',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Enviando email...'),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
