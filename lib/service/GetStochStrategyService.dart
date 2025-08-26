import 'dart:convert';

import 'package:crypttrend/config/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

getStochStrategyService(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? access_token = sharedPreferences.getString('access_token');

  try {
    var url = Uri.parse('${Env.baseApiUrl}/strategies/stoch');

    var response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${access_token.toString()}',
      },
    );

    final bodyStr = response.body;

    if (bodyStr.isEmpty) {
      return null;
    }

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (body is Map<String, dynamic>) {
        return body;
      } else {
        return null;
      }
    } else {
      var errors = jsonDecode(response.body);
      String errorMessage = 'Erro desconhecido';

      if (errors is Map && errors.containsKey('message')) {
        var message = errors['message'];
        if (message is List) {
          errorMessage = message.join('\n');
        } else {
          errorMessage = message.toString();
        }
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
    print('Erro de conexão: ${e.toString()}');
    var snackBar = SnackBar(
      content: Text('Erro de conexão: ${e.toString()}'),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 4),
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
