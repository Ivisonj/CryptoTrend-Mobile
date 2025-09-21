import 'package:flutter/material.dart';

import '../../components/planCard/PlanCard.dart';

class Plans extends StatelessWidget {
  const Plans({super.key});

  @override
  Widget build(BuildContext context) {
    // Dados fictícios dos planos
    final List<Map<String, dynamic>> plansData = [
      {
        'planName': 'Cryp3',
        'duration': '3 meses',
        'currentPrice': 'R\$ 29,90',
        'oldPrice': 'R\$ 39,90',
        'discount': '25%',
      },
      {
        'planName': 'Cryp6',
        'duration': '6 meses',
        'currentPrice': 'R\$ 49,90',
        'oldPrice': 'R\$ 79,90',
        'discount': '37%',
      },
      {
        'planName': 'Cryp12',
        'duration': '1 ano',
        'currentPrice': 'R\$ 79,90',
        'oldPrice': 'R\$ 159,90',
        'discount': '50%',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Planos',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: plansData.length,
                itemBuilder: (context, index) {
                  final plan = plansData[index];
                  return PlanCard(
                    planName: plan['planName'],
                    duration: plan['duration'],
                    currentPrice: plan['currentPrice'],
                    oldPrice: plan['oldPrice'],
                    discount: plan['discount'],
                    onSubscribe: () {
                      // Ação quando o botão "Assinar" for pressionado
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Assinando plano ${plan['planName']}...',
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
