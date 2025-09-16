import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

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

class Strategies extends StatelessWidget {
  const Strategies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                child: Text(
                  'Estratégias',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
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
    );
  }
}
