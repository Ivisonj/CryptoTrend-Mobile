import 'package:crypttrend/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MainCard extends StatelessWidget {
  final String symbol;
  final double price;
  final Map<String, dynamic> timeframes;

  const MainCard({
    super.key,
    required this.symbol,
    required this.price,
    required this.timeframes,
  });

  Color _colorForStatus(String? status) {
    switch (status) {
      case 'Bullish':
        return Colors.greenAccent;
      case 'Bearish':
        return Colors.redAccent;
      case 'Neutral':
        return Colors.white;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  symbol,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 15),
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: ShadIconButton(
                      icon: const Text('15m'),
                      backgroundColor: _colorForStatus(
                        timeframes['fifteenMinutes'],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: ShadIconButton(
                      icon: const Text('1h'),
                      backgroundColor: _colorForStatus(timeframes['oneHour']),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: ShadIconButton(
                      icon: const Text('4h'),
                      backgroundColor: _colorForStatus(timeframes['forHours']),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    child: ShadIconButton(
                      icon: const Text('1d'),
                      backgroundColor: _colorForStatus(timeframes['daily']),
                    ),
                  ),
                  ShadIconButton(
                    icon: const Text('1S'),
                    backgroundColor: _colorForStatus(timeframes['weekly']),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
