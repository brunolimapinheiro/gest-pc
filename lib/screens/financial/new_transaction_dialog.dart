import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showNewTransactionDialog(BuildContext context) {
  final descricaoCtrl = TextEditingController();
  final valorCtrl = TextEditingController();
  final dataCtrl = TextEditingController(text: '11/04/2026'); // Exemplo de data atual

  String tipoSelecionado = 'Receita';
  bool isSaving = false;

  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text('Nova Transação', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 450,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tipo de Transação (Visualmente destacado)
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setDialogState(() => tipoSelecionado = 'Receita'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: tipoSelecionado == 'Receita' ? Colors.green.withOpacity(0.15) : Colors.grey[100],
                              border: Border.all(color: tipoSelecionado == 'Receita' ? Colors.green : Colors.transparent, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('Receita (+)', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setDialogState(() => tipoSelecionado = 'Despesa'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: tipoSelecionado == 'Despesa' ? Colors.red.withOpacity(0.15) : Colors.grey[100],
                              border: Border.all(color: tipoSelecionado == 'Despesa' ? Colors.red : Colors.transparent, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Text('Despesa (-)', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  TextField(
                    controller: descricaoCtrl,
                    decoration: const InputDecoration(labelText: 'Descrição (Ex: Venda, Conta de Luz)', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: valorCtrl,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          decoration: const InputDecoration(labelText: 'Valor (R\$)', prefixText: 'R\$ ', border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          controller: dataCtrl,
                          decoration: const InputDecoration(labelText: 'Data', border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSaving ? null : () => Navigator.pop(context, null),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0055FF)),
              onPressed: isSaving ? null : () async {
                if (descricaoCtrl.text.trim().isEmpty || valorCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Descrição e valor são obrigatórios!')));
                  return;
                }

                setDialogState(() => isSaving = true);

                final valor = double.tryParse(valorCtrl.text.replaceAll(',', '.')) ?? 0.0;

                final novaTransacao = {
                  'descricao': descricaoCtrl.text.trim(),
                  'tipo': tipoSelecionado,
                  'valor': valor,
                  'data': dataCtrl.text.trim(),
                };

                try {
                  await Future.delayed(const Duration(milliseconds: 800)); // Simula API
                  if (context.mounted) Navigator.pop(context, novaTransacao);
                } catch (e) {
                  setDialogState(() => isSaving = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
                }
              },
              child: isSaving 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Salvar Transação', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ),
  );
}