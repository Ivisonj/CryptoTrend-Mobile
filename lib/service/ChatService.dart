import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  static Future<void> sendMessage(BuildContext context, String message) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? accessToken = sharedPreferences.getString('access_token');
    String? chatId = sharedPreferences.getString('chatId');

    try {
      String? baseApiUrl = dotenv.env['WEBHOOK_URL'];

      var url = Uri.parse('${baseApiUrl}');

      Map<String, dynamic> body = {'chat_id': chatId, 'message': message};

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (accessToken != null)
            'Authorization': 'Bearer ${accessToken.toString()}',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        String successMessage = 'Mensagem enviada!';

        if (responseData is Map && responseData.containsKey('message')) {
          var message = responseData['message'];
          if (message is List) {
            successMessage = message.join('\n');
          } else {
            successMessage = message.toString();
          }
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
}
