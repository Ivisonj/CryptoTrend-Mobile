import 'package:crypttrend/components/loginForm/LoginForm.dart';
import 'package:flutter/material.dart';

import '../../components/loginForm/LoginForm.dart';

class Login extends StatelessWidget {
  const Login({super.key});

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
                    'Login',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 20),

                  LoginForm(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
