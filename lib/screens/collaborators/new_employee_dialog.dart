import 'package:flutter/material.dart';

Future<Map<String, dynamic>?> showNewEmployeeDialog(BuildContext context) {
  final nomeCtrl = TextEditingController();
  final telefoneCtrl = TextEditingController();
  final cpfCtrl = TextEditingController();

  String cargoSelecionado = 'Atendente / Garçom';
  String acessoSelecionado = 'Operador (Acesso Limitado)';
  bool isSaving = false;

  final List<String> cargos = ['Gerente', 'Caixa', 'Atendente / Garçom', 'Cozinha', 'Entregador'];
  final List<String> niveisAcesso = ['Administrador (Acesso Total)', 'Operador (Acesso Limitado)', 'Sem Acesso ao Sistema'];

  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text('Cadastrar Colaborador', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nomeCtrl,
                    decoration: const InputDecoration(labelText: 'Nome Completo *', border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: cpfCtrl,
                          decoration: const InputDecoration(labelText: 'CPF (Opcional)', border: OutlineInputBorder()),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: telefoneCtrl,
                          decoration: const InputDecoration(labelText: 'Telefone', border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  const Text('Função e Permissões', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<String>(
                    value: cargoSelecionado,
                    decoration: const InputDecoration(labelText: 'Cargo na Loja', border: OutlineInputBorder()),
                    items: cargos.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) { if (val != null) setDialogState(() => cargoSelecionado = val); },
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: acessoSelecionado,
                    decoration: const InputDecoration(labelText: 'Nível de Acesso no App', border: OutlineInputBorder()),
                    items: niveisAcesso.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                    onChanged: (val) { if (val != null) setDialogState(() => acessoSelecionado = val); },
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
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: isSaving ? null : () async {
                if (nomeCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('O nome é obrigatório!')));
                  return;
                }

                setDialogState(() => isSaving = true);

                final novoColaborador = {
                  'nome': nomeCtrl.text.trim(),
                  'telefone': telefoneCtrl.text.trim(),
                  'cargo': cargoSelecionado,
                  'acesso': acessoSelecionado,
                  'status': 'Ativo',
                };

                try {
                  await Future.delayed(const Duration(milliseconds: 800)); // Simula API
                  if (context.mounted) Navigator.pop(context, novoColaborador);
                } catch (e) {
                  setDialogState(() => isSaving = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e'), backgroundColor: Colors.red));
                }
              },
              child: isSaving 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Cadastrar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ),
  );
}