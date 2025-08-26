import 'dart:convert';

import 'package:crypttrend/config/env.dart';
import 'package:crypttrend/service/GetSymbolsService.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

addSymbolService(BuildContext context, String name) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? access_token = sharedPreferences.getString('access_token');

  try {
    var url = Uri.parse('${Env.baseApiUrl}/symbols');

    Map<String, dynamic> body = {'name': name};

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${access_token.toString()}',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 201) {
      var responseData = jsonDecode(response.body);
      String successMessage = 'Sucesso!';

      if (responseData is Map && responseData.containsKey('message')) {
        var message = responseData['message'];
        if (message is List) {
          successMessage = message.join('\n');
        } else {
          successMessage = message.toString();
        }
      }

      var snackBar = SnackBar(
        content: Text(successMessage),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
