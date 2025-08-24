import 'package:crypttrend/service/CreateEmaStrategyService.dart';
import 'package:crypttrend/service/GetEmaStrategyService.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class EmaForm extends StatefulWidget {
  const EmaForm({super.key});

  @override
  State<EmaForm> createState() => _EmaFormState();
}

class _EmaFormState extends State<EmaForm> {
  bool selected = false;
  bool candleClose = true;
  bool isLoading = true;
  final _formKey = GlobalKey<FormState>();
  late TextEditingController ema1Controller = TextEditingController();
  late TextEditingController ema2Controller = TextEditingController();
  String baseCalcEma = 'close';

  final List<String> selectOptions = ['open', 'close', 'high', 'low'];

  @override
  void initState() {
    super.initState();
    ema1Controller = TextEditingController();
    ema2Controller = TextEditingController();
    _loadEmaData();
  }

  Future<void> _loadEmaData() async {
    try {
      final data = await getEmaStrategyService(context);

      if (data != null && mounted) {
        setState(() {
          selected = data['selected'] ?? false;
          candleClose = data['candleClose'] ?? true;
          baseCalcEma = data['baseCalcEma'] ?? 'close';

          if (data['ema1'] != null) {
            ema1Controller.text = data['ema1'].toString();
          }
          if (data['ema2'] != null) {
            ema2Controller.text = data['ema2'].toString();
          }

          isLoading = false;
        });
      } else if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        print('Erro ao carregar dados da EMA: $e');
      }
    }
  }

  @override
  void dispose() {
    ema1Controller.dispose();
    ema2Controller.dispose();
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

            ShadInputFormField(
              id: 'ema1',
              label: const Text('Média Curta'),
              placeholder: const Text('Ex: 9'),
              controller: ema1Controller,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Média Curta é obrigatória';
                }
                final intValue = int.tryParse(v.trim());
                if (intValue == null) {
                  return 'Deve ser um número válido';
                }
                if (intValue <= 0) {
                  return 'Deve ser um número positivo';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            ShadInputFormField(
              id: 'ema2',
              label: const Text('Média Longa'),
              placeholder: const Text('Ex: 21'),
              controller: ema2Controller,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Média Longa é obrigatória';
                }
                final intValue = int.tryParse(v.trim());
                if (intValue == null) {
                  return 'Deve ser um número válido';
                }
                if (intValue <= 0) {
                  return 'Deve ser um número positivo';
                }
                // Validação adicional: EMA longa deve ser maior que EMA curta
                final ema1Value = int.tryParse(ema1Controller.text.trim());
                if (ema1Value != null && intValue <= ema1Value) {
                  return 'Média Longa deve ser maior que Média Curta';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: baseCalcEma,
              decoration: const InputDecoration(
                labelText: 'Base do Cálculo',
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
                    baseCalcEma = newValue;
                  });
                }
              },
            ),

            const SizedBox(height: 24),

            ShadButton(
              child: const Text('Salvar'),
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final ema1 = int.parse(ema1Controller.text.trim());
                  final ema2 = int.parse(ema2Controller.text.trim());

                  createEmaStrategyService(
                    context,
                    selected,
                    candleClose,
                    ema1,
                    ema2,
                    baseCalcEma,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
