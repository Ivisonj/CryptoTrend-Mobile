import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../service/CreateStochStrategyService.dart';
import '../../../service/GetStochStrategyService.dart';
import '../../../service/UpdateStochStrategyService.dart';

class StochForm extends StatefulWidget {
  const StochForm({super.key});

  @override
  State<StochForm> createState() => _StochFormState();
}

class _StochFormState extends State<StochForm> {
  bool selected = false;
  bool crossover = false;
  bool isLoading = true;
  bool _hasExistingData = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController lengthController = TextEditingController();
  late TextEditingController kSmoothingController = TextEditingController();
  late TextEditingController dSmoothingController = TextEditingController();
  late TextEditingController overboughtController = TextEditingController();
  late TextEditingController oversoldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    lengthController = TextEditingController();
    kSmoothingController = TextEditingController();
    dSmoothingController = TextEditingController();
    overboughtController = TextEditingController();
    oversoldController = TextEditingController();
    _loadStochData();
  }

  Future<void> _loadStochData() async {
    try {
      final data = await getStochStrategyService(context);

      if (data != null && mounted) {
        setState(() {
          _hasExistingData = true;
          selected = data['selected'] ?? false;
          crossover = data['crossover'] ?? false;

          if (data['length'] != null) {
            lengthController.text = data['length'].toString();
          }
          if (data['kSmoothing'] != null) {
            kSmoothingController.text = data['kSmoothing'].toString();
          }
          if (data['dSmoothing'] != null) {
            dSmoothingController.text = data['dSmoothing'].toString();
          }
          if (data['overbought'] != null) {
            overboughtController.text = data['overbought'].toString();
          }
          if (data['oversold'] != null) {
            oversoldController.text = data['oversold'].toString();
          }
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
        print('Erro ao carregar dados do Stoch: $e');
      }
    }
  }

  Future<void> _saveStochData() async {
    if (_formKey.currentState?.validate() ?? false) {
      final length = int.parse(lengthController.text.trim());
      final kSmoothing = int.parse(kSmoothingController.text.trim());
      final dSmoothing = int.parse(dSmoothingController.text.trim());
      final overbought = int.parse(overboughtController.text.trim());
      final oversold = int.parse(oversoldController.text.trim());

      try {
        if (_hasExistingData) {
          await updateStochStrategyService(
            context,
            selected,
            crossover,
            length,
            kSmoothing,
            dSmoothing,
            overbought,
            oversold,
          );
        } else {
          await createStochStrategyService(
            context,
            selected,
            crossover,
            length,
            kSmoothing,
            dSmoothing,
            overbought,
            oversold,
          );
          setState(() {
            _hasExistingData = true;
          });
        }
      } catch (e) {
        print('Erro ao salvar dados do Stoch: $e');
      }
    }
  }

  @override
  void dispose() {
    lengthController.dispose();
    kSmoothingController.dispose();
    dSmoothingController.dispose();
    overboughtController.dispose();
    oversoldController.dispose();
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
              value: crossover,
              onChanged: (v) => setState(() => crossover = v),
              label: const Text('Operar Cruzamento de Médias?'),
            ),
            const SizedBox(height: 24),
            ShadInputFormField(
              id: 'length',
              label: const Text('Length'),
              placeholder: const Text('Ex: 14'),
              controller: lengthController,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Length é obrigatório';
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
              id: 'kSmoothing',
              label: const Text('Média K'),
              placeholder: const Text('Ex: 3'),
              controller: kSmoothingController,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Média K é obrigatória';
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
              id: 'dSmoothing',
              label: const Text('Média D'),
              placeholder: const Text('Ex: 3'),
              controller: dSmoothingController,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Média D é obrigatória';
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
              id: 'overbought',
              label: const Text('Sobrecompra'),
              placeholder: const Text('Ex: 80'),
              controller: overboughtController,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Sobrecompra é obrigatória';
                }
                final intValue = int.tryParse(v.trim());
                if (intValue == null) {
                  return 'Deve ser um número válido';
                }
                if (intValue <= 0 || intValue > 100) {
                  return 'Deve estar entre 1 e 100';
                }
                final oversoldValue = int.tryParse(
                  oversoldController.text.trim(),
                );
                if (oversoldValue != null && intValue <= oversoldValue) {
                  return 'Sobrecompra deve ser maior que Sobrevenda';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ShadInputFormField(
              id: 'oversold',
              label: const Text('Sobrevenda'),
              placeholder: const Text('Ex: 20'),
              controller: oversoldController,
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Sobrevenda é obrigatória';
                }
                final intValue = int.tryParse(v.trim());
                if (intValue == null) {
                  return 'Deve ser um número válido';
                }
                if (intValue <= 0 || intValue > 100) {
                  return 'Deve estar entre 1 e 100';
                }
                final overboughtValue = int.tryParse(
                  overboughtController.text.trim(),
                );
                if (overboughtValue != null && intValue >= overboughtValue) {
                  return 'Sobrevenda deve ser menor que Sobrecompra';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ShadButton(
              child: Text(_hasExistingData ? 'Salvar' : 'Criar'),
              onPressed: _saveStochData,
            ),
          ],
        ),
      ),
    );
  }
}
