import 'package:crypttrend/components/card/MainCard.dart';
import 'package:crypttrend/components/header/Header.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../core/symbol/SymbolsData.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  List<SymbolData> getMockData() {
    return [
      SymbolData(
        symbol: "BTC/USDT",
        price: 43250.50,
        timeframes: Timeframes(
          fifteenMinutes: TimeframeStatus.bullish,
          oneHour: TimeframeStatus.bearish,
          fourHours: TimeframeStatus.neutral,
          daily: TimeframeStatus.bullish,
          weekly: TimeframeStatus.bullish,
        ),
      ),
      SymbolData(
        symbol: "ETH/USDT",
        price: 2580.75,
        timeframes: Timeframes(
          fifteenMinutes: TimeframeStatus.neutral,
          oneHour: TimeframeStatus.bullish,
          fourHours: TimeframeStatus.bullish,
          daily: TimeframeStatus.bearish,
          weekly: TimeframeStatus.neutral,
        ),
      ),
      SymbolData(
        symbol: "ADA/USDT",
        price: 0.485,
        timeframes: Timeframes(
          fifteenMinutes: TimeframeStatus.bearish,
          oneHour: TimeframeStatus.bearish,
          fourHours: TimeframeStatus.neutral,
          daily: TimeframeStatus.bullish,
          weekly: TimeframeStatus.bullish,
        ),
      ),
      SymbolData(
        symbol: "SOL/USDT",
        price: 98.25,
        timeframes: Timeframes(
          fifteenMinutes: TimeframeStatus.bullish,
          oneHour: TimeframeStatus.bullish,
          fourHours: TimeframeStatus.bullish,
          daily: TimeframeStatus.neutral,
          weekly: TimeframeStatus.bearish,
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mockData = getMockData();

    return Scaffold(
      appBar: const Header(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(top: 20),
                child: Text(
                  'Moedas',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 345),
                      child: const ShadInput(
                        placeholder: Text('Buscar Criptomoeda...'),
                        keyboardType: TextInputType.name,
                      ),
                    ),
                    SizedBox(width: 10),
                    ShadIconButton(
                      onPressed: () => print('Primary'),
                      icon: const Icon(LucideIcons.search),
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: ListView.builder(
                itemCount: mockData.length,
                itemBuilder: (context, index) {
                  final symbolData = mockData[index];
                  return MainCard(
                    symbol: symbolData.symbol,
                    price: symbolData.price,
                    timeframes: symbolData.timeframes,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
