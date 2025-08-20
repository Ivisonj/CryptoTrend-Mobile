import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('CryptoTrend'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0, top: 8.0, bottom: 8.0),
          child: ShadAvatar(
            'https://app.requestly.io/delay/2000/avatars.githubusercontent.com/u/124599?v=4',
            size: const Size(50, 50),
            shape: const CircleBorder(),
          ),
        ),
      ],
    );
  }
}
