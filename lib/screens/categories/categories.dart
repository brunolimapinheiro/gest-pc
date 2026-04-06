import 'package:flutter/material.dart';

class CategoriesDesktop extends StatefulWidget {
  const CategoriesDesktop({super.key});

  @override
  State<CategoriesDesktop> createState() => _CategoriesDesktopState();
}

class _CategoriesDesktopState extends State<CategoriesDesktop> {
  bool _mostrarCategorias = true; // alterna entre Categorias e Complementos

  // Dados de exemplo (depois conecte com banco ou provider)
  final List<Map<String, dynamic>> _categorias = [
    {'nome': 'Lanches', 'qtdProdutos': 18, 'cor': Colors.orange},
    {'nome': 'Bebidas', 'qtdProdutos': 12, 'cor': Colors.blue},
    {'nome': 'Sobremesas', 'qtdProdutos': 8, 'cor': Colors.pink},
    {'nome': 'Pratos Quentes', 'qtdProdutos': 15, 'cor': Colors.red},
    {'nome': 'Promoções', 'qtdProdutos': 5, 'cor': Colors.green},
  ];

  final List<Map<String, dynamic>> _complementos = [
    {'nome': 'Queijo Extra', 'preco': 4.90, 'obrigatorio': false},
    {'nome': 'Bacon Crocante', 'preco': 6.90, 'obrigatorio': false},
    {'nome': 'Sem Cebola', 'preco': 0.00, 'obrigatorio': false},
    {'nome': 'Adicional de Molho', 'preco': 3.50, 'obrigatorio': false},
    {'nome': 'Tamanho Família (obrigatório)', 'preco': 0.00, 'obrigatorio': true},
  ];

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final itens = _mostrarCategorias ? _categorias : _complementos;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabeçalho + Botão Novo + Alternar visão
          Row(
            children: [
              Text(
                _mostrarCategorias ? 'Categorias' : 'Complementos',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ToggleButtons(
                isSelected: [!_mostrarCategorias, _mostrarCategorias],
                onPressed: (index) {
                  setState(() {
                    _mostrarCategorias = index == 1;
                  });
                },
                borderRadius: BorderRadius.circular(12),
                selectedColor: Colors.white,
                fillColor: const Color(0xFF0055FF),
                color: const Color(0xFF0055FF),
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    child: Text('Complementos'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                    child: Text('Categorias'),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: Text(_mostrarCategorias ? 'Nova Categoria' : 'Novo Complemento'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055FF),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Aqui abre formulário de cadastro
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_mostrarCategorias
                          ? 'Abrindo cadastro de categoria...'
                          : 'Abrindo cadastro de complemento...'),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Busca
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar ${_mostrarCategorias ? 'categoria' : 'complemento'}...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey[100],
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 32),

          // Grid de itens
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 1.4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: itens.length,
              itemBuilder: (context, index) {
                final item = itens[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_mostrarCategorias) ...[
                          Icon(Icons.category, size: 60, color: item['cor'] ?? const Color(0xFF0055FF)),
                          const SizedBox(height: 12),
                          Text(
                            item['nome'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${item['qtdProdutos']} produtos',
                            style: const TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ] else ...[
                          Icon(Icons.add_circle_outline, size: 60, color: const Color(0xFF0055FF)),
                          const SizedBox(height: 12),
                          Text(
                            item['nome'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'R\$ ${item['preco'].toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: item['obrigatorio'] ? Colors.red : const Color(0xFF0055FF),
                            ),
                          ),
                          if (item['obrigatorio'])
                            const Text(
                              '(Obrigatório)',
                              style: TextStyle(fontSize: 13, color: Colors.red, fontWeight: FontWeight.w500),
                            ),
                        ],

                        const SizedBox(height: 16),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueGrey),
                              onPressed: () {
                                // Editar
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () {
                                // Confirmar exclusão
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
}