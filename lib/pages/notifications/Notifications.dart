import 'package:cryptrend/components/notificationCard/NotificationCard.dart';
import 'package:cryptrend/core/notification/NotificationData.dart';
import 'package:flutter/material.dart';

import '../../components/notificationsAppbar/NotificationsAppbar.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  List<NotificationData> getMockData() {
    return [
      NotificationData(
        notificationType: 'Bullish',
        symbol: 'BTC/USDT',
        timeframe: '15m',
      ),
      NotificationData(
        notificationType: 'Bearish',
        symbol: 'ETH/USDT',
        timeframe: '1h',
      ),
      NotificationData(
        notificationType: 'Bearish',
        symbol: 'ADA/USDT',
        timeframe: '1d',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final mockData = getMockData();

    return Scaffold(
      appBar: const NotificationsAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: mockData.length,
                itemBuilder: (context, index) {
                  final notificationData = mockData[index];

                  return NotificationCard(
                    notificationType: notificationData.notificationType,
                    symbol: notificationData.symbol,
                    timeframe: notificationData.timeframe,
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
