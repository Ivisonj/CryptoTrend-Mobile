import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> getPlansService() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final access_token = sharedPreferences.getString('access_token');

  try {
    String? baseApiUrl = dotenv.env['BASE_API_URL'];

    var url = Uri.parse('${baseApiUrl}/plan');

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
      throw Exception('Resposta vazia da API');
    }

    final body = jsonDecode(response.body);

    if (response.statusCode == 200) {
      List<Map<String, dynamic>> plansList;

      if (body is List) {
        plansList = body.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Formato de resposta inesperado');
      }

      return plansList;
    } else {
      throw Exception('Erro HTTP: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erro de conexão: ${e.toString()}');
  }
}
