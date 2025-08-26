import 'package:crypttrend/pages/login/Login.dart';
import 'package:crypttrend/pages/signup/SignUp.dart';
import 'package:crypttrend/service/CreateUserService.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool showPassword = false;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
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
              id: 'username',
              label: const Text('Nome'),
              placeholder: const Text('Digite seu nome'),
              controller: _nameController,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Por favor, informe o seu nome completo';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

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

            // No seu ShadButton dentro do SignUpForm
            ShadButton(
              child: const Text('Criar Conta'),
              width: double.infinity,
              onPressed: () async {
                if (_formKey.currentState?.validate() ?? false) {
                  // Usar a função com loading integrado
                  await createUserService(
                    context,
                    _nameController.text.trim(),
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                }
              },
            ),

            const SizedBox(height: 24),

            Align(
              alignment: Alignment.center,
              child: ShadButton.ghost(
                child: const Text('Fazer Login'),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
