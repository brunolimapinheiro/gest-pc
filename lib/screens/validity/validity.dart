import 'package:flutter/material.dart';

class ExpirationsDesktop extends StatefulWidget {
  const ExpirationsDesktop({super.key});

  @override
  State<ExpirationsDesktop> createState() => _ExpirationsDesktopState();
}

class _ExpirationsDesktopState extends State<ExpirationsDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';

  final List<String> _filters = [
    'Todos',
    'Vencidos',
    'Próximos 7 Dias',
    'Próximos 30 Dias',
    'OK (>30 Dias)',
  ];

  // Dados de exemplo (em produção: consulta ao estoque com datas)
  final List<Map<String, dynamic>> _expirations = [
    {
      'product': 'Leite Integral 1L',
      'batch': 'LOTE-0456',
      'quantity': 18,
      'expirationDate': '25/03/2026',
      'daysLeft': -3,
      'status': 'Vencido',
      'color': Colors.red,
    },
    {
      'product': 'Queijo Mussarela',
      'batch': 'LOTE-0789',
      'quantity': 12,
      'expirationDate': '28/03/2026',
      'daysLeft': 0,
      'status': 'Vencendo Hoje',
      'color': Colors.deepOrange,
    },
    {
      'product': 'Pão de Forma',
      'batch': 'LOTE-1123',
      'quantity': 45,
      'expirationDate': '02/04/2026',
      'daysLeft': 5,
      'status': 'Próximos 7 Dias',
      'color': Colors.orange,
    },
    {
      'product': 'Refrigerante 2L',
      'batch': 'LOTE-3345',
      'quantity': 30,
      'expirationDate': '15/05/2026',
      'daysLeft': 48,
      'status': 'OK',
      'color': Colors.green,
    },
    {
      'product': 'Presunto Fatiado',
      'batch': 'LOTE-5678',
      'quantity': 8,
      'expirationDate': '20/03/2026',
      'daysLeft': -8,
      'status': 'Vencido',
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredItems = _selectedFilter == 'Todos'
        ? _expirations
        : _expirations.where((item) {
            if (_selectedFilter == 'Vencidos') return item['daysLeft'] <= 0;
            if (_selectedFilter == 'Próximos 7 Dias') return item['daysLeft'] > 0 && item['daysLeft'] <= 7;
            if (_selectedFilter == 'Próximos 30 Dias') return item['daysLeft'] > 7 && item['daysLeft'] <= 30;
            if (_selectedFilter == 'OK (>30 Dias)') return item['daysLeft'] > 30;
            return true;
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
                'Validades / Próximas a Vencer',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add_alert),
                label: const Text('Registrar Nova Validade'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055FF),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abrindo cadastro de validade...')),
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
                    hintText: 'Buscar por produto, lote...',
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

          // Lista de validades
          Expanded(
            child: filteredItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.warning_amber_outlined, size: 90, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Nenhum item com validade próxima ou vencida', style: TextStyle(fontSize: 22, color: Colors.grey)),
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
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      final Color statusColor = item['color'];
                      final bool isCritical = item['daysLeft'] <= 0 || item['daysLeft'] <= 3;

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
                                      color: statusColor,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      item['status'],
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (isCritical)
                                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                item['product'],
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Lote: ${item['batch']} • ${item['quantity']} un.',
                                style: const TextStyle(fontSize: 15, color: Colors.grey),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Vence em: ${item['expirationDate']}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: item['daysLeft'] <= 0 ? Colors.red : item['daysLeft'] <= 7 ? Colors.orange : Colors.green,
                                ),
                              ),
                              if (item['daysLeft'] <= 0)
                                Text(
                                  'Venceu há ${item['daysLeft'].abs()} dias',
                                  style: const TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.bold),
                                )
                              else
                                Text(
                                  'Faltam ${item['daysLeft']} dias',
                                  style: const TextStyle(fontSize: 14, color: Colors.black87),
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
                                        backgroundColor: item['daysLeft'] <= 0 ? Colors.red : Colors.teal,
                                      ),
                                      child: Text(
                                        item['daysLeft'] <= 0 ? 'Descartar' : 'Vendido/Doado',
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