import 'package:crypttrend/components/card/MainCard.dart';
import 'package:crypttrend/components/header/Header.dart';
import 'package:flutter/material.dart';

import '../../core/symbol/SymbolsData.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  List<SymbolData> getMockData() {
    return [
      SymbolData(
        symbol: "BTCUSDT",
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
        symbol: "ETHUSDT",
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
        symbol: "ADAUSDT",
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
        symbol: "SOLUSDT",
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
