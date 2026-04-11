import 'package:flutter/material.dart';

// Função global que chama o Dialog e retorna os dados da categoria
Future<Map<String, dynamic>?> showNewCategoryDialog(BuildContext context) {
  final nomeCtrl = TextEditingController();
  
  // Cor padrão inicial
  Color corSelecionada = Colors.blue;
  bool isSaving = false;

  // Lista de opções de cores para o usuário escolher
  final List<Color> coresDisponiveis = [
    Colors.orange, Colors.blue, Colors.pink, Colors.red,
    Colors.green, Colors.teal, Colors.brown, Colors.purple, Colors.indigo
  ];

  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text('Cadastrar Nova Categoria', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 400, // Mais estreito que o de produtos pois tem menos campos
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min, // Ajusta a altura ao conteúdo
                children: [
                  TextField(
                    controller: nomeCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Nome da Categoria *', 
                      border: OutlineInputBorder()
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  const Text('Cor de destaque:', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  
                  // Seletor de Cores
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: coresDisponiveis.map((cor) {
                      final isSelected = cor == corSelecionada;
                      return GestureDetector(
                        onTap: () => setDialogState(() => corSelecionada = cor),
                        child: Container(
                          width: 42, 
                          height: 42,
                          decoration: BoxDecoration(
                            color: cor,
                            shape: BoxShape.circle,
                            border: isSelected ? Border.all(color: Colors.black87, width: 3) : null,
                            boxShadow: [
                              if (isSelected) BoxShadow(color: cor.withOpacity(0.5), blurRadius: 8)
                            ],
                          ),
                          child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 22) : null,
                        ),
                      );
                    }).toList(),
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
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('O nome da categoria é obrigatório!')));
                  return;
                }

                setDialogState(() => isSaving = true);

                // Monta o objeto da nova categoria (inicia com 0 produtos)
                final novaCategoria = {
                  'nome': nomeCtrl.text.trim(),
                  'qtdProdutos': 0, 
                  'cor': corSelecionada,
                };

                try {
                  // SIMULAÇÃO DE API
                  await Future.delayed(const Duration(seconds: 1)); 

                  if (context.mounted) {
                    Navigator.pop(context, novaCategoria); 
                  }
                } catch (e) {
                  setDialogState(() => isSaving = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red));
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