import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

getLLMsService(BuildContext context) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? access_token = sharedPreferences.getString('access_token');

  try {
    String? baseApiUrl = dotenv.env['BASE_API_URL'];

    var url = Uri.parse('${baseApiUrl}/llm');

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
      if (body is List) {
        return body.cast<Map<String, dynamic>>();
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
