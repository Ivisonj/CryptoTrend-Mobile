import 'dart:async';
import 'package:cryptrend/pages/plans/Plans.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../components/card/MainCard.dart';
import '../../components/header/Header.dart';
import '../../service/AddSymbolService.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late TextEditingController _symbolInputController;
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _symbols = [];
  String? chatId;
  bool isLoading = false;
  bool _isPremiumUser = false;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _symbolInputController = TextEditingController();
    _initialize();
  }

  @override
  void dispose() {
    _symbolInputController.dispose();
    _channel?.unsubscribe();
    super.dispose();
  }

  Future<void> _initialize() async {
    await _loadChatId();
    await _loadPremiumStatus();
    await _loadSymbols();
    _setupRealtimeSubscription();
  }

  Future<void> _loadChatId() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final id = sharedPreferences.getString('chatId');
    setState(() {
      chatId = id;
    });
  }

  Future<void> _loadSymbols() async {
    if (chatId == null) return;

    setState(() => isLoading = true);

    try {
      final response = await supabase
          .from('Symbols')
          .select()
          .eq('chatId', chatId!)
          .order('updatedAt', ascending: true);
      if (mounted) {
        setState(() {
          _symbols = List<Map<String, dynamic>>.from(response);
        });
      }
    } catch (e) {
      print('Erro ao carregar symbols: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _setupRealtimeSubscription() {
    if (chatId == null) return;

    _channel = supabase
        .channel('symbols_channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'Symbols',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chatId',
            value: chatId,
          ),
          callback: (payload) {
            setState(() {
              _symbols.add(payload.newRecord);
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.delete,
          schema: 'public',
          table: 'Symbols',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chatId',
            value: chatId,
          ),
          callback: (payload) {
            setState(() {
              _symbols.removeWhere((s) => s['id'] == payload.oldRecord['id']);
            });
          },
        )
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'Symbols',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chatId',
            value: chatId,
          ),
          callback: (payload) {
            setState(() {
              final index = _symbols.indexWhere(
                (s) => s['id'] == payload.newRecord['id'],
              );
              if (index != -1) {
                _symbols[index] = payload.newRecord;
              }
            });
          },
        )
        .subscribe();
  }

  Future<void> _addSymbol() async {
    setState(() => isLoading = true);
    try {
      await addSymbolService(context, _symbolInputController.text);
      _symbolInputController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao adicionar símbolo: ${e.toString()}'),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _loadPremiumStatus() async {
    try {
      final sharedPreferences = await SharedPreferences.getInstance();
      final isPremium = sharedPreferences.getBool('premium') ?? false;
      if (mounted) setState(() => _isPremiumUser = isPremium);
    } catch (e) {
      if (mounted) setState(() => _isPremiumUser = false);
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
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Moedas',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                if (!_isPremiumUser)
                  ShadButton.outline(
                    child: const Text('Seja Premium'),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Plans()),
                    ),
                  ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 15),
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
                  const SizedBox(width: 10),
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
            Expanded(
              child: isLoading
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Carregando dados...'),
                        ],
                      ),
                    )
                  : _symbols.isEmpty
                  ? const Center(
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
                    )
                  : RefreshIndicator(
                      onRefresh: _loadSymbols,
                      child: ListView.builder(
                        itemCount: _symbols.length,
                        itemBuilder: (context, index) {
                          final symbol = _symbols[index];
                          return MainCard(
                            symbol: symbol['name'] ?? '',
                            price: (symbol['price'] ?? 0).toDouble(),
                            timeframes: {
                              'oneMinute': symbol['oneMinute'],
                              'fiveMinutes': symbol['fiveMinutes'],
                              'fifteenMinutes': symbol['fifteenMinutes'],
                              'oneHour': symbol['oneHour'],
                              'forHours': symbol['forHours'],
                              'daily': symbol['daily'],
                              'weekly': symbol['weekly'],
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
