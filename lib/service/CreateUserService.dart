import 'dart:convert';

import 'package:crypttrend/config/env.dart';
import 'package:crypttrend/pages/home/home.dart';
import 'package:crypttrend/pages/login/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

createUserService(context, name, email, password) async {
  try {
    String? baseApiUrl = dotenv.env['BASE_API_URL'];

    var url = Uri.parse('${baseApiUrl}/user');

    Map<String, dynamic> body = {
      'name': name,
      'email': email,
      'password': password,
    };

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      String successMessage = 'Usuário criado com sucesso!';

      if (responseData is Map && responseData.containsKey('message')) {
        successMessage = responseData['message'];
      }

      var snackBar = SnackBar(
        content: Text(successMessage),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      var errors = jsonDecode(response.body);

      String errorMessage = 'Erro desconhecido';

      if (errors is Map && errors.containsKey('message')) {
        errorMessage = errors['message'];
      }

      var snackBar = SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } catch (e) {
    var snackBar = SnackBar(
      content: Text('Erro de conexão: ${e.toString()}'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
