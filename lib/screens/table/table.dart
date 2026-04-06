import 'package:flutter/material.dart';

class TableManagementDesktop extends StatefulWidget {
  const TableManagementDesktop({super.key});

  @override
  State<TableManagementDesktop> createState() => _TableManagementDesktopState();
}

class _TableManagementDesktopState extends State<TableManagementDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todas';

  final List<String> _filters = [
    'Todas',
    'Livres',
    'Ocupadas',
    'Reservadas',
    'Aguardando Limpeza',
    'Manutenção',
  ];

  // Dados de exemplo (em produção viria de banco ou realtime)
  final List<Map<String, dynamic>> _tables = [
    {
      'number': '01',
      'capacity': 4,
      'status': 'Livre',
      'timeOccupied': null,
      'currentOrderTotal': 0.0,
      'color': Colors.green,
    },
    {
      'number': '05',
      'capacity': 6,
      'status': 'Ocupada',
      'timeOccupied': '28 min',
      'currentOrderTotal': 112.50,
      'color': Colors.orange,
    },
    {
      'number': '12',
      'capacity': 8,
      'status': 'Reservada',
      'timeOccupied': null,
      'currentOrderTotal': 0.0,
      'color': Colors.purple,
    },
    {
      'number': '03',
      'capacity': 2,
      'status': 'Aguardando Limpeza',
      'timeOccupied': '45 min',
      'currentOrderTotal': 0.0,
      'color': Colors.grey,
    },
    {
      'number': '07',
      'capacity': 4,
      'status': 'Ocupada',
      'timeOccupied': '1h 10min',
      'currentOrderTotal': 189.90,
      'color': Colors.red,
    },
    {
      'number': '10',
      'capacity': 10,
      'status': 'Manutenção',
      'timeOccupied': null,
      'currentOrderTotal': 0.0,
      'color': Colors.blueGrey,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredTables = _selectedFilter == 'Todas'
        ? _tables
        : _tables.where((table) {
            if (_selectedFilter == 'Livres') return table['status'] == 'Livre';
            if (_selectedFilter == 'Ocupadas') return table['status'] == 'Ocupada';
            return table['status'] == _selectedFilter;
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
                'Gerenciamento de Mesas',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Nova Reserva'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Abrindo nova reserva...')),
                      );
                    },
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_box),
                    label: const Text('Abrir Nova Comanda'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0055FF),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Selecionando mesa para nova comanda...')),
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
                    hintText: 'Buscar por número da mesa, cliente...',
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

          // Grid de mesas
          Expanded(
            child: filteredTables.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.table_restaurant_outlined, size: 90, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Nenhuma mesa encontrada', style: TextStyle(fontSize: 22, color: Colors.grey)),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredTables.length,
                    itemBuilder: (context, index) {
                      final table = filteredTables[index];
                      final Color statusColor = table['color'];
                      final bool isOccupied = table['status'] == 'Ocupada';

                      return GestureDetector(
                        onTap: () {
                          // Abrir detalhes da mesa / comanda
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Abrindo detalhes da Mesa ${table['number']}')),
                          );
                        },
                        child: Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          color: statusColor.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.table_restaurant,
                                  size: 80,
                                  color: statusColor,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Mesa ${table['number']}',
                                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${table['capacity']} lugares',
                                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    table['status'],
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (isOccupied) ...[
                                  Text(
                                    'Aberta há ${table['timeOccupied']}',
                                    style: const TextStyle(fontSize: 14, color: Colors.redAccent),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'R\$ ${table['currentOrderTotal'].toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0055FF),
                                    ),
                                  ),
                                ],
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_note, color: Colors.blueGrey),
                                      onPressed: () {},
                                      tooltip: 'Editar / Ver Comanda',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.cleaning_services, color: Colors.teal),
                                      onPressed: () {
                                        // Marcar como limpa
                                      },
                                      tooltip: 'Limpar Mesa',
                                    ),
                                  ],
                                ),
                              ],
                            ),
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