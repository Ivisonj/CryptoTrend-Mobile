import 'package:crypttrend/service/GetDmiStrategyService.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../service/CreateDmiStrategyService.dart';
import '../../../service/UpdateDmiStrategyService.dart';

class DmiForm extends StatefulWidget {
  const DmiForm({super.key});

  @override
  State<DmiForm> createState() => _DmiFormState();
}

class _DmiFormState extends State<DmiForm> {
  bool selected = false;
  bool candleClose = false;
  bool isLoading = true;
  bool _hasExistingData = false;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController lengthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    lengthController = TextEditingController();
    _loadDmiData();
  }

  Future<void> _loadDmiData() async {
    try {
      final data = await getDmiStrategyService(context);

      if (data != null && mounted) {
        setState(() {
          _hasExistingData = true;
          selected = data['selected'] ?? false;
          candleClose = data['candleClose'] ?? true;

          if (data['length'] != null) {
            lengthController.text = data['length'].toString();
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
        print('Erro ao carregar dados do DMI: $e');
      }
    }
  }

  Future<void> _saveDmiData() async {
    if (_formKey.currentState?.validate() ?? false) {
      final length = int.parse(lengthController.text.trim());

      try {
        if (_hasExistingData) {
          await updateDmiStrategyService(
            context,
            selected,
            candleClose,
            length,
          );
        } else {
          await createDmiStrategyService(
            context,
            selected,
            candleClose,
            length,
          );
          setState(() {
            _hasExistingData = true;
          });
        }
      } catch (e) {
        print('Erro ao salvar dados do DMI: $e');
      }
    }
  }

  @override
  void dispose() {
    lengthController.dispose();
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
            const SizedBox(height: 24),
            ShadButton(
              child: Text(_hasExistingData ? 'Salvar' : 'Criar'),
              onPressed: _saveDmiData,
            ),
          ],
        ),
      ),
    );
  }
}
