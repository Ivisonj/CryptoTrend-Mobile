import 'package:crypttrend/pages/signup/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<ShadFormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'E-mail',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          TextFormField(
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            decoration: const InputDecoration(
              labelText: 'Senha',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          ShadButton(
            child: const Text('Fazer Login'),
            width: double.infinity,
            onPressed: () {
              print('${emailController.text}');
              print('${passwordController.text}');
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
    );
  }
}
