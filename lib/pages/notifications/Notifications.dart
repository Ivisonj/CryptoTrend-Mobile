import 'package:flutter/material.dart';

import '../../components/notificationsAppbar/NotificationsAppbar.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const NotificationsAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(children: [

          ]
        ),
      ),
    );
  }
}
