import 'package:cryptrend/pages/home/home.dart';
import 'package:cryptrend/service/DeleteSymbolService.dart';
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
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 4),
                            height: 32,
                            child: ShadIconButton(
                              icon: const Text(
                                '1m',
                                style: TextStyle(fontSize: 15),
                              ),
                              backgroundColor: _colorForStatus(
                                timeframes['oneMinute'],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 4),
                            height: 32,
                            child: ShadIconButton(
                              icon: const Text(
                                '5m',
                                style: TextStyle(fontSize: 15),
                              ),
                              backgroundColor: _colorForStatus(
                                timeframes['fiveMinutes'],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 4),
                            height: 32,
                            child: ShadIconButton(
                              icon: const Text(
                                '15m',
                                style: TextStyle(fontSize: 15),
                              ),
                              backgroundColor: _colorForStatus(
                                timeframes['fifteenMinutes'],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 4),
                            height: 32,
                            child: ShadIconButton(
                              icon: const Text(
                                '1h',
                                style: TextStyle(fontSize: 15),
                              ),
                              backgroundColor: _colorForStatus(
                                timeframes['oneHour'],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 4),
                            height: 32,
                            child: ShadIconButton(
                              icon: const Text(
                                '4h',
                                style: TextStyle(fontSize: 15),
                              ),
                              backgroundColor: _colorForStatus(
                                timeframes['forHours'],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 4),
                            height: 32,
                            child: ShadIconButton(
                              icon: const Text(
                                '1d',
                                style: TextStyle(fontSize: 15),
                              ),
                              backgroundColor: _colorForStatus(
                                timeframes['daily'],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 32,
                            child: ShadIconButton(
                              icon: const Text(
                                '1S',
                                style: TextStyle(fontSize: 15),
                              ),
                              backgroundColor: _colorForStatus(
                                timeframes['weekly'],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Espaço fixo para o botão de delete
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 40,
                    height: 32,
                    child: ShadIconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 20,
                        color: Colors.redAccent,
                      ),
                      backgroundColor: Colors.transparent,
                      onPressed: () {
                        deleteSymbolService(context, symbol);
                      },
                    ),
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
