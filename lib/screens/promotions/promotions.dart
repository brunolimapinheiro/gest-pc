import 'package:flutter/material.dart';
// IMPORTANTE: Importe o arquivo que você criou acima! Exemplo:
 import 'new_promo_dialog.dart'; 

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
  ];

  @override
  Widget build(BuildContext context) {
    // === LÓGICA DE RESPONSIVIDADE ===
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;
    double aspectRatio;
    double paddingGeral;
    double titleSize;
    double descSize;
    double priceSize;
    double oldPriceSize; 
    double tagSize;
    double cardPadding;
    double spacing;
    double headerTextSize;

    if (screenWidth >= 900) {
      crossAxisCount = 3;
      aspectRatio = 1.6;
      paddingGeral = 32;
      titleSize = 20;
      descSize = 14;
      priceSize = 16; 
      oldPriceSize = 13;
      tagSize = 13;
      cardPadding = 16;
      spacing = 12;
      headerTextSize = 32;
    } else if (screenWidth >= 700) {
      crossAxisCount = 3;
      aspectRatio = 1.15; 
      paddingGeral = 24;
      titleSize = 16;
      descSize = 12;
      priceSize = 14; 
      oldPriceSize = 11;
      tagSize = 11;
      cardPadding = 12;
      spacing = 8;
      headerTextSize = 26;
    } else if (screenWidth >= 500) {
      crossAxisCount = 2;
      aspectRatio = 1.25; 
      paddingGeral = 16;
      titleSize = 15;
      descSize = 12;
      priceSize = 13; 
      oldPriceSize = 11;
      tagSize = 11;
      cardPadding = 12;
      spacing = 8;
      headerTextSize = 22;
    } else {
      crossAxisCount = 1;
      aspectRatio = 2.2; 
      paddingGeral = 16;
      titleSize = 18;
      descSize = 13;
      priceSize = 16; 
      oldPriceSize = 12;
      tagSize = 12;
      cardPadding = 16;
      spacing = 12;
      headerTextSize = 20;
    }

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
      padding: EdgeInsets.all(paddingGeral),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              Text(
                'Promoções e Combos',
                style: TextStyle(fontSize: headerTextSize, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(screenWidth < 600 ? 'Nova' : 'Nova Promoção / Combo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055FF),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: screenWidth < 700 ? 12 : 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                // ==============================================================
                // CHAMANDO O ARQUIVO EXTERNO E ATUALIZANDO A LISTA
                // ==============================================================
                onPressed: () async {
                  // Abre o dialog do outro arquivo e espera o resultado
                  final novaPromoData = await showNewPromoDialog(context);
                  
                  // Se o usuário clicou em 'Cadastrar' e retornou os dados (não foi null)
                  if (novaPromoData != null) {
                    setState(() {
                      _promotions.add(novaPromoData);
                    });
                    
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ Promoção cadastrada com sucesso!'), backgroundColor: Colors.green)
                      );
                    }
                  }
                },
              ),
            ],
          ),
          SizedBox(height: screenWidth < 700 ? 16 : 24),

          // Filtros + Busca
          screenWidth < 700
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                    _buildFiltersRow(tagSize),
                  ],
                )
              : Row(
                  children: [
                    Expanded(flex: 2, child: _buildSearchBar()),
                    const SizedBox(width: 24),
                    Expanded(flex: 3, child: _buildFiltersRow(tagSize)),
                  ],
                ),
          
          SizedBox(height: screenWidth < 700 ? 16 : 32),

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
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: aspectRatio,
                      crossAxisSpacing: screenWidth < 700 ? 12 : 16,
                      mainAxisSpacing: screenWidth < 700 ? 12 : 16,
                    ),
                    itemCount: filteredPromotions.length,
                    itemBuilder: (context, index) {
                      final promo = filteredPromotions[index];
                      final bool isActive = promo['status'] == 'Ativa';

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: EdgeInsets.all(cardPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isActive ? Colors.green : Colors.red,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      promo['status'],
                                      style: TextStyle(
                                        color: Colors.white, 
                                        fontWeight: FontWeight.bold,
                                        fontSize: tagSize
                                      ),
                                    ),
                                  ),
                                  if (promo['validUntil'] != null)
                                    Text(
                                      'Até ${promo['validUntil']}',
                                      style: TextStyle(fontSize: tagSize, color: Colors.grey),
                                    ),
                                ],
                              ),
                              SizedBox(height: spacing),
                              
                              Text(
                                promo['name'],
                                style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 4),
                              Text(
                                promo['description'],
                                style: TextStyle(fontSize: descSize, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              
                              const Spacer(), 
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  if (promo['type'] == 'Combo' || promo['type'] == 'Compre X Leve Y')
                                    Flexible(
                                      child: Text(
                                        'De R\$ ${promo['originalPrice']?.toStringAsFixed(2) ?? '-'}',
                                        style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey,
                                          fontSize: oldPriceSize,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  Flexible(
                                    child: Text(
                                      promo['promoPrice'] != null
                                          ? 'Por R\$ ${promo['promoPrice'].toStringAsFixed(2)}'
                                          : '${promo['discount']}% OFF',
                                      style: TextStyle(
                                        fontSize: priceSize,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF0055FF),
                                      ),
                                      textAlign: TextAlign.right,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              
                              SizedBox(height: spacing / 2),
                              const Divider(height: 1, thickness: 0.5, color: Colors.black12),
                              SizedBox(height: spacing / 2),
                              
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(Icons.edit, color: Colors.blueGrey, size: titleSize),
                                    onPressed: () {},
                                  ),
                                  const SizedBox(width: 16),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: Icon(Icons.delete, color: Colors.redAccent, size: titleSize),
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

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Buscar promoção ou combo...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildFiltersRow(double tagSize) {
    return SingleChildScrollView(
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
                fontSize: tagSize + 1, 
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}