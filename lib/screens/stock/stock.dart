import 'package:flutter/material.dart';

class StockControlDesktop extends StatefulWidget {
  const StockControlDesktop({super.key});

  @override
  State<StockControlDesktop> createState() => _StockControlDesktopState();
}

class _StockControlDesktopState extends State<StockControlDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Todos';
  String _selectedStatus = 'Todos';

  final List<String> _categories = [
    'Todos',
    'Bebidas',
    'Lanches',
    'Sobremesas',
    'Ingredientes',
    'Limpeza',
  ];

  final List<String> _statuses = [
    'Todos',
    'Em Estoque',
    'Baixo Estoque',
    'Sem Estoque',
  ];

  // Dados de exemplo (em produção: consulta ao banco com níveis mínimos)
  final List<Map<String, dynamic>> _stockItems = [
    {
      'product': 'Hambúrguer Artesanal (kg)',
      'category': 'Lanches',
      'currentQuantity': 45,
      'minQuantity': 20,
      'unit': 'kg',
      'status': 'Em Estoque',
      'color': Colors.green,
    },
    {
      'product': 'Queijo Mussarela (kg)',
      'category': 'Ingredientes',
      'currentQuantity': 8,
      'minQuantity': 15,
      'unit': 'kg',
      'status': 'Baixo Estoque',
      'color': Colors.orange,
    },
    {
      'product': 'Refrigerante 2L',
      'category': 'Bebidas',
      'currentQuantity': 0,
      'minQuantity': 10,
      'unit': 'un.',
      'status': 'Sem Estoque',
      'color': Colors.red,
    },
    {
      'product': 'Batata Congelada (kg)',
      'category': 'Ingredientes',
      'currentQuantity': 120,
      'minQuantity': 50,
      'unit': 'kg',
      'status': 'Em Estoque',
      'color': Colors.green,
    },
    {
      'product': 'Detergente Líquido',
      'category': 'Limpeza',
      'currentQuantity': 5,
      'minQuantity': 8,
      'unit': 'un.',
      'status': 'Baixo Estoque',
      'color': Colors.orange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredStock = _stockItems.where((item) {
      final bool categoryMatch = _selectedCategory == 'Todos' || item['category'] == _selectedCategory;
      final bool statusMatch = _selectedStatus == 'Todos' || item['status'] == _selectedStatus;
      final bool searchMatch = _searchController.text.isEmpty ||
          item['product'].toLowerCase().contains(_searchController.text.toLowerCase());
      return categoryMatch && statusMatch && searchMatch;
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
                'Controle de Estoque',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Entrada no Estoque'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Abrindo registro de entrada...')),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Novo Produto'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0055FF),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Abrindo cadastro de novo produto...')),
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
                  value: _selectedStatus,
                  decoration: InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: _statuses.map((status) {
                    return DropdownMenuItem(value: status, child: Text(status));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedStatus = value!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Tabela / Grid de estoque
          Expanded(
            child: filteredStock.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 90, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Nenhum item encontrado no estoque', style: TextStyle(fontSize: 22, color: Colors.grey)),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredStock.length,
                    itemBuilder: (context, index) {
                      final item = filteredStock[index];
                      final Color statusColor = item['color'];
                      final bool isLow = item['status'] == 'Baixo Estoque' || item['status'] == 'Sem Estoque';

                      return Card(
                        elevation: 4,
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
                                      color: statusColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      item['status'],
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (isLow)
                                    const Icon(Icons.trending_down_rounded, color: Colors.red, size: 28),
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
                              const SizedBox(height: 4),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Estoque atual: ',
                                      style: TextStyle(fontSize: 16, color: Colors.black87),
                                    ),
                                    TextSpan(
                                      text: '${item['currentQuantity']} ${item['unit']}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isLow ? Colors.red : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'Mínimo: ${item['minQuantity']} ${item['unit']}',
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                                      child: const Text('Editar'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isLow ? Colors.orange : Colors.teal,
                                      ),
                                      child: Text(
                                        isLow ? 'Repor Estoque' : 'Registrar Saída',
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