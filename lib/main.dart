import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import 'config/firebase_options.dart';
import 'config/notification_service.dart';
import 'pages/checkPage/CheckPage.dart';
import 'pages/home/Home.dart';
import 'pages/profile/Profile.dart';
import 'pages/strategies/Strategies.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  NotificationService.initializeNotification();

  FirebaseMessaging.onBackgroundMessage(
    NotificationService.firebaseMessagingBackgroundHandle,
  );

  String? publishableKey = dotenv.env['STRIPE_PUBLIC_KEY'];

  Stripe.publishableKey = publishableKey!;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ShadApp.custom(
      themeMode: ThemeMode.dark,
      darkTheme: ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadSlateColorScheme.dark(),
      ),

      appBuilder: (context) {
        return MaterialApp(
          theme: Theme.of(context),
          darkTheme: Theme.of(context).copyWith(brightness: Brightness.dark),
          themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          home: const CheckPage(),
          builder: (context, child) {
            return ShadAppBuilder(child: child!);
          },
        );
      },
    );
  }
}

class MainNav extends StatefulWidget {
  const MainNav({super.key});
  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int _selectedIndex = 0;

  late final List<Widget> _pages = <Widget>[
    const Home(),
    const Strategies(),
    const Profile(),
  ];

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedIconTheme: IconThemeData(color: primaryColor, size: 28),
        unselectedIconTheme: const IconThemeData(size: 24),
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: 'Strategies',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
