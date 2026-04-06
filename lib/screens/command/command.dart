import 'package:flutter/material.dart';

class OpenOrdersDesktop extends StatefulWidget {
  const OpenOrdersDesktop({super.key});

  @override
  State<OpenOrdersDesktop> createState() => _OpenOrdersDesktopState();
}

class _OpenOrdersDesktopState extends State<OpenOrdersDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todas';

  final List<String> _filters = [
    'Todas',
    'Abertas',
    'Aguardando Pagamento',
    'Em Preparo',
    'Prontas para Entrega',
    'Canceladas',
  ];

  // Dados de exemplo (em produção viria de banco ou Firebase/Realtime)
  final List<Map<String, dynamic>> _openOrders = [
    {
      'orderId': 'CMD-001',
      'customer': 'João Silva',
      'type': 'Mesa 05',
      'itemsCount': 4,
      'total': 78.50,
      'status': 'Em Preparo',
      'timeOpened': '14:32',
      'timeElapsed': '28 min',
      'color': Colors.orange,
    },
    {
      'orderId': 'PED-127',
      'customer': 'Maria Oliveira',
      'type': 'Delivery',
      'itemsCount': 3,
      'total': 45.90,
      'status': 'Aguardando Pagamento',
      'timeOpened': '15:10',
      'timeElapsed': '12 min',
      'color': Colors.blue,
    },
    {
      'orderId': 'CMD-008',
      'customer': 'Pedro Santos',
      'type': 'Mesa 12',
      'itemsCount': 6,
      'total': 112.00,
      'status': 'Pronta para Entrega',
      'timeOpened': '13:45',
      'timeElapsed': '1h 15min',
      'color': Colors.green,
    },
    {
      'orderId': 'PED-089',
      'customer': 'Ana Costa',
      'type': 'Balcão',
      'itemsCount': 2,
      'total': 29.90,
      'status': 'Abertas',
      'timeOpened': '15:45',
      'timeElapsed': '5 min',
      'color': Colors.grey,
    },
    {
      'orderId': 'CMD-015',
      'customer': 'Lucas Ferreira',
      'type': 'Mesa 03',
      'itemsCount': 5,
      'total': 98.70,
      'status': 'Canceladas',
      'timeOpened': '14:20',
      'timeElapsed': '45 min',
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _selectedFilter == 'Todas'
        ? _openOrders
        : _openOrders.where((order) {
            if (_selectedFilter == 'Abertas') return order['status'] == 'Abertas';
            if (_selectedFilter == 'Canceladas') return order['status'] == 'Canceladas';
            return order['status'] == _selectedFilter;
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
                'Comandas Abertas / Pedidos em Aberto',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Nova Comanda / Pedido'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055FF),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abrindo nova comanda...')),
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
                    hintText: 'Buscar por cliente, mesa, número...',
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

          // Lista de comandas/pedidos
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 90, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Nenhuma comanda/pedido aberto encontrado', style: TextStyle(fontSize: 22, color: Colors.grey)),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.55,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      final Color statusColor = order['color'];

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
                                      order['status'],
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ),
                                  Text(
                                    order['timeElapsed'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: order['timeElapsed'].contains('h') ? Colors.red : Colors.grey[700],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                order['orderId'],
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                order['customer'],
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                              Text(
                                order['type'],
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${order['itemsCount']} itens',
                                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                                  ),
                                  Text(
                                    'R\$ ${order['total'].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0055FF),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {},
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Color(0xFF0055FF)),
                                      ),
                                      child: const Text('Ver Detalhes'),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {},
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: statusColor,
                                      ),
                                      child: Text(
                                        order['status'] == 'Pronta para Entrega' ? 'Entregar' : 'Ações',
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