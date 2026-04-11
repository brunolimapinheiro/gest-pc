import 'package:flutter/material.dart';

// Função global que chama o Dialog e retorna os dados da promoção (ou null se cancelar)
Future<Map<String, dynamic>?> showNewPromoDialog(BuildContext context) {
  final nomeCtrl = TextEditingController();
  final precoOrigCtrl = TextEditingController();
  final precoPromoCtrl = TextEditingController();
  final descontoCtrl = TextEditingController();
  final validadeCtrl = TextEditingController();
  final descricaoCtrl = TextEditingController();

  String tipoSelecionado = 'Combo';
  String statusSelecionado = 'Ativa';
  bool isSaving = false;

  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false, // Evita fechar clicando fora enquanto salva
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text('Cadastrar Nova Promoção', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 580,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nomeCtrl, 
                    decoration: const InputDecoration(labelText: 'Nome da promoção ou combo *', border: OutlineInputBorder())
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: tipoSelecionado,
                          decoration: const InputDecoration(labelText: 'Tipo', border: OutlineInputBorder()),
                          items: ['Combo', 'Desconto %', 'Compre X Leve Y'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (val) { if (val != null) setDialogState(() => tipoSelecionado = val); },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: statusSelecionado,
                          decoration: const InputDecoration(labelText: 'Status', border: OutlineInputBorder()),
                          items: ['Ativa', 'Inativa'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (val) { if (val != null) setDialogState(() => statusSelecionado = val); },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: precoOrigCtrl, 
                          keyboardType: const TextInputType.numberWithOptions(decimal: true), 
                          decoration: const InputDecoration(labelText: 'Preço Original (R\$)', prefixText: 'R\$ ', border: OutlineInputBorder())
                        )
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: precoPromoCtrl, 
                          keyboardType: const TextInputType.numberWithOptions(decimal: true), 
                          decoration: const InputDecoration(labelText: 'Preço Promocional (R\$)', prefixText: 'R\$ ', border: OutlineInputBorder())
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: descontoCtrl, 
                          keyboardType: TextInputType.number, 
                          decoration: const InputDecoration(labelText: 'Desconto (%)', suffixText: '%', border: OutlineInputBorder())
                        )
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: validadeCtrl, 
                          decoration: const InputDecoration(labelText: 'Válido até (ex: 31/12/2026)', border: OutlineInputBorder())
                        )
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descricaoCtrl, 
                    maxLines: 3, 
                    decoration: const InputDecoration(labelText: 'Descrição Detalhada', border: OutlineInputBorder())
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              // Retorna null para indicar que a ação foi cancelada
              onPressed: isSaving ? null : () => Navigator.pop(context, null),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: isSaving ? null : () async {
                if (nomeCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('O nome da promoção é obrigatório!')));
                  return;
                }

                setDialogState(() => isSaving = true);

                final precoOrig = double.tryParse(precoOrigCtrl.text.replaceAll(',', '.'));
                final precoPromo = double.tryParse(precoPromoCtrl.text.replaceAll(',', '.'));
                final desconto = int.tryParse(descontoCtrl.text);

                final novaPromoData = {
                  'name': nomeCtrl.text.trim(),
                  'type': tipoSelecionado,
                  'description': descricaoCtrl.text.trim(),
                  'originalPrice': precoOrig,
                  'promoPrice': precoPromo,
                  'discount': desconto,
                  'status': statusSelecionado,
                  'validUntil': validadeCtrl.text.trim().isEmpty ? null : validadeCtrl.text.trim(),
                };

                try {
                  // SIMULAÇÃO DE API
                  await Future.delayed(const Duration(seconds: 1)); 

                  if (context.mounted) {
                    // Passa os dados de volta para a tela principal!
                    Navigator.pop(context, novaPromoData); 
                  }
                } catch (e) {
                  setDialogState(() => isSaving = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red));
                }
              },
              child: isSaving 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Cadastrar Promoção', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ),
  );
}