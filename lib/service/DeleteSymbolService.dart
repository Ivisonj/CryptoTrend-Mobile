import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

deleteSymbolService(context, symbol) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String? access_token = sharedPreferences.getString('access_token');
  try {
    String? baseApiUrl = dotenv.env['BASE_API_URL'];

    var url = Uri.parse('${baseApiUrl}/symbols/$symbol');

    var response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ${access_token.toString()}',
      },
    );

    if (response.statusCode == 200) {
      queryCache.invalidateQueries('symbols_data');

      var responseData = jsonDecode(response.body);
      String successMessage = 'sucesso!';

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
