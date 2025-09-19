import 'package:cryptrend/pages/plans/Plans.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/card/MainCard.dart';
import '../../components/header/Header.dart';
import '../../service/AddSymbolService.dart';
import '../../service/GetSymbolsService.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _symbolInputController;
  static const String symbolsCacheKey = 'symbols_data';
  Timer? _apiTimer;
  bool _isPremiumUser = false;

  @override
  void initState() {
    super.initState();
    _symbolInputController = TextEditingController();
    _setupPeriodicApiCall();
    _loadPremiumStatus();
  }

  @override
  void dispose() {
    _symbolInputController.dispose();
    _apiTimer?.cancel();
    super.dispose();
  }

  void _setupPeriodicApiCall() {
    _apiTimer?.cancel();

    final now = DateTime.now();
    final nextCallTime = _getNextCallTime(now);
    final initialDelay = nextCallTime.difference(now);

    Timer(initialDelay, () {
      _refreshData();

      _apiTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
        _refreshData();
      });
    });
  }

  DateTime _getNextCallTime(DateTime now) {
    if (now.second < 25) {
      return DateTime(now.year, now.month, now.day, now.hour, now.minute, 25);
    } else {
      final nextMinute = now.add(const Duration(minutes: 1));
      return DateTime(
        nextMinute.year,
        nextMinute.month,
        nextMinute.day,
        nextMinute.hour,
        nextMinute.minute,
        20,
      );
    }
  }

  void _refreshData() {
    queryCache.invalidateQueries(symbolsCacheKey);
  }

  Future<void> _addSymbol() async {
    try {
      await addSymbolService(context, _symbolInputController.text);
      _symbolInputController.clear();
      queryCache.invalidateQueries(symbolsCacheKey);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar símbolo: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
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
      appBar: const Header(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Moedas',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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

            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                margin: EdgeInsets.only(top: 15, bottom: 15),
                child: Row(
                  children: [
                    Expanded(
                      flex: 90,
                      child: ShadInputFormField(
                        id: 'symbolInput',
                        placeholder: const Text('Adicionar crypto moeda...'),
                        controller: _symbolInputController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      flex: 10,
                      child: ShadIconButton(
                        onPressed: _addSymbol,
                        icon: const Icon(LucideIcons.plus),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Query<List<Map<String, dynamic>>>(
                symbolsCacheKey,
                future: getSymbolsService,
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
                          Text('Carregando dados...'),
                        ],
                      ),
                    );
                  }

                  if (response.data == null || response.data!.isEmpty) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Nenhuma moeda encontrada',
                            style: TextStyle(color: Colors.grey),
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
                        final symbol = response.data![index];
                        return MainCard(
                          symbol: symbol['symbol'] ?? '',
                          price: (symbol['price'] ?? 0).toDouble(),
                          timeframes: symbol['timeframes'] ?? {},
                        );
                      },
                    ),
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
