import 'package:crypttrend/main.dart';
import 'package:crypttrend/pages/Login/Login.dart';
import 'package:crypttrend/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckPage extends StatefulWidget {
  const CheckPage({super.key});

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  @override
  void initState() {
    super.initState();
    checkLoggedUser();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }

  checkLoggedUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? access_token = sharedPreferences.getString('access_token');

    if (access_token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainNav()),
      );
    }
  }
}
