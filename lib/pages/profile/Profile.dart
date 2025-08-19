import 'package:crypttrend/components/header/Header.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: Header(), body: Text('Profile'));
  }
}
