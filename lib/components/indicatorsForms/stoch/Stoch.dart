import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class StochForm extends StatefulWidget {
  const StochForm({super.key});

  @override
  State<StochForm> createState() => _StochFormState();
}

class _StochFormState extends State<StochForm> {
  bool selected = false;
  bool crossover = false;
  final TextEditingController lengthController = TextEditingController();
  final TextEditingController kSmoothingController = TextEditingController();
  final TextEditingController dSmoothingController = TextEditingController();
  final TextEditingController overboughtController = TextEditingController();
  final TextEditingController oversoldController = TextEditingController();

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
    return Padding(
      padding: EdgeInsets.all(16.0),
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

          // EMA1 Input
          TextFormField(
            controller: kSmoothingController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Média K',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          // EMA1 Input
          TextFormField(
            controller: dSmoothingController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Média D',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          // EMA1 Input
          TextFormField(
            controller: overboughtController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Sobrecompra',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          // EMA1 Input
          TextFormField(
            controller: oversoldController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Sobrevenda',
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 24),

          ShadButton(
            child: const Text('Salvar'),
            onPressed: () {
              print('$selected');
              print('${lengthController.text}');
              print('${kSmoothingController.text}');
              print('${dSmoothingController.text}');
              print('${overboughtController.text}');
              print('${oversoldController.text}');
            },
          ),
        ],
      ),
    );
  }
}
