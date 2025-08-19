import 'package:crypttrend/components/header/Header.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: const Header(), body: Text('Body'));
  }
}
