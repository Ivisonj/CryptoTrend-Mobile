import 'package:crypttrend/components/card/MainCard.dart';
import 'package:crypttrend/components/header/Header.dart';
import 'package:crypttrend/service/AddSymbolService.dart';
import 'package:crypttrend/service/GetSymbolsService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_requery/flutter_requery.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _symbolInputController;
  static const String symbolsCacheKey = 'symbols_data';

  @override
  void initState() {
    super.initState();
    _symbolInputController = TextEditingController();
  }

  @override
  void dispose() {
    _symbolInputController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
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
