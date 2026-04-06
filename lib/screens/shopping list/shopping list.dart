import 'package:flutter/material.dart';

class ShoppingListDesktop extends StatefulWidget {
  const ShoppingListDesktop({super.key});

  @override
  State<ShoppingListDesktop> createState() => _ShoppingListDesktopState();
}

class _ShoppingListDesktopState extends State<ShoppingListDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedPriority = 'Todos';
  String _selectedCategory = 'Todos';

  final List<String> _priorities = [
    'Todos',
    'Urgente',
    'Médio',
    'Baixo',
  ];

  final List<String> _categories = [
    'Todos',
    'Bebidas',
    'Lanches',
    'Ingredientes',
    'Sobremesas',
    'Limpeza',
  ];

  // Dados de exemplo (em produção: gerado automaticamente do estoque baixo/zerado)
  final List<Map<String, dynamic>> _shoppingItems = [
    {
      'product': 'Queijo Mussarela (kg)',
      'category': 'Ingredientes',
      'suggestedQuantity': 20,
      'currentStock': 8,
      'minStock': 15,
      'estimatedPrice': 45.90,
      'priority': 'Urgente',
      'color': Colors.red,
    },
    {
      'product': 'Refrigerante 2L',
      'category': 'Bebidas',
      'suggestedQuantity': 30,
      'currentStock': 0,
      'minStock': 10,
      'estimatedPrice': 6.50,
      'priority': 'Urgente',
      'color': Colors.red,
    },
    {
      'product': 'Batata Congelada (kg)',
      'category': 'Ingredientes',
      'suggestedQuantity': 40,
      'currentStock': 120,
      'minStock': 50,
      'estimatedPrice': 12.90,
      'priority': 'Baixo',
      'color': Colors.green,
    },
    {
      'product': 'Detergente Líquido',
      'category': 'Limpeza',
      'suggestedQuantity': 12,
      'currentStock': 5,
      'minStock': 8,
      'estimatedPrice': 8.90,
      'priority': 'Médio',
      'color': Colors.orange,
    },
    {
      'product': 'Pão de Forma (pacote)',
      'category': 'Lanches',
      'suggestedQuantity': 15,
      'currentStock': 22,
      'minStock': 20,
      'estimatedPrice': 9.90,
      'priority': 'Baixo',
      'color': Colors.green,
    },
  ];

  double get _estimatedTotal => _shoppingItems.fold(
        0,
        (sum, item) => sum + (item['suggestedQuantity'] * item['estimatedPrice']),
      );

  @override
  Widget build(BuildContext context) {
    final filteredItems = _shoppingItems.where((item) {
      final bool priorityMatch = _selectedPriority == 'Todos' || item['priority'] == _selectedPriority;
      final bool categoryMatch = _selectedCategory == 'Todos' || item['category'] == _selectedCategory;
      final bool searchMatch = _searchController.text.isEmpty ||
          item['product'].toLowerCase().contains(_searchController.text.toLowerCase());
      return priorityMatch && categoryMatch && searchMatch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Lista de Compras / Sugestão',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  Text(
                    'Total estimado: R\$ ${_estimatedTotal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0055FF)),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.print),
                    label: const Text('Imprimir Lista'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enviando lista para impressão...')),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.checklist),
                    label: const Text('Marcar Comprados'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0055FF),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Marcando itens como comprados...')),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filtros + Busca
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por produto...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: _categories.map((cat) {
                    return DropdownMenuItem(value: cat, child: Text(cat));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedCategory = value!),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration: InputDecoration(
                    labelText: 'Prioridade',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: _priorities.map((prio) {
                    return DropdownMenuItem(value: prio, child: Text(prio));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedPriority = value!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Lista de sugestões de compras
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.shopping_cart_outlined, size: 90, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Nenhum item sugerido para compra no momento', style: TextStyle(fontSize: 22, color: Colors.grey)),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final Color priorityColor = item['color'];
                      final bool isUrgent = item['priority'] == 'Urgente';

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: priorityColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      item['priority'],
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (isUrgent)
                                    const Icon(Icons.priority_high_rounded, color: Colors.red, size: 28),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item['product'],
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Categoria: ${item['category']}',
                                style: const TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Sugestão: ',
                                      style: TextStyle(fontSize: 15, color: Colors.black87),
                                    ),
                                    TextSpan(
                                      text: '${item['suggestedQuantity']} ${item['unit']}',
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0055FF)),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Estoque atual: ${item['currentQuantity']} (mín: ${item['minStock']})',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: item['currentQuantity'] < item['minStock'] ? Colors.red : Colors.black87,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFF0055FF)),
                                      ),
                                      child: const Text('Editar Qtd'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isUrgent ? Colors.red : Colors.green,
                                      ),
                                      child: Text(
                                        isUrgent ? 'Comprar Agora' : 'Adicionar ao Carrinho',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}