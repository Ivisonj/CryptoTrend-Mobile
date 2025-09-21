import 'package:cryptrend/pages/plans/Plans.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/header/Header.dart';
import '../../components/indicatorsForms/candlesPatterns/candlesPatterns.dart';
import '../../components/indicatorsForms/dmi/DmiForm.dart';
import '../../components/indicatorsForms/ema/EmaForm.dart';
import '../../components/indicatorsForms/stochRsi/StochRsi.dart';

final List<Map<String, dynamic>> details = [
  {'title': 'Médias Móveis Exponênciais', 'widget': const EmaForm()},
  {'title': 'Di+Di-', 'widget': const DmiForm()},
  {'title': 'Estocástico-Rsi', 'widget': const StochRsiForm()},
  {'title': 'Padões de Candles', 'widget': const CandlesPatterns()},
];

class Strategies extends StatefulWidget {
  const Strategies({super.key});

  @override
  State<Strategies> createState() => _StrategiesState();
}

class _StrategiesState extends State<Strategies> {
  bool _isPremiumUser = false;

  @override
  void initState() {
    super.initState();
    _loadPremiumStatus();
  }

  Future<void> _loadPremiumStatus() async {
    try {
      final isPremium = await _isPremium();
      if (mounted) {
        setState(() {
          _isPremiumUser = isPremium;
        });
      }
    } catch (e) {
      print('Erro ao verificar status premium: $e');
      if (mounted) {
        setState(() {
          _isPremiumUser = false;
        });
      }
    }
  }

  Future<bool> _isPremium() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final premium = sharedPreferences.getBool('premium');
    return premium ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Header fixo no topo (posição absoluta)
          Positioned(top: 0, left: 0, right: 0, child: Header()),

          // Conteúdo principal com padding top para não sobrepor o header
          Positioned.fill(
            top: kToolbarHeight, // Espaço para o header
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Estratégias',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      if (!_isPremiumUser)
                        ShadButton.outline(
                          child: Text('Seja Premium'),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Plans()),
                          ),
                        ),
                    ],
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: ShadAccordion(
                        children: details
                            .map(
                              (detail) => ShadAccordionItem(
                                value: detail['title'],
                                title: Text(detail['title']),
                                child: detail['widget'],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
