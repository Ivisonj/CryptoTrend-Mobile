import 'package:crypttrend/components/card/MainCard.dart';
import 'package:crypttrend/components/header/Header.dart';
import 'package:crypttrend/service/AddSymbolService.dart';
import 'package:crypttrend/service/GetSymbolsService.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map<String, dynamic>> symbolData = [];
  bool isLoading = true;
  String? errorMessage;
  late TextEditingController _symbolInputController;

  @override
  void initState() {
    super.initState();
    _loadSymbolData();
    _symbolInputController = TextEditingController();
  }

  @override
  void dispose() {
    _symbolInputController.dispose();
    super.dispose();
  }

  Future<void> _loadSymbolData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final apiData = await getSymbolsService(context);

      if (apiData != null && apiData is List) {
        setState(() {
          symbolData = apiData
              .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Nenhum dado retornado da API';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Erro ao carregar dados: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadSymbolData();
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
                        placeholder: const Text('Adiconar crypto moeda...'),
                        controller: _symbolInputController,
                        keyboardType: TextInputType.text,
                      ),
                    ),

                    SizedBox(width: 10),

                    Expanded(
                      flex: 10,
                      child: ShadIconButton(
                        onPressed: () => {
                          addSymbolService(
                            context,
                            _symbolInputController.text,
                          ),
                        },
                        icon: const Icon(LucideIcons.plus),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
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

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              errorMessage!,
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

    if (symbolData.isEmpty) {
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
      onRefresh: _refreshData,
      child: ListView.builder(
        itemCount: symbolData.length,
        itemBuilder: (context, index) {
          final symbol = symbolData[index];
          return MainCard(
            symbol: symbol['symbol'] ?? '',
            price: (symbol['price'] ?? 0).toDouble(),
            timeframes: symbol['timeframes'] ?? {},
          );
        },
      ),
    );
  }
}
