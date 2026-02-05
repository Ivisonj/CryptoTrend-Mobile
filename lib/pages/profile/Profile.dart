import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/header/Header.dart';
import '../checkPage/CheckPage.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  Future<Map<String, String?>> _getUserData() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final name = sharedPreferences.getString('name');
    final email = sharedPreferences.getString('email');
    return {'name': name, 'email': email};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(),

          Expanded(
            child: FutureBuilder<Map<String, String?>>(
              future: _getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData) {
                  return const Center(child: Text("Erro ao carregar perfil"));
                }

                final user = snapshot.data!;
                final name = user['name'] ?? 'Sem nome';
                final email = user['email'] ?? 'Sem email';

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          'https://avatars.githubusercontent.com/u/124599?v=4',
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(email, style: const TextStyle(fontSize: 20)),

                      const SizedBox(height: 50),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => logout(context),
                          icon: const Icon(Icons.power_settings_new, size: 20),
                          label: const Text(
                            'Sair',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  logout(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    await sharedPreferences.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => CheckPage()),
    );
  }
}
