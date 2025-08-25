import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../service/CreateCandlesPatternsStrategyService.dart';
import '../../../service/GetCandlesPatternsStrategyService.dart';
import '../../../service/UpdateCandlesPatternsStrategyService.dart';

class CandlesPatterns extends StatefulWidget {
  const CandlesPatterns({super.key});

  @override
  State<CandlesPatterns> createState() => _CandlesPatternsState();
}

class _CandlesPatternsState extends State<CandlesPatterns> {
  bool selected = false;
  bool candleClose = false;
  bool isLoading = true;
  bool _hasExistingData = false;
  String pattern = 'engulfing';

  final _formKey = GlobalKey<FormState>();
  final List<String> selectOptions = ['star', 'engulfing'];

  @override
  void initState() {
    super.initState();
    _loadCandlesPatternsData();
  }

  Future<void> _loadCandlesPatternsData() async {
    try {
      final data = await getCandlesPatternsStrategyService(context);

      if (data != null && mounted) {
        setState(() {
          _hasExistingData = true;
          selected = data['selected'] ?? false;
          candleClose = data['candleClose'] ?? true;
          pattern = data['pattern'] ?? 'engulfing';
          isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          _hasExistingData = false;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasExistingData = false;
          isLoading = false;
        });
        print('Erro ao carregar dados dos Padrões de Candles: $e');
      }
    }
  }

  Future<void> _saveCandlesPatternsData() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        if (_hasExistingData) {
          await updateCandlesPatternsStrategyService(
            context,
            selected,
            candleClose,
            pattern,
          );
        } else {
          await createCandlesPatternsStrategyService(
            context,
            selected,
            candleClose,
            pattern,
          );
          setState(() {
            _hasExistingData = true;
          });
        }
      } catch (e) {
        print('Erro ao salvar dados dos Padrões de Candles: $e');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShadSwitch(
              value: selected,
              onChanged: (v) => setState(() => selected = v),
              label: const Text('Selecionar Estratégia'),
            ),
            const SizedBox(height: 24),
            ShadSwitch(
              value: candleClose,
              onChanged: (v) => setState(() => candleClose = v),
              label: const Text('Operar Fechamento do Candle?'),
            ),
            const SizedBox(height: 24),
            DropdownButtonFormField<String>(
              value: pattern,
              decoration: const InputDecoration(
                labelText: 'Padrão de Candle',
                border: OutlineInputBorder(),
              ),
              items: selectOptions.map((String option) {
                return DropdownMenuItem<String>(
                  value: option,
                  child: Text(option.toUpperCase()),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    pattern = newValue;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Padrão de Candle é obrigatório';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ShadButton(
              child: Text(_hasExistingData ? 'Salvar' : 'Criar'),
              onPressed: _saveCandlesPatternsData,
            ),
          ],
        ),
      ),
    );
  }
}
