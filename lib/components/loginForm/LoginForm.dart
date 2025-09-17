import 'package:crypttrend/pages/Login/Login.dart';
import 'package:crypttrend/pages/signup/SignUp.dart';
import 'package:crypttrend/service/LoginService.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool isLoading = false;
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<String?> _getFcmToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      return token;
    } catch (e) {
      print('Erro ao obter FCM token: $e');
      return null;
    }
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      String? fcmToken = await _getFcmToken();

      await loginService(
        context,
        _emailController.text.trim(),
        _passwordController.text.trim(),
        fcmToken,
      );
    } catch (e) {
      print('Erro no processo de login: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro inesperado: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShadInputFormField(
              id: 'email',
              label: const Text('E-mail'),
              placeholder: const Text('seu@email.com'),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Por favor, informe o seu E-mail';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            ShadInputFormField(
              id: 'password',
              label: const Text('Senha'),
              placeholder: const Text('Digite uma senha'),
              controller: _passwordController,
              obscureText: !showPassword,
              trailing: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () => setState(() => showPassword = !showPassword),
              ),
              validator: (v) {
                if (v == null || v.isEmpty)
                  return 'Por favor, digite a sua senha';
                if (v.length < 6)
                  return 'Senha precisa ter pelo menos 6 caracteres';
                return null;
              },
            ),

            const SizedBox(height: 24),

            ShadButton(
              onPressed: isLoading ? null : _handleLogin,
              width: double.infinity,
              child: isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        SizedBox(width: 12),
                        Text('Entrando...'),
                      ],
                    )
                  : const Text('Entrar'),
            ),

            const SizedBox(height: 24),

            Align(
              alignment: Alignment.center,
              child: ShadButton.ghost(
                child: const Text('Criar Conta'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUp()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
