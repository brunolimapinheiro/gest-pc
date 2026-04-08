import 'package:flutter/material.dart';
import 'product_details.dart'; // ← Certifique-se de que este arquivo está importado

class ProductsDesktop extends StatefulWidget {
  const ProductsDesktop({super.key});

  @override
  State<ProductsDesktop> createState() => _ProductsDesktopState();
}

class _ProductsDesktopState extends State<ProductsDesktop> {
  final TextEditingController _searchController = TextEditingController();
  String _categoriaSelecionada = 'Todos';

  final List<String> categorias = [
    'Todos',
    'Bebidas',
    'Lanches',
    'Sobremesas',
    'Pratos Quentes',
    'Promoções'
  ];

  // Lista de ícones disponíveis para o cadastro
  final List<IconData> _availableIcons = [
    Icons.fastfood,
    Icons.local_pizza,
    Icons.local_drink,
    Icons.emoji_food_beverage,
    Icons.coffee,
    Icons.cake,
    Icons.icecream,
    Icons.restaurant,
    Icons.dinner_dining,
    Icons.local_dining,
    Icons.local_bar,
    Icons.breakfast_dining,
  ];

  final List<Map<String, dynamic>> produtos = [
    {'nome': 'Hambúrguer Clássico', 'preco': 18.90, 'cat': 'Lanches', 'icone': Icons.fastfood},
    {'nome': 'Cheeseburger Duplo', 'preco': 24.90, 'cat': 'Lanches', 'icone': Icons.fastfood},
    {'nome': 'Batata Frita Grande', 'preco': 14.90, 'cat': 'Lanches', 'icone': Icons.local_pizza},
    {'nome': 'Pizza Margherita', 'preco': 45.00, 'cat': 'Pratos Quentes', 'icone': Icons.local_pizza},
    {'nome': 'Pizza Calabresa', 'preco': 52.00, 'cat': 'Pratos Quentes', 'icone': Icons.local_pizza},
    {'nome': 'Coca-Cola 350ml', 'preco': 6.50, 'cat': 'Bebidas', 'icone': Icons.local_drink},
    {'nome': 'Guaraná 350ml', 'preco': 6.50, 'cat': 'Bebidas', 'icone': Icons.local_drink},
    {'nome': 'Suco de Laranja', 'preco': 9.90, 'cat': 'Bebidas', 'icone': Icons.emoji_food_beverage},
    {'nome': 'Café Expresso', 'preco': 7.90, 'cat': 'Bebidas', 'icone': Icons.coffee},
    {'nome': 'Brigadeiro Gourmet', 'preco': 8.90, 'cat': 'Sobremesas', 'icone': Icons.cake},
    {'nome': 'Pudim de Leite', 'preco': 12.90, 'cat': 'Sobremesas', 'icone': Icons.cake},
    {'nome': 'Sorvete de Chocolate', 'preco': 11.90, 'cat': 'Sobremesas', 'icone': Icons.icecream},
    {'nome': 'Prato Executivo', 'preco': 39.90, 'cat': 'Pratos Quentes', 'icone': Icons.restaurant},
    {'nome': 'Filé à Parmegiana', 'preco': 48.90, 'cat': 'Pratos Quentes', 'icone': Icons.dinner_dining},
    {'nome': 'Salada Caesar', 'preco': 22.90, 'cat': 'Pratos Quentes', 'icone': Icons.local_dining},
    {'nome': 'Combo Hambúrguer + Batata + Refri', 'preco': 32.90, 'cat': 'Promoções', 'icone': Icons.fastfood},
    {'nome': 'Pizza + Refri 1L', 'preco': 55.00, 'cat': 'Promoções', 'icone': Icons.local_pizza},
  ];

