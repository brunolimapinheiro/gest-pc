import 'package:flutter/material.dart';

class EmployeesDesktop extends StatefulWidget {
  const EmployeesDesktop({super.key});

  @override
  State<EmployeesDesktop> createState() => _EmployeesDesktopState();
}

class _EmployeesDesktopState extends State<EmployeesDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedRole = 'Todos';
  String _selectedStatus = 'Todos';

  final List<String> _roles = [
    'Todos',
    'Garçom',
    'Motoboy',
    'Cozinheiro',
    'Caixa',
    'Gerente',
    'Auxiliar',
  ];

  final List<String> _statuses = [
    'Todos',
    'Ativo',
    'Inativo',
    'Férias',
    'Afastado',
  ];

  // Dados de exemplo (em produção: banco de dados com foto, comissão, etc.)
  final List<Map<String, dynamic>> _employees = [
    {
      'name': 'Carlos Almeida',
      'role': 'Garçom',
      'status': 'Ativo',
      'commissionPending': 320.50,
      'phone': '(86) 99912-3456',
      'avatarColor': Colors.blue,
      'color': Colors.green,
    },
    {
      'name': 'João Santos',
      'role': 'Motoboy',
      'status': 'Ativo',
      'commissionPending': 180.00,
      'phone': '(86) 98876-5432',
      'avatarColor': Colors.orange,
      'color': Colors.green,
    },
    {
      'name': 'Maria Oliveira',
      'role': 'Cozinheira',
      'status': 'Férias',
      'commissionPending': 0.00,
      'phone': '(86) 98765-4321',
      'avatarColor': Colors.pink,
      'color': Colors.orange,
    },
    {
      'name': 'Pedro Lima',
      'role': 'Caixa',
      'status': 'Ativo',
      'commissionPending': 450.75,
      'phone': '(86) 99123-4567',
      'avatarColor': Colors.purple,
      'color': Colors.green,
    },
    {
      'name': 'Ana Costa',
      'role': 'Gerente',
      'status': 'Ativo',
      'commissionPending': 0.00,
      'phone': '(86) 99234-5678',
      'avatarColor': Colors.teal,
      'color': Colors.green,
    },
    {
      'name': 'Lucas Ferreira',
      'role': 'Motoboy',
      'status': 'Inativo',
      'commissionPending': 95.20,
      'phone': '(86) 99345-6789',
      'avatarColor': Colors.grey,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredEmployees = _employees.where((emp) {
      final bool roleMatch = _selectedRole == 'Todos' || emp['role'] == _selectedRole;
      final bool statusMatch = _selectedStatus == 'Todos' || emp['status'] == _selectedStatus;
      final bool searchMatch = _searchController.text.isEmpty ||
          emp['name'].toLowerCase().contains(_searchController.text.toLowerCase());
      return roleMatch && statusMatch && searchMatch;
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
                'Colaboradores / Garçons / Motoboys',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text('Novo Colaborador'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055FF),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Abrindo cadastro de novo colaborador...')),
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
                flex: 2,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nome...',
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
                  value: _selectedRole,
                  decoration: InputDecoration(
                    labelText: 'Cargo',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  items: _roles.map((role) {
                    return DropdownMenuItem(value: role, child: Text(role));
                  }).toList(),
                  onChanged: (value) => setState(() => _selectedRole = value!),
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

          // Lista de colaboradores
          Expanded(
            child: filteredEmployees.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.people_alt_outlined, size: 90, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('Nenhum colaborador encontrado', style: TextStyle(fontSize: 22, color: Colors.grey)),
                      ],
                    ),
                  )
                : GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.65,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredEmployees.length,
                    itemBuilder: (context, index) {
                      final emp = filteredEmployees[index];
                      final Color statusColor = emp['color'];
                      final bool hasPending = emp['commissionPending'] > 0;

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 40,
                                backgroundColor: emp['avatarColor'],
                                child: Text(
                                  emp['name'].substring(0, 1).toUpperCase(),
                                  style: const TextStyle(fontSize: 36, color: Colors.white),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                emp['name'],
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                emp['role'],
                                style: const TextStyle(fontSize: 16, color: Color(0xFF0055FF)),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  emp['status'],
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (hasPending)
                                Text(
                                  'Comissão pendente: R\$ ${emp['commissionPending'].toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange,
                                  ),
                                ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.phone, color: Colors.green),
                                    onPressed: () {
                                      // Ligar ou WhatsApp
                                    },
                                    tooltip: 'Contato: ${emp['phone']}',
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blueGrey),
                                    onPressed: () {},
                                    tooltip: 'Editar Colaborador',
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      emp['status'] == 'Ativo' ? Icons.block : Icons.check_circle,
                                      color: emp['status'] == 'Ativo' ? Colors.red : Colors.green,
                                    ),
                                    onPressed: () {},
                                    tooltip: emp['status'] == 'Ativo' ? 'Desativar' : 'Ativar',
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