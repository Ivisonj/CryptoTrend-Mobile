import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DmiForm extends StatefulWidget {
  const DmiForm({super.key});

  @override
  State<DmiForm> createState() => _DmiFormState();
}

class _DmiFormState extends State<DmiForm> {
  bool selected = false;
  bool candleClose = true;
  final TextEditingController lengthController = TextEditingController();

  @override
  void dispose() {
    lengthController.dispose();
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
            controller: lengthController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Length',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          ShadButton(
            child: const Text('Salvar'),
            onPressed: () {
              print('Selected: $selected');
              print('CandleClose: $candleClose');
              print('Length: ${lengthController.text}');
            },
          ),
        ],
      ),
    );
  }
}
