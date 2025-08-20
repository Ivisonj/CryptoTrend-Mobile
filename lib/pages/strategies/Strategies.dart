import 'package:crypttrend/components/header/Header.dart';
import 'package:crypttrend/components/indicatorsForms/dmi/DmiForm.dart';
import 'package:crypttrend/components/indicatorsForms/ema/EmaForm.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final List<Map<String, dynamic>> details = [
  {'title': 'Médias Moveis Exponenciais', 'widget': const EmaForm()},
  {'title': 'Di+Di-', 'widget': const DmiForm()},
  // {
  //   'title': 'Di+Di-',
  //   'widget': _buildDmiForm(),
  // },
];

class Strategies extends StatelessWidget {
  const Strategies({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
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

            ShadAccordion(
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
          ],
        ),
      ),
    );
  }
}
