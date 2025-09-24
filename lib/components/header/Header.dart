import 'package:cryptrend/pages/notifications/Notifications.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 100,
            height: 50,
            child: Image.asset('assets/image/logo.png'),
          ),

          Padding(
            padding: const EdgeInsets.only(right: 12.0, top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShadIconButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Notifications(),
                    ),
                  ),
                  icon: const Icon(
                    LucideIcons.bell,
                    color: Colors.white,
                    size: 20,
                  ),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(width: 8.0),
                ShadAvatar(
                  'https://app.requestly.io/delay/2000/avatars.githubusercontent.com/u/124599?v=4',
                  size: const Size(50, 50),
                  shape: const CircleBorder(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
