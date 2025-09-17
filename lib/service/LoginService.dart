import 'dart:convert';

import 'package:crypttrend/pages/checkPage/CheckPage.dart';
import 'package:crypttrend/pages/home/home.dart';
import 'package:crypttrend/pages/login/Login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

loginService(context, email, password) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  try {
    String? baseApiUrl = dotenv.env['BASE_API_URL'];

    var url = Uri.parse('${baseApiUrl}/user/signin');

    Map<String, dynamic> body = {'email': email, 'password': password};

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      final String access_token = data['access_token'];
      final String name = data['name'];
      final String email = data['email'];
      final bool premium = (data['premium'] is bool)
          ? data['premium'] as bool
          : (data['premium']?.toString() == 'true');

      if (access_token != null) {
        await sharedPreferences.setString('access_token', access_token);
        await sharedPreferences.setString('name', name);
        await sharedPreferences.setString('email', email);
        await sharedPreferences.setBool('premium', premium);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CheckPage()),
      );
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
