import 'dart:convert';

import 'package:crypttrend/config/env.dart';
import 'package:crypttrend/pages/home/home.dart';
import 'package:crypttrend/pages/login/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

createUserService(context, name, email, password) async {
  try {
    var url = Uri.parse('${Env.baseApiUrl}/user');

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
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } else {
      var errors = jsonDecode(response.body);
      print('Errors: $errors');

      String errorMessage = 'Erro desconhecido';

      if (errors is Map) {
        if (errors.containsKey('message')) {
          errorMessage = errors['message'];
        } else if (errors.containsKey('error')) {
          errorMessage = errors['error'];
        }
      } else if (errors is String) {
        errorMessage = errors;
      }

      var snackBar = SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 4),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  } catch (e) {
    var snackBar = SnackBar(
      content: Text('Erro de conexão: ${e.toString()}'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 4),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