  // ====================== POP-UP DE NOVO PRODUTO ======================
  void _showNewProductDialog() {
    // Controladores existentes e novos
    final nomeCtrl = TextEditingController();
    final nomeComercialCtrl = TextEditingController();
    final precoCtrl = TextEditingController();
    final codigoCtrl = TextEditingController(); // Representa o SKU
    final eanCtrl = TextEditingController();
    final descricaoCtrl = TextEditingController();
    final undPrincipalCtrl = TextEditingController();
    final undSecundariaCtrl = TextEditingController();
    final subcategoriaCtrl = TextEditingController();
    final marcaCtrl = TextEditingController();
    final modeloCtrl = TextEditingController();
    final refFabricanteCtrl = TextEditingController();
    final aplicacaoCtrl = TextEditingController();

    String categoriaSelecionada = 'Bebidas';
    IconData iconeSelecionado = _availableIcons[0];
    final List<String> disponivelEm = ['Delivery', 'Salão', 'Pedido Online'];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: const Text('Cadastrar Novo Produto', style: TextStyle(fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: 580, // Ligeiramente mais largo para acomodar os campos lado a lado
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nomeCtrl,
                      decoration: const InputDecoration(labelText: 'Nome do produto *', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: nomeComercialCtrl,
                      decoration: const InputDecoration(labelText: 'Nome comercial (se diferente)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: precoCtrl,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(labelText: 'Preço (R\$) *', prefixText: 'R\$ ', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: categoriaSelecionada,
                            decoration: const InputDecoration(labelText: 'Categoria', border: OutlineInputBorder()),
                            items: categorias
                                .where((c) => c != 'Todos')
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setDialogState(() => categoriaSelecionada = val);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: subcategoriaCtrl,
                            decoration: const InputDecoration(labelText: 'Subcategoria', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: codigoCtrl,
                            decoration: const InputDecoration(labelText: 'Código interno (SKU)', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: eanCtrl,
                            decoration: const InputDecoration(labelText: 'Código de barras (EAN/UPC)', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: undPrincipalCtrl,
                            decoration: const InputDecoration(labelText: 'Unid. Principal (ex: kg, un)', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: undSecundariaCtrl,
                            decoration: const InputDecoration(labelText: 'Unid. Secundária (opcional)', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: marcaCtrl,
                            decoration: const InputDecoration(labelText: 'Marca', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: modeloCtrl,
                            decoration: const InputDecoration(labelText: 'Modelo', border: OutlineInputBorder()),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: refFabricanteCtrl,
                      decoration: const InputDecoration(labelText: 'Referência do fabricante', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: aplicacaoCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'Aplicação ou uso (opcional)', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    const Text('Onde o produto está disponível?', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: ['Delivery', 'Salão', 'Pedido Online'].map((opt) {
                        final isSelected = disponivelEm.contains(opt);
                        return FilterChip(
                          label: Text(opt),
                          selected: isSelected,
                          onSelected: (selected) {
                            setDialogState(() {
                              if (selected) {
                                disponivelEm.add(opt);
                              } else {
                                disponivelEm.remove(opt);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: descricaoCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Descrição Detalhada', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 24),
                    const Text('Escolha o ícone do produto', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _availableIcons.length,
                        itemBuilder: (context, i) {
                          final icon = _availableIcons[i];
                          final isSelected = icon == iconeSelecionado;
                          return Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              onTap: () => setDialogState(() => iconeSelecionado = icon),
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  color: isSelected ? const Color(0xFF0055FF).withOpacity(0.15) : Colors.grey[100],
                                  shape: BoxShape.circle,
                                  border: isSelected ? Border.all(color: const Color(0xFF0055FF), width: 3) : null,
                                ),
                                child: Icon(icon, size: 36, color: isSelected ? const Color(0xFF0055FF) : Colors.grey[700]),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                onPressed: () {
                  if (nomeCtrl.text.trim().isEmpty || precoCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Nome e preço são obrigatórios!')),
                    );
                    return;
                  }

                  final preco = double.tryParse(precoCtrl.text.replaceAll(',', '.')) ?? 0.0;

                  // Salvando todos os novos campos no mapa
                  final novoProduto = {
                    'nome': nomeCtrl.text.trim(),
                    'nomeComercial': nomeComercialCtrl.text.trim(),
                    'preco': preco,
                    'cat': categoriaSelecionada,
                    'subcategoria': subcategoriaCtrl.text.trim(),
                    'codigo': codigoCtrl.text.trim().isEmpty
                        ? 'AUTO-${nomeCtrl.text.substring(0, 3).toUpperCase()}'
                        : codigoCtrl.text.trim(), // Este é o SKU
                    'ean': eanCtrl.text.trim(),
                    'unidadePrincipal': undPrincipalCtrl.text.trim(),
                    'unidadeSecundaria': undSecundariaCtrl.text.trim(),
                    'marca': marcaCtrl.text.trim(),
                    'modelo': modeloCtrl.text.trim(),
                    'referenciaFabricante': refFabricanteCtrl.text.trim(),
                    'aplicacao': aplicacaoCtrl.text.trim(),
                    'icone': iconeSelecionado,
                    'descricao': descricaoCtrl.text.trim(),
                    'disponivelEm': disponivelEm.join(', '),
                  };

                  setState(() => produtos.add(novoProduto));
                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Produto cadastrado com sucesso!'), backgroundColor: Colors.green),
                  );
                },
                child: const Text('Cadastrar Produto', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produtosFiltrados = produtos.where((p) {
      final matchCat = _categoriaSelecionada == 'Todos' || p['cat'] == _categoriaSelecionada;
      final matchSearch = _searchController.text.isEmpty ||
          p['nome'].toLowerCase().contains(_searchController.text.toLowerCase());
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)],
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Categorias', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: categorias.length,
                    itemBuilder: (context, i) {
                      final cat = categorias[i];
                      final selecionado = cat == _categoriaSelecionada;
                      return ListTile(
                        selected: selecionado,
                        selectedTileColor: const Color(0xFF0055FF).withOpacity(0.12),
                        leading: Icon(
                          selecionado ? Icons.check_circle : Icons.category,
                          color: selecionado ? const Color(0xFF0055FF) : Colors.grey,
                        ),
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0055FF),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      ),
                      onPressed: _showNewProductDialog, // Pop-up de cadastro
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Campo de busca
                TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Buscar no cardápio...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                const SizedBox(height: 32),

                // Lista de produtos
                Expanded(
                  child: ListView.builder(
                    itemCount: produtosFiltrados.length,
                    itemBuilder: (context, index) {
                      final prod = produtosFiltrados[index];
                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
                                    Text('R\$ ${prod['preco'].toStringAsFixed(2)}',
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0055FF))),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductDetailsScreen(produto: prod),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                ),
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