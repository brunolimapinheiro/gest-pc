import 'package:flutter/material.dart';

class PdvDesktop extends StatefulWidget {
  const PdvDesktop({super.key});

  @override
  State<PdvDesktop> createState() => _PdvDesktopState();
}

class _PdvDesktopState extends State<PdvDesktop> {
  final List<Map<String, dynamic>> _carrinho = [];
  final TextEditingController _buscaController = TextEditingController();

  // ==================== LISTA DE PRODUTOS DEMO (aqui você personaliza tudo!) ====================
  final List<Map<String, dynamic>> _produtosDemo = [
  // ROUPAS
  {'nome': 'Camiseta Básica', 'preco': 39.90, 'icone': Icons.checkroom},
  {'nome': 'Calça Jeans', 'preco': 89.90, 'icone': Icons.checkroom},
  {'nome': 'Vestido Floral', 'preco': 69.90, 'icone': Icons.dry_cleaning},
  {'nome': 'Bolsa de Couro', 'preco': 149.90, 'icone': Icons.shopping_bag},
  {'nome': 'Tênis Esportivo', 'preco': 119.90, 'icone': Icons.sports_basketball},

  // ELETRÔNICOS / OUTROS
  {'nome': 'Celular', 'preco': 1299.90, 'icone': Icons.phone_android},
  {'nome': 'Notebook', 'preco': 3499.90, 'icone': Icons.laptop},
  {'nome': 'Fone Bluetooth', 'preco': 299.90, 'icone': Icons.headphones},
  {'nome': 'Smart TV 55"', 'preco': 2199.90, 'icone': Icons.tv},

  // RESTAURANTE / ALIMENTOS
  {'nome': 'Hambúrguer', 'preco': 29.90, 'icone': Icons.fastfood},
  {'nome': 'Pizza Margherita', 'preco': 49.90, 'icone': Icons.local_pizza},
  {'nome': 'Prato Feito', 'preco': 35.90, 'icone': Icons.restaurant},
  {'nome': 'Refrigerante 2L', 'preco': 12.90, 'icone': Icons.local_drink},
  {'nome': 'Suco Natural', 'preco': 15.90, 'icone': Icons.emoji_food_beverage},
  {'nome': 'Café Expresso', 'preco': 9.90, 'icone': Icons.coffee},
  {'nome': 'Sorvete', 'preco': 18.90, 'icone': Icons.icecream},
  {'nome': 'Bolo de Chocolate', 'preco': 25.90, 'icone': Icons.cake},
  {'nome': 'Salada', 'preco': 22.90, 'icone': Icons.local_dining},
  {'nome': 'Almoço Executivo', 'preco': 39.90, 'icone': Icons.lunch_dining},
  {'nome': 'Janta Completa', 'preco': 45.90, 'icone': Icons.dinner_dining},
  {'nome': 'Pão na Chapa', 'preco': 14.90, 'icone': Icons.breakfast_dining},
  {'nome': 'Sopa do Dia', 'preco': 19.90, 'icone': Icons.soup_kitchen},
  {'nome': 'Coxinha', 'preco': 8.90, 'icone': Icons.bakery_dining},
  {'nome': 'Açaí', 'preco': 22.90, 'icone': Icons.emoji_food_beverage},
  {'nome': 'Combo Fast Food', 'preco': 55.90, 'icone': Icons.fastfood},
];

  // ==================== ADICIONAR PRODUTO ====================
  void adicionarProduto(String nome, double preco) {
    setState(() {
      final index = _carrinho.indexWhere((item) => item['nome'] == nome);
      if (index != -1) {
        _carrinho[index]['qtd']++;
      } else {
        _carrinho.add({'nome': nome, 'preco': preco, 'qtd': 1});
      }
    });
  }

  // ==================== ALTERAR QUANTIDADE ====================
  void alterarQuantidade(int index, int delta) {
    setState(() {
      _carrinho[index]['qtd'] += delta;
      if (_carrinho[index]['qtd'] <= 0) _carrinho.removeAt(index);
    });
  }

  // ==================== REMOVER ITEM ====================
  void removerItem(int index) {
    setState(() => _carrinho.removeAt(index));
  }

  double get total => _carrinho.fold(0, (sum, item) => sum + (item['preco'] * item['qtd']));

  // ==================== FINALIZAR COMPRA (mantido igual) ====================
  void finalizarCompra() {
    if (_carrinho.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Carrinho vazio!'), backgroundColor: Colors.red),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finalizar Compra', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Total: R\$ ${total.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0055FF))),
            const SizedBox(height: 20),
            const Text('Escolha a forma de pagamento:'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              children: [
                _buildPaymentOption('Dinheiro', Icons.money),
                _buildPaymentOption('Cartão Crédito', Icons.credit_card),
                _buildPaymentOption('Cartão Débito', Icons.credit_card),
                _buildPaymentOption('Pix', Icons.qr_code),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            onPressed: () {
              Navigator.pop(context);
              _finalizarComSucesso();
            },
            child: const Text('Confirmar Pagamento', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String label, IconData icon) {
    return Chip(
      avatar: Icon(icon, color: Colors.white),
      label: Text(label),
      backgroundColor: const Color(0xFF0055FF),
      labelStyle: const TextStyle(color: Colors.white),
    );
  }

  void _finalizarComSucesso() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 80),
        title: const Text('Compra Finalizada com Sucesso!'),
        content: Text('Total pago: R\$ ${total.toStringAsFixed(2)}\n\nObrigado pela compra!'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _carrinho.clear());
            },
            child: const Text('Nova Venda'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ==================== ESQUERDA: PRODUTOS ====================
          Expanded(
            flex: 2,
            child: Column(
              children: [
                TextField(
                  controller: _buscaController,
                  decoration: InputDecoration(
                    hintText: 'Digite código ou nome do produto...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      adicionarProduto('Produto: $value', 19.90);
                      _buscaController.clear();
                    }
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 1.05,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _produtosDemo.length,
                    itemBuilder: (context, i) {
                      final produto = _produtosDemo[i];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => adicionarProduto(produto['nome'], produto['preco']),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(produto['icone'] as IconData, size: 52, color: const Color(0xFF0055FF)),
                              const SizedBox(height: 8),
                              Text(produto['nome'],
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              Text('R\$ ${produto['preco'].toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 15, color: Colors.grey)),
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
          const SizedBox(width: 24),
          // ==================== DIREITA: CARRINHO ====================
          Expanded(
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text('Carrinho', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    const Divider(thickness: 1.5),
                    Expanded(
                      child: _carrinho.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
                                  SizedBox(height: 16),
                                  Text('Carrinho vazio', style: TextStyle(fontSize: 20, color: Colors.grey)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: _carrinho.length,
                              itemBuilder: (context, i) {
                                final item = _carrinho[i];
                                return ListTile(
                                  contentPadding: const EdgeInsets.symmetric(vertical: 4),
                                  title: Text(item['nome'], style: const TextStyle(fontWeight: FontWeight.w600)),
                                  subtitle: Text('R\$ ${item['preco'].toStringAsFixed(2)} × ${item['qtd']}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, color: Colors.red),
                                        onPressed: () => alterarQuantidade(i, -1),
                                      ),
                                      Text('${item['qtd']}', style: const TextStyle(fontSize: 18)),
                                      IconButton(
                                        icon: const Icon(Icons.add, color: Colors.green),
                                        onPressed: () => alterarQuantidade(i, 1),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.grey),
                                        onPressed: () => removerItem(i),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                    const Divider(thickness: 1.5),
                    Text(
                      'Total: R\$ ${total.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0055FF)),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 62,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.payment, size: 28),
                        label: const Text('FINALIZAR COMPRA', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: finalizarCompra,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}