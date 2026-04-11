import 'package:flutter/material.dart';

// Função global que chama o Dialog. 
// Recebe as categorias dinâmicas e a função que salva no banco (onSave)
Future<Map<String, dynamic>?> showNewProductDialog(
  BuildContext context,
  List<String> categorias,
  Future<Map<String, dynamic>> Function(Map<String, dynamic> data) onSave,
) {
  final nomeCtrl = TextEditingController();
  final nomeComercialCtrl = TextEditingController();
  final precoCtrl = TextEditingController();
  final codigoCtrl = TextEditingController(); 
  final eanCtrl = TextEditingController();
  final descricaoCtrl = TextEditingController();
  final undPrincipalCtrl = TextEditingController();
  final undSecundariaCtrl = TextEditingController();
  final subcategoriaCtrl = TextEditingController();
  final marcaCtrl = TextEditingController();
  final modeloCtrl = TextEditingController();
  final refFabricanteCtrl = TextEditingController();
  final aplicacaoCtrl = TextEditingController();

  String categoriaSelecionada = categorias.firstWhere((c) => c != 'Todos', orElse: () => 'Bebidas');
  
  final List<IconData> availableIcons = [
    Icons.fastfood, Icons.local_pizza, Icons.local_drink, Icons.emoji_food_beverage,
    Icons.coffee, Icons.cake, Icons.icecream, Icons.restaurant, Icons.dinner_dining,
    Icons.local_dining, Icons.local_bar, Icons.breakfast_dining,
  ];
  IconData iconeSelecionado = availableIcons[0];
  
  final List<String> disponivelEm = ['Delivery', 'Salão', 'Pedido Online'];
  bool isSaving = false;

  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: false,
    builder: (context) => StatefulBuilder(
      builder: (context, setDialogState) {
        return AlertDialog(
          title: const Text('Cadastrar Novo Produto', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SizedBox(
            width: 580,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(controller: nomeCtrl, decoration: const InputDecoration(labelText: 'Nome do produto *', border: OutlineInputBorder())),
                  const SizedBox(height: 16),
                  TextField(controller: nomeComercialCtrl, decoration: const InputDecoration(labelText: 'Nome comercial (se diferente)', border: OutlineInputBorder())),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: precoCtrl, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: const InputDecoration(labelText: 'Preço (R\$) *', prefixText: 'R\$ ', border: OutlineInputBorder()))),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: categoriaSelecionada,
                          decoration: const InputDecoration(labelText: 'Categoria', border: OutlineInputBorder()),
                          items: categorias.where((c) => c != 'Todos').map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                          onChanged: (val) { if (val != null) setDialogState(() => categoriaSelecionada = val); },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: subcategoriaCtrl, decoration: const InputDecoration(labelText: 'Subcategoria', border: OutlineInputBorder()))),
                      const SizedBox(width: 16),
                      Expanded(child: TextField(controller: codigoCtrl, decoration: const InputDecoration(labelText: 'Código interno (SKU)', border: OutlineInputBorder()))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(controller: eanCtrl, decoration: const InputDecoration(labelText: 'Código de barras (EAN/UPC)', border: OutlineInputBorder())),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: undPrincipalCtrl, decoration: const InputDecoration(labelText: 'Unid. Principal (ex: kg, un)', border: OutlineInputBorder()))),
                      const SizedBox(width: 16),
                      Expanded(child: TextField(controller: undSecundariaCtrl, decoration: const InputDecoration(labelText: 'Unid. Secundária (opcional)', border: OutlineInputBorder()))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: TextField(controller: marcaCtrl, decoration: const InputDecoration(labelText: 'Marca', border: OutlineInputBorder()))),
                      const SizedBox(width: 16),
                      Expanded(child: TextField(controller: modeloCtrl, decoration: const InputDecoration(labelText: 'Modelo', border: OutlineInputBorder()))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(controller: refFabricanteCtrl, decoration: const InputDecoration(labelText: 'Referência do fabricante', border: OutlineInputBorder())),
                  const SizedBox(height: 16),
                  TextField(controller: aplicacaoCtrl, maxLines: 2, decoration: const InputDecoration(labelText: 'Aplicação ou uso (opcional)', border: OutlineInputBorder())),
                  const SizedBox(height: 16),
                  
                  const Text('Onde o produto está disponível?', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    children: ['Delivery', 'Salão', 'Pedido Online'].map((opt) {
                      final isSelected = disponivelEm.contains(opt);
                      return FilterChip(
                        label: Text(opt),
                        selected: isSelected,
                        onSelected: (selected) {
                          setDialogState(() { selected ? disponivelEm.add(opt) : disponivelEm.remove(opt); });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  TextField(controller: descricaoCtrl, maxLines: 3, decoration: const InputDecoration(labelText: 'Descrição Detalhada', border: OutlineInputBorder())),
                  const SizedBox(height: 24),
                  const Text('Escolha o ícone do produto', style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: availableIcons.length,
                      itemBuilder: (context, i) {
                        final icon = availableIcons[i];
                        final isSelected = icon == iconeSelecionado;
                        return Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                            onTap: () => setDialogState(() => iconeSelecionado = icon),
                            child: Container(
                              width: 64, height: 64,
                              decoration: BoxDecoration(
                                color: isSelected ? const Color(0xFF0055FF).withOpacity(0.15) : Colors.grey[100],
                                shape: BoxShape.circle,
                                border: isSelected ? Border.all(color: const Color(0xFF0055FF), width: 3) : null,
                              ),
                              child: Icon(icon, size: 36, color: isSelected ? const Color(0xFF0055FF) : Colors.grey[700]),
                            ),
                          ),
                        );
                      },
                    ),
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
                if (nomeCtrl.text.trim().isEmpty || precoCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nome e preço são obrigatórios!')));
                  return;
                }

                setDialogState(() => isSaving = true); 

                final preco = double.tryParse(precoCtrl.text.replaceAll(',', '.')) ?? 0.0;

                final novoProdutoData = {
                  'nome': nomeCtrl.text.trim(),
                  'nomeComercial': nomeComercialCtrl.text.trim(),
                  'preco': preco,
                  'cat': categoriaSelecionada,
                  'subcategoria': subcategoriaCtrl.text.trim(),
                  'codigo': codigoCtrl.text.trim().isEmpty ? 'AUTO-${nomeCtrl.text.substring(0, 3).toUpperCase()}' : codigoCtrl.text.trim(),
                  'ean': eanCtrl.text.trim(),
                  'unidadePrincipal': undPrincipalCtrl.text.trim(),
                  'unidadeSecundaria': undSecundariaCtrl.text.trim(),
                  'marca': marcaCtrl.text.trim(),
                  'modelo': modeloCtrl.text.trim(),
                  'referenciaFabricante': refFabricanteCtrl.text.trim(),
                  'aplicacao': aplicacaoCtrl.text.trim(),
                  'icone': iconeSelecionado, 
                  'descricao': descricaoCtrl.text.trim(),
                  'disponivelEm': disponivelEm.join(', '),
                };

                try {
                  // Aqui chamamos a função passada pelo arquivo principal (a API)
                  final savedProduct = await onSave(novoProdutoData);
                  
                  if (context.mounted) {
                    Navigator.pop(context, savedProduct); // Retorna o item salvo pro arquivo principal
                  }
                } catch (e) {
                  setDialogState(() => isSaving = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e'), backgroundColor: Colors.red));
                }
              },
              child: isSaving 
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Cadastrar Produto', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    ),
  );
}