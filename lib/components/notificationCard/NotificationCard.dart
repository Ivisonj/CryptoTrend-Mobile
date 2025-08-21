import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final String notificationType;
  final String symbol;
  final String timeframe;

  const NotificationCard({
    super.key,
    required this.notificationType,
    required this.symbol,
    required this.timeframe,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(15),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                notificationType == 'Bullish'
                    ? Icons.arrow_circle_up
                    : Icons.arrow_circle_down,
                size: 45,
                color: notificationType == 'Bullish'
                    ? Colors.green
                    : Colors.red,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Possível Oportunidade!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'A crypto $symbol está $notificationType no gráfico de $timeframe',
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Colors.grey),
      ],
    );
  }
}
