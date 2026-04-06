import 'package:flutter/material.dart';

class PromotionsAndCombosDesktop extends StatefulWidget {
  const PromotionsAndCombosDesktop({super.key});

  @override
  State<PromotionsAndCombosDesktop> createState() => _PromotionsAndCombosDesktopState();
}

class _PromotionsAndCombosDesktopState extends State<PromotionsAndCombosDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todas';

  final List<String> _filters = [
    'Todas',
    'Ativas',
    'Inativas',
    'Combos',
    'Descontos %',
    'Compre X Leve Y',
  ];

  // Dados de exemplo (em produção viria de banco ou API)
  final List<Map<String, dynamic>> _promotions = [
    {
      'name': 'Combo Família',
      'type': 'Combo',
      'description': 'Pizza + Refrigerante 2L + Batata',
      'originalPrice': 89.90,
      'promoPrice': 69.90,
      'status': 'Ativa',
      'validUntil': '30/04/2026',
    },
    {
      'name': 'Desconto 20% Lanches',
      'type': 'Desconto %',
      'description': '20% OFF em todos os lanches',
      'originalPrice': null,
      'promoPrice': null,
      'discount': 20,
      'status': 'Ativa',
      'validUntil': '15/04/2026',
    },
    {
      'name': 'Compre 2 Pague 1 Refrigerante',
      'type': 'Compre X Leve Y',
      'description': 'Leve 2 e pague apenas 1',
      'originalPrice': 13.00,
      'promoPrice': 6.50,
      'status': 'Inativa',
      'validUntil': '10/03/2026',
    },
    {
      'name': 'Happy Hour 18h-21h',
      'type': 'Desconto %',
      'description': '15% OFF em todas as bebidas',
      'discount': 15,
      'status': 'Ativa',
      'validUntil': '31/12/2026',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredPromotions = _selectedFilter == 'Todas'
        ? _promotions
        : _promotions.where((p) {
            if (_selectedFilter == 'Ativas') return p['status'] == 'Ativa';
            if (_selectedFilter == 'Inativas') return p['status'] == 'Inativa';
            return p['type'] == _selectedFilter ||
                (_selectedFilter == 'Descontos %' && p['type'] == 'Desconto %') ||
                (_selectedFilter == 'Combos' && p['type'] == 'Combo');
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
                'Promoções e Combos',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Nova Promoção / Combo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055FF),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Abrir formulário de criação
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abrindo formulário de nova promoção...')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Filtros + Busca
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar promoção ou combo...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 24),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = filter == _selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(filter),
                        onSelected: (_) => setState(() => _selectedFilter = filter),
                        selectedColor: const Color(0xFF0055FF),
                        backgroundColor: Colors.grey[200],
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Lista de promoções
          Expanded(
            child: filteredPromotions.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_offer_outlined, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Nenhuma promoção encontrada', style: TextStyle(fontSize: 20, color: Colors.grey)),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.6,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredPromotions.length,
                    itemBuilder: (context, index) {
                      final promo = filteredPromotions[index];
                      final bool isActive = promo['status'] == 'Ativa';

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: isActive ? Colors.green : Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      promo['status'],
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (promo['validUntil'] != null)
                                    Text(
                                      'Até ${promo['validUntil']}',
                                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                promo['name'],
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                promo['description'],
                                style: const TextStyle(fontSize: 15, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (promo['type'] == 'Combo' || promo['type'] == 'Compre X Leve Y')
                                    Text(
                                      'De R\$ ${promo['originalPrice']?.toStringAsFixed(2) ?? '-'}',
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  Text(
                                    promo['promoPrice'] != null
                                        ? 'Por R\$ ${promo['promoPrice'].toStringAsFixed(2)}'
                                        : '${promo['discount']}% OFF',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0055FF),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blueGrey),
                                    onPressed: () {},
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                                    onPressed: () {},
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