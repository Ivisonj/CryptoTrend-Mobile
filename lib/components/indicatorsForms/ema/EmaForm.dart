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
  final TextEditingController ema1Controller = TextEditingController();
  final TextEditingController ema2Controller = TextEditingController();
  String baseCalcEma = 'close';

  final List<String> selectOptions = ['open', 'close', 'high', 'low'];

  @override
  void dispose() {
    ema1Controller.dispose();
    ema2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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

          // EMA1 Input
          TextFormField(
            controller: ema1Controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Média Curta',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          // EMA2 Input
          TextFormField(
            controller: ema2Controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Média Longa',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 16),

          // Select/Dropdown
          DropdownButtonFormField<String>(
            value: baseCalcEma,
            decoration: const InputDecoration(
              labelText: 'Base do Calculo',
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
              print('Selected: $selected');
              print('CandleClose: $candleClose');
              print('EMA1: ${ema1Controller.text}');
              print('EMA2: ${ema2Controller.text}');
              print('Selected: $baseCalcEma');
            },
          ),
        ],
      ),
    );
  }
}
