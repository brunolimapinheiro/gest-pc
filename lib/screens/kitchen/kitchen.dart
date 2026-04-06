import 'package:flutter/material.dart';

class KdsKitchenDesktop extends StatefulWidget {
  const KdsKitchenDesktop({super.key});

  @override
  State<KdsKitchenDesktop> createState() => _KdsKitchenDesktopState();
}

class _KdsKitchenDesktopState extends State<KdsKitchenDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';

  final List<String> _filters = [
    'Todos',
    'Pendentes',
    'Em Preparo',
    'Prontos',
    'Cancelados',
  ];

  // Dados de exemplo (em produção: realtime com Firebase ou WebSocket)
  final List<Map<String, dynamic>> _kitchenOrders = [
    {
      'orderId': 'CMD-001',
      'table': 'Mesa 05',
      'customer': 'João Silva',
      'items': ['Hambúrguer Clássico x2', 'Batata Frita', 'Coca 2L'],
      'status': 'Pendente',
      'timeElapsed': '8 min',
      'priority': 'Alta',
      'color': Colors.red,
    },
    {
      'orderId': 'CMD-008',
      'table': 'Mesa 12',
      'customer': 'Pedro Santos',
      'items': ['Pizza Marguerita Família', 'Refrigerante 1L', 'Sobremesa'],
      'status': 'Em Preparo',
      'timeElapsed': '22 min',
      'priority': 'Média',
      'color': Colors.orange,
    },
    {
      'orderId': 'CMD-015',
      'table': 'Mesa 03',
      'customer': 'Lucas Ferreira',
      'items': ['X-Tudo', 'Milk Shake'],
      'status': 'Pronto',
      'timeElapsed': '35 min',
      'priority': 'Baixa',
      'color': Colors.green,
    },
    {
      'orderId': 'CMD-022',
      'table': 'Delivery #45',
      'customer': 'Ana Costa',
      'items': ['Porção de Pastel', 'Guaraná 1L'],
      'status': 'Pendente',
      'timeElapsed': '45 min',
      'priority': 'Urgente',
      'color': Colors.deepOrange,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredOrders = _selectedFilter == 'Todos'
        ? _kitchenOrders
        : _kitchenOrders.where((order) => order['status'] == _selectedFilter).toList();

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
                'KDS - Cozinha',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Atualizar Pedidos'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Atualizando pedidos da cozinha...')),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.print),
                    label: const Text('Imprimir Pendentes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0055FF),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Enviando para impressão...')),
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
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por mesa, cliente ou item...',
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

          // Lista de pedidos na cozinha
          Expanded(
            child: filteredOrders.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.kitchen_outlined, size: 90, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Nenhum pedido na cozinha no momento', style: TextStyle(fontSize: 22, color: Colors.grey)),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.45,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      final Color statusColor = order['color'];
                      final bool isUrgent = order['priority'] == 'Urgente' || order['timeElapsed'].contains('45');

                      return Card(
                        elevation: 6,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        color: statusColor.withOpacity(0.12),
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
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (isUrgent)
                                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                order['orderId'],
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${order['table']} - ${order['customer']}',
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Aberto há ${order['timeElapsed']}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: isUrgent ? Colors.red : Colors.grey[700],
                                  fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const Divider(height: 20),
                              const Text('Itens:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              ...order['items'].map<Widget>((item) => Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text('• $item', style: const TextStyle(fontSize: 14)),
                                  )),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (order['status'] == 'Pendente')
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                        child: const Text('Iniciar Preparo'),
                                      ),
                                    ),
                                  if (order['status'] == 'Em Preparo')
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                        child: const Text('Pronto para Retirada'),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.cancel, color: Colors.redAccent),
                                    onPressed: () {},
                                    tooltip: 'Cancelar Pedido',
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