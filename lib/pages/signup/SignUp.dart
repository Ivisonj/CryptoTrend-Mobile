import 'package:crypttrend/components/SignUpForm/SignUpForm.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../components/SignUpForm/SignUpForm.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.center,
            child: Container(
              child: Column(
                children: [
                  Text(
                    'Criar Conta',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),

                  SignUpForm(),

                  Align(
                    alignment: Alignment.center,
                    child: ShadButton.ghost(
                      child: const Text('Fazer Login'),
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
