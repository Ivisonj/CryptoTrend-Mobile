import 'package:cryptrend/service/CreatePlaymentIntent.dart';
import 'package:cryptrend/service/GetPlansService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';

import '../../components/planCard/PlanCard.dart';

class Plans extends StatefulWidget {
  const Plans({super.key});

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  static const String plansCacheKey = 'plans_data';

  void _refreshData() {
    queryCache.invalidateQueries(plansCacheKey);
  }

  @override
  Widget build(BuildContext context) {
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
              child: Query<List<Map<String, dynamic>>>(
                plansCacheKey,
                future: getPlansService,
                builder: (context, response) {
                  if (response.error != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Erro ao carregar planos',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            response.error.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _refreshData,
                            child: Text('Tentar Novamente'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (response.loading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Carregando planos...'),
                        ],
                      ),
                    );
                  }

                  if (response.data == null || response.data!.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.payment_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Nenhum plano disponível',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async => _refreshData(),
                    child: ListView.builder(
                      itemCount: response.data!.length,
                      itemBuilder: (context, index) {
                        final plan = response.data![index];

                        final originalPrice = (plan['price'] ?? 0).toDouble();
                        final discount = (plan['discount'] ?? 0).toDouble();
                        final currentPrice = originalPrice * (1 - discount);

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: PlanCard(
                            id: plan['id'] ?? '',
                            name: plan['name'] ?? 'Plano sem nome',
                            duration: plan['duration'] ?? 0,
                            currentPrice: currentPrice,
                            oldPrice: discount > 0 ? originalPrice : null,
                            discount: (discount * 100).toInt(),
                            onSubscribe: () =>
                                createPaymentIntent(context, plan['id']),
                          ),
                        );
                      },
                    ),
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
