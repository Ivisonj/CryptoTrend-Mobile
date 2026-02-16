import 'package:flutter/material.dart';
import '../../service/getLLMsService.dart';
import '../../service/getAgentConfigSettingsService.dart';
import '../../service/UpdateAgentConfigSettingsService.dart';
import 'package:flutter/material.dart';

class AgentSettings extends StatefulWidget {
  const AgentSettings({Key? key}) : super(key: key);

  @override
  State<AgentSettings> createState() => _AgentSettingsState();
}

class _AgentSettingsState extends State<AgentSettings> {
  List<Map<String, dynamic>> llmList = [];
  dynamic selectedLlmId;
  String? selectedLlmName;
  TextEditingController promptController = TextEditingController();
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    promptController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    await _getLLMs();
    await _getAgentConfig();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _getLLMs() async {
    final llms = await getLLMsService(context);
    if (llms != null) {
      setState(() {
        llmList = llms;
      });
    }
  }

  Future<void> _getAgentConfig() async {
    final config = await getAgentConfigSettingsService(context);

    if (config != null) {
      setState(() {
        promptController.text = config['prompt'] ?? '';

        if (config['llm'] != null) {
          String llmName = config['llm'].toString();
          selectedLlmName = llmName;

          final matchingLlm = llmList.firstWhere(
            (llm) => llm['name'] == llmName,
            orElse: () => {},
          );

          if (matchingLlm.isNotEmpty) {
            selectedLlmId = matchingLlm['id'];
          }
        }
      });
    }
  }

  Future<void> _saveAgentConfig() async {
    if (selectedLlmId == null) {
      var snackBar = SnackBar(
        content: Text('Por favor, selecione um LLM'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    if (promptController.text.trim().isEmpty) {
      var snackBar = SnackBar(
        content: Text('Por favor, insira um prompt'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    setState(() {
      isSaving = true;
    });

    await updateAgentConfigService(
      context,
      llmId: selectedLlmId!,
      prompt: promptController.text.trim(),
    );

    setState(() {
      isSaving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Treinar Agente',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLlmSelector(),
                  const SizedBox(height: 24),
                  _buildPromptInput(),
                  const SizedBox(height: 24),
                  _buildSaveButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildLlmSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione o LLM',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<dynamic>(
              value: selectedLlmId,
              isExpanded: true,
              hint: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('Selecione um LLM'),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              items: llmList.map((llm) {
                return DropdownMenuItem<dynamic>(
                  value: llm['id'],
                  child: Text(llm['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedLlmId = value;
                  final selectedLlm = llmList.firstWhere(
                    (llm) => llm['id'] == value,
                  );
                  selectedLlmName = selectedLlm['name'];
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPromptInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Prompt de Instrução',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: promptController,
          maxLines: 8,
          decoration: InputDecoration(
            hintText: 'Descreva sua forma de operar...',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: isSaving ? null : _saveAgentConfig,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: isSaving
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Salvar Treinamento',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
    );
  }
}
