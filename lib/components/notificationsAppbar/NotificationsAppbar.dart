import 'package:cryptrend/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class NotificationsAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const NotificationsAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'Notificações',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
    ;
  }
}
