import 'package:crypttrend/pages/Login/Login.dart';
import 'package:crypttrend/pages/signup/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

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
              child: const Text('Entrar'),
              width: double.infinity,
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  print(_emailController.text);
                  print(_passwordController.text);
                }
              },
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
