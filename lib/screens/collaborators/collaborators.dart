import 'package:flutter/material.dart';
 import 'new_employee_dialog.dart';

class EmployeesDesktop extends StatefulWidget {
  const EmployeesDesktop({super.key});

  @override
  State<EmployeesDesktop> createState() => _EmployeesDesktopState();
}

class _EmployeesDesktopState extends State<EmployeesDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'Todos';

  final List<String> _filters = [
    'Todos', 'Gerente', 'Caixa', 'Atendente / Garçom', 'Cozinha', 'Inativos'
  ];

  // Mock de Dados
  final List<Map<String, dynamic>> _colaboradores = [
    {'nome': 'Carlos Silva', 'cargo': 'Gerente', 'telefone': '(11) 98888-7777', 'acesso': 'Administrador', 'status': 'Ativo'},
    {'nome': 'Mariana Souza', 'cargo': 'Caixa', 'telefone': '(11) 97777-6666', 'acesso': 'Operador', 'status': 'Ativo'},
    {'nome': 'João Pedro', 'cargo': 'Atendente / Garçom', 'telefone': '(11) 96666-5555', 'acesso': 'Operador', 'status': 'Ativo'},
    {'nome': 'Ana Clara', 'cargo': 'Cozinha', 'telefone': '(11) 95555-4444', 'acesso': 'Sem Acesso', 'status': 'Ativo'},
    {'nome': 'Roberto Alves', 'cargo': 'Entregador', 'telefone': '(11) 94444-3333', 'acesso': 'Sem Acesso', 'status': 'Inativo'},
  ];

  @override
  Widget build(BuildContext context) {
    // === LÓGICA DE RESPONSIVIDADE ===
    final screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount;
    double aspectRatio;
    double paddingGeral;
    double titleSize;
    double headerTextSize;

    if (screenWidth >= 1000) {
      crossAxisCount = 4;
      aspectRatio = 1.0; 
      paddingGeral = 32;
      titleSize = 18;
      headerTextSize = 32;
    } else if (screenWidth >= 800) {
      crossAxisCount = 3;
      aspectRatio = 0.95;
      paddingGeral = 24;
      titleSize = 16;
      headerTextSize = 28;
    } else if (screenWidth >= 550) {
      crossAxisCount = 2;
      aspectRatio = 1.1;
      paddingGeral = 16;
      titleSize = 16;
      headerTextSize = 24;
    } else {
      crossAxisCount = 1;
      aspectRatio = 2.2;
      paddingGeral = 16;
      titleSize = 18;
      headerTextSize = 22;
    }

    final filteredList = _selectedFilter == 'Todos'
        ? _colaboradores
        : _colaboradores.where((c) {
            if (_selectedFilter == 'Inativos') return c['status'] == 'Inativo';
            // Ignora os inativos nas outras abas
            if (c['status'] == 'Inativo') return false; 
            return c['cargo'] == _selectedFilter;
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
                'Equipe e Colaboradores',
                style: TextStyle(fontSize: headerTextSize, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add, color: Colors.white),
                label: Text(screenWidth < 600 ? 'Novo' : 'Novo Colaborador', style: const TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055FF),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: screenWidth < 700 ? 12 : 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  final novoColab = await showNewEmployeeDialog(context);
                  if (novoColab != null) {
                    setState(() => _colaboradores.add(novoColab));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('✅ Colaborador cadastrado!'), backgroundColor: Colors.green)
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
                    _buildFiltersRow(),
                  ],
                )
              : Row(
                  children: [
                    Expanded(flex: 2, child: _buildSearchBar()),
                    const SizedBox(width: 24),
                    Expanded(flex: 3, child: _buildFiltersRow()),
                  ],
                ),
          
          SizedBox(height: screenWidth < 700 ? 16 : 32),

          // Lista em Grid
          Expanded(
            child: filteredList.isEmpty
                ? const Center(child: Text('Nenhum colaborador encontrado.', style: TextStyle(fontSize: 16, color: Colors.grey)))
                : GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: aspectRatio,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];
                      final isAtivo = item['status'] == 'Ativo';
                      
                      // Pega a primeira letra do nome para o Avatar
                      final initial = item['nome'].toString().isNotEmpty ? item['nome'].toString()[0].toUpperCase() : '?';

                      return Card(
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.05),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Avatar e Status
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: const Color(0xFF0055FF).withOpacity(0.15),
                                    child: Text(initial, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0055FF))),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isAtivo ? Colors.green.withOpacity(0.15) : Colors.red.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      item['status'],
                                      style: TextStyle(color: isAtivo ? Colors.green : Colors.red, fontWeight: FontWeight.bold, fontSize: 11),
                                    ),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              
                              // Textos Principais
                              Text(
                                item['nome'],
                                style: TextStyle(fontSize: titleSize, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item['cargo'],
                                style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 8),
                              
                              // Telefone
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.phone, size: 14, color: Colors.grey[500]),
                                  const SizedBox(width: 4),
                                  Text(item['telefone'].toString().isEmpty ? 'Sem telefone' : item['telefone'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                ],
                              ),
                              
                              const Spacer(),
                              const Divider(height: 1, thickness: 0.5),
                              const Spacer(),
                              
                              // Botões de Ação
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton.icon(
                                    icon: const Icon(Icons.edit, size: 18),
                                    label: const Text('Editar'),
                                    style: TextButton.styleFrom(foregroundColor: Colors.blueGrey),
                                    onPressed: () {},
                                  ),
                                  TextButton.icon(
                                    icon: const Icon(Icons.block, size: 18), // Usando "block" em vez de apagar para RH
                                    label: Text(isAtivo ? 'Desativar' : 'Ativar'),
                                    style: TextButton.styleFrom(foregroundColor: isAtivo ? Colors.orange : Colors.green),
                                    onPressed: () {
                                      setState(() {
                                        item['status'] = isAtivo ? 'Inativo' : 'Ativo';
                                      });
                                    },
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
        hintText: 'Buscar colaborador...',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey[100],
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Widget _buildFiltersRow() {
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
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}