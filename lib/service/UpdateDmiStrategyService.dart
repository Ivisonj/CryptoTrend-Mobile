import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

updateDmiStrategyService(
  BuildContext context,
  bool? selected,
  bool? candleClose,
  int? length,
) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? access_token = sharedPreferences.getString('access_token');

  try {
    String? baseApiUrl = dotenv.env['BASE_API_URL'];

    var url = Uri.parse('${baseApiUrl}/strategies/dmi');

    Map<String, dynamic> body = {
      'selected': selected,
      'candleClose': candleClose,
      'length': length,
    };

    var response = await http.patch(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${access_token.toString()}',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
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

      queryCache.invalidateQueries('symbols_data');
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
