import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CandlesPatterns extends StatefulWidget {
  const CandlesPatterns({super.key});

  @override
  State<CandlesPatterns> createState() => _CandlesPatternsState();
}

class _CandlesPatternsState extends State<CandlesPatterns> {
  bool selected = false;
  bool candleClose = true;
  String pattern = 'engulfing';

  List<String> selectOptions = ['star', 'engulfing'];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(16.0),
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
          ),

          const SizedBox(height: 24),

          ShadButton(
            child: const Text('Salvar'),
            onPressed: () {
              print('Selected: $selected');
              print('CandleClose: $candleClose');
              print('CandleClose: $pattern');
            },
          ),
        ],
      ),
    );
  }
}
