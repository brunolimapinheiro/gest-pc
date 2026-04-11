import 'package:flutter/material.dart';
import 'product_details.dart'; 
 import 'new_product_dialog.dart';

// ==================== INTEGRAÇÃO COM BACK-END ====================
class ProductService {
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      {'nome': 'Hambúrguer Clássico', 'preco': 18.90, 'cat': 'Lanches', 'icone': Icons.fastfood},
      {'nome': 'Cheeseburger Duplo', 'preco': 24.90, 'cat': 'Lanches', 'icone': Icons.fastfood},
      {'nome': 'Batata Frita Grande', 'preco': 14.90, 'cat': 'Lanches', 'icone': Icons.local_pizza},
      {'nome': 'Pizza Margherita', 'preco': 45.00, 'cat': 'Pratos Quentes', 'icone': Icons.local_pizza},
      {'nome': 'Coca-Cola 350ml', 'preco': 6.50, 'cat': 'Bebidas', 'icone': Icons.local_drink},
      {'nome': 'Café Expresso', 'preco': 7.90, 'cat': 'Bebidas', 'icone': Icons.coffee},
      {'nome': 'Pudim de Leite', 'preco': 12.90, 'cat': 'Sobremesas', 'icone': Icons.cake},
      {'nome': 'Filé à Parmegiana', 'preco': 48.90, 'cat': 'Pratos Quentes', 'icone': Icons.dinner_dining},
      {'nome': 'Combo Hambúrguer + Batata + Refri', 'preco': 32.90, 'cat': 'Promoções', 'icone': Icons.fastfood},
    ];
  }

  Future<Map<String, dynamic>> saveProduct(Map<String, dynamic> product) async {
    await Future.delayed(const Duration(seconds: 1));
    product['id'] = DateTime.now().millisecondsSinceEpoch.toString();
    return product;
  }
}

// ==================== TELA PRINCIPAL DO FRONT-END ====================
class ProductsDesktop extends StatefulWidget {
  const ProductsDesktop({super.key});

  @override
  State<ProductsDesktop> createState() => _ProductsDesktopState();
}

class _ProductsDesktopState extends State<ProductsDesktop> {
  final ProductService _service = ProductService(); 
  final TextEditingController _searchController = TextEditingController();
  
  String _categoriaSelecionada = 'Todos';
  bool _isLoading = true; 
  List<Map<String, dynamic>> produtos = []; 

  final List<String> categorias = [
    'Todos', 'Bebidas', 'Lanches', 'Sobremesas', 'Pratos Quentes', 'Promoções'
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts(); 
  }

  Future<void> _loadProducts() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.fetchProducts();
      setState(() => produtos = data);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final produtosFiltrados = produtos.where((p) {
      final matchCat = _categoriaSelecionada == 'Todos' || p['cat'] == _categoriaSelecionada;
      final matchSearch = _searchController.text.isEmpty || p['nome'].toLowerCase().contains(_searchController.text.toLowerCase());
      return matchCat && matchSearch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar de Categorias
          Container(
            width: 220,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)]),
            child: Column(
              children: [
                const Padding(padding: EdgeInsets.all(20), child: Text('Categorias', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                Expanded(
                  child: ListView.builder(
                    itemCount: categorias.length,
                    itemBuilder: (context, i) {
                      final cat = categorias[i];
                      final selecionado = cat == _categoriaSelecionada;
                      return ListTile(
                        selected: selecionado,
                        selectedTileColor: const Color(0xFF0055FF).withOpacity(0.12),
                        leading: Icon(selecionado ? Icons.check_circle : Icons.category, color: selecionado ? const Color(0xFF0055FF) : Colors.grey),
                        title: Text(cat, style: const TextStyle(fontWeight: FontWeight.w600)),
                        onTap: () => setState(() => _categoriaSelecionada = cat),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 32),

          // Conteúdo principal
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Cardápio / Produtos', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text('Novo Produto', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0055FF), padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
                      // ==============================================================
                      // AQUI CHAMAMOS O ARQUIVO EXTERNO E PASSAMOS A API (service)
                      // ==============================================================
                      onPressed: () async {
                        final savedProduct = await showNewProductDialog(
                          context, 
                          categorias, 
                          (data) => _service.saveProduct(data) // O dialog executa isso internamente!
                        );

                        // Se retornou produto salvo com sucesso, atualiza a tela
                        if (savedProduct != null) {
                          setState(() => produtos.add(savedProduct));
                          
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('✅ Produto cadastrado com sucesso!'), backgroundColor: Colors.green)
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(hintText: 'Buscar no cardápio...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: Colors.grey[100]),
                ),
                const SizedBox(height: 32),

                // Lista de produtos
                Expanded(
                  child: _isLoading 
                      ? const Center(child: CircularProgressIndicator()) 
                      : produtosFiltrados.isEmpty
                          ? const Center(child: Text('Nenhum produto encontrado.'))
                          : ListView.builder(
                              itemCount: produtosFiltrados.length,
                              itemBuilder: (context, index) {
                                final prod = produtosFiltrados[index];
                                return Card(
                                  elevation: 4, margin: const EdgeInsets.only(bottom: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                    child: Row(
                                      children: [
                                        Icon(prod['icone'] as IconData, size: 48, color: const Color(0xFF0055FF)),
                                        const SizedBox(width: 20),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(prod['nome'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                                              const SizedBox(height: 6),
                                              Text('R\$ ${prod['preco'].toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0055FF))),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(produto: prod))),
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
                                          child: const Text('Ver mais', style: TextStyle(color: Colors.white)),
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
          ),
        ],
      ),
    );
  }
}