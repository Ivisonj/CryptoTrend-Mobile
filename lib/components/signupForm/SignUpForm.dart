import 'package:cryptrend/pages/login/Login.dart';
import 'package:cryptrend/pages/signup/SignUp.dart';
import 'package:cryptrend/service/CreateUserService.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool showPassword = false;
  bool isLoading = false;
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

  Future<void> _handleSignUpForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await createUserService(
        context,
        _nameController.text.trim(),
        _emailController.text.trim(),
        _passwordController.text.trim(),
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

            ShadButton(
              width: double.infinity,
              onPressed: isLoading ? null : _handleSignUpForm,
              child: isLoading
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  : const Text('Criar Conta'),
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
