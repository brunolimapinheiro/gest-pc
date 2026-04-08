import 'package:flutter/material.dart';

class CategoriesDesktop extends StatefulWidget {
  const CategoriesDesktop({super.key});

  @override
  State<CategoriesDesktop> createState() => _CategoriesDesktopState();
}

class _CategoriesDesktopState extends State<CategoriesDesktop> {
  final List<Map<String, dynamic>> _categorias = [
    {'nome': 'Lanches', 'qtdProdutos': 18, 'cor': Colors.orange},
    {'nome': 'Bebidas', 'qtdProdutos': 12, 'cor': Colors.blue},
    {'nome': 'Sobremesas', 'qtdProdutos': 8, 'cor': Colors.pink},
    {'nome': 'Pratos Quentes', 'qtdProdutos': 15, 'cor': Colors.red},
    {'nome': 'Promoções', 'qtdProdutos': 5, 'cor': Colors.green},
    {'nome': 'Acompanhamentos', 'qtdProdutos': 9, 'cor': Colors.teal},
    {'nome': 'Cafés e Chás', 'qtdProdutos': 7, 'cor': Colors.brown},
  ];

  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> get _categoriasFiltradas {
    final query = _searchController.text.toLowerCase().trim();
    if (query.isEmpty) return _categorias;
    return _categorias
        .where((cat) => cat['nome'].toString().toLowerCase().contains(query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // === RESPONSIVIDADE ATUALIZADA ===
    final double width = MediaQuery.of(context).size.width;

    // Quantidade de colunas
    final int crossAxisCount = width < 700 ? 1 : width < 900 ? 2 : 3;

    // Diminuição começa exatamente em 800px (como você pediu)
    final bool isSmall = width < 800;

    // Tamanhos dinâmicos
    final double iconSize = isSmall ? 42 : 56;
    final double titleFontSize = isSmall ? 18 : 21;
    final double cardPadding = isSmall ? 18 : 24;
    final double childAspectRatio = crossAxisCount == 1
        ? 1.65
        : crossAxisCount == 2
            ? 1.48
            : 1.35;

    final double spacing = isSmall ? 16 : 24;

    return Padding(
      padding: EdgeInsets.all(isSmall ? 20 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Categorias',
                style: TextStyle(
                  fontSize: isSmall ? 26 : 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                icon: const Icon(Icons.add, size: 26),
                label: Text(
                  'Nova Categoria',
                  style: TextStyle(
                    fontSize: isSmall ? 16 : 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0055FF),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmall ? 20 : 28,
                    vertical: isSmall ? 14 : 18,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 3,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Dialog de nova categoria em breve...'),
                      backgroundColor: Color(0xFF0055FF),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Buscar categoria...',
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            ),
          ),

          const SizedBox(height: 32),

          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: childAspectRatio,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
              ),
              itemCount: _categoriasFiltradas.length,
              itemBuilder: (context, index) {
                final item = _categoriasFiltradas[index];
                final Color corCategoria = item['cor'] ?? const Color(0xFF0055FF);

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // CARD
                    Expanded(
                      child: Card(
                        elevation: 8,
                        shadowColor: Colors.black.withOpacity(0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: EdgeInsets.all(cardPadding),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: iconSize + 10,
                                height: iconSize + 10,
                                decoration: BoxDecoration(
                                  color: corCategoria.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.category_rounded,
                                  size: iconSize,
                                  color: corCategoria,
                                ),
                              ),
                              SizedBox(height: isSmall ? 18 : 26),
                              Text(
                                item['nome'],
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // RODAPÉ FORA DO CARD
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item['qtdProdutos']} produtos',
                          style: TextStyle(
                            fontSize: isSmall ? 14 : 15.5,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.delete_outline_rounded, size: 22),
                          label: Text(
                            'Excluir',
                            style: TextStyle(
                              fontSize: isSmall ? 14 : 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.redAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirmar exclusão'),
                                content: Text('Deseja realmente excluir "${item['nome']}"?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Categoria excluída!'),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    },
                                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                                    child: const Text('Excluir'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}