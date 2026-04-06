import 'package:flutter/material.dart';

class DeliveryManagementDesktop extends StatefulWidget {
  const DeliveryManagementDesktop({super.key});

  @override
  State<DeliveryManagementDesktop> createState() => _DeliveryManagementDesktopState();
}

class _DeliveryManagementDesktopState extends State<DeliveryManagementDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';

  final List<String> _filters = [
    'Todos',
    'Pendentes',
    'Em Rota',
    'Entregues',
    'Cancelados',
  ];

  // Dados de exemplo (em produção: realtime + integração com mapa/endereço)
  final List<Map<String, dynamic>> _deliveries = [
    {
      'orderId': 'PED-127',
      'customer': 'Maria Oliveira',
      'address': 'Rua das Flores, 123 - Centro, Teresina-PI',
      'distance': '3.2 km',
      'total': 45.90,
      'status': 'Pendente',
      'timeElapsed': '18 min',
      'deliveryPerson': null,
      'color': Colors.orange,
      'priority': 'Alta',
    },
    {
      'orderId': 'PED-089',
      'customer': 'Ana Costa',
      'address': 'Av. Frei Serafim, 456 - Fátima',
      'distance': '5.8 km',
      'total': 78.00,
      'status': 'Em Rota',
      'timeElapsed': '42 min',
      'deliveryPerson': 'Carlos Motoboy',
      'color': Colors.blue,
      'priority': 'Média',
    },
    {
      'orderId': 'PED-204',
      'customer': 'Rafael Lima',
      'address': 'Conjunto Santa Maria, Qd 07 Lt 12',
      'distance': '1.9 km',
      'total': 32.50,
      'status': 'Entregue',
      'timeElapsed': '1h 05min',
      'deliveryPerson': 'João Motoboy',
      'color': Colors.green,
      'priority': 'Baixa',
    },
    {
      'orderId': 'PED-315',
      'customer': 'Fernanda Souza',
      'address': 'Rua 15 de Novembro, 789 - Dirceu',
      'distance': '7.1 km',
      'total': 119.90,
      'status': 'Cancelados',
      'timeElapsed': '25 min',
      'deliveryPerson': null,
      'color': Colors.red,
      'priority': 'N/A',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredDeliveries = _selectedFilter == 'Todos'
        ? _deliveries
        : _deliveries.where((delivery) => delivery['status'] == _selectedFilter).toList();

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
                'Delivery / Entregas',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Novo Pedido Delivery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0055FF),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Abrindo novo pedido delivery...')),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.motorcycle),
                    label: const Text('Gerenciar Motoboys'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Abrindo gerenciamento de motoboys...')),
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
                    hintText: 'Buscar por cliente, pedido, endereço...',
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

          // Lista de entregas
          Expanded(
            child: filteredDeliveries.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delivery_dining_outlined, size: 90, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Nenhum pedido de delivery no momento', style: TextStyle(fontSize: 22, color: Colors.grey)),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.5,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredDeliveries.length,
                    itemBuilder: (context, index) {
                      final delivery = filteredDeliveries[index];
                      final Color statusColor = delivery['color'];
                      final bool isUrgent = delivery['timeElapsed'].contains('45') || delivery['priority'] == 'Alta';

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
                                      delivery['status'],
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (isUrgent)
                                    const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                delivery['orderId'],
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                delivery['customer'],
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              Text(
                                delivery['address'],
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Distância: ${delivery['distance']} • Aberto há ${delivery['timeElapsed']}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isUrgent ? Colors.red : Colors.grey[700],
                                  fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'R\$ ${delivery['total'].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0055FF),
                                    ),
                                  ),
                                  if (delivery['deliveryPerson'] != null)
                                    Text(
                                      delivery['deliveryPerson'],
                                      style: const TextStyle(fontSize: 14, color: Colors.teal),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (delivery['status'] == 'Pendente')
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                                        child: const Text('Atribuir Motoboy'),
                                      ),
                                    ),
                                  if (delivery['status'] == 'Em Rota')
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                        child: const Text('Marcar Entregue'),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.cancel, color: Colors.redAccent),
                                    onPressed: () {},
                                    tooltip: 'Cancelar Entrega',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.map, color: Colors.blue),
                                    onPressed: () {},
                                    tooltip: 'Ver no Mapa',
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