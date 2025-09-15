import 'dart:convert';

import 'package:crypttrend/config/env.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Map<String, dynamic>>> getSymbolsService() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final access_token = sharedPreferences.getString('access_token');

  try {
    var url = Uri.parse('${Env.baseApiUrl}/symbols/calculated-indicators');

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
      List symbolsList;
      if (body is List) {
        symbolsList = body[0]['symbols'] as List;
      } else if (body is Map<String, dynamic>) {
        symbolsList = body['symbols'] as List;
      } else {
        symbolsList = [];
      }

      return symbolsList
          .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
          .toList();
    } else {
      throw Exception('Erro HTTP: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Erro de conexão: ${e.toString()}');
  }
}
