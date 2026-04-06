import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> produto;
  const ProductDetailsScreen({super.key, required this.produto});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isEditing = false;

  late TextEditingController _nomeController;
  late TextEditingController _precoController;
  late TextEditingController _codigoController;
  late TextEditingController _descricaoController;

  late String _categoria;
  late List<String> _disponivelEm;
  late IconData _iconeSelecionado;

  final List<String> _categorias = [
    'Bebidas', 'Lanches', 'Sobremesas', 'Pratos Quentes', 'Promoções'
  ];

  final List<String> _disponibilidades = ['Delivery', 'Salão', 'Pedido Online'];

  final List<IconData> _availableIcons = [
    Icons.fastfood, Icons.local_pizza, Icons.local_drink,
    Icons.emoji_food_beverage, Icons.coffee, Icons.cake,
    Icons.icecream, Icons.restaurant, Icons.dinner_dining,
    Icons.local_dining, Icons.local_bar, Icons.breakfast_dining,
  ];

  @override
  void initState() {
    super.initState();

    _nomeController = TextEditingController(text: widget.produto['nome']);
    _precoController = TextEditingController(text: widget.produto['preco'].toStringAsFixed(2));
    _codigoController = TextEditingController(
      text: widget.produto['codigo'] ?? 'AUTO-${widget.produto['nome'].substring(0, 3).toUpperCase()}',
    );
    _descricaoController = TextEditingController(
      text: widget.produto['descricao'] ?? 'Produto de alta qualidade - ideal para o seu cardápio.',
    );

    _categoria = widget.produto['cat'];
    _iconeSelecionado = widget.produto['icone'] as IconData;
    _disponivelEm = (widget.produto['disponivelEm'] as String? ?? 'Delivery, Salão e Online')
        .split(',')
        .map((e) => e.trim())
        .toList();

    // Garante que todos os campos existam no Map
    widget.produto.putIfAbsent('codigo', () => _codigoController.text);
    widget.produto.putIfAbsent('descricao', () => _descricaoController.text);
    widget.produto.putIfAbsent('disponivelEm', () => _disponivelEm.join(', '));
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _codigoController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _startEditing() {
    _nomeController.text = widget.produto['nome'];
    _precoController.text = widget.produto['preco'].toStringAsFixed(2);
    _codigoController.text = widget.produto['codigo'] ?? '';
    _categoria = widget.produto['cat'];
    _descricaoController.text = widget.produto['descricao'] ?? '';
    _iconeSelecionado = widget.produto['icone'] as IconData;
    _disponivelEm = (widget.produto['disponivelEm'] as String? ?? 'Delivery, Salão e Online')
        .split(',')
        .map((e) => e.trim())
        .toList();

    setState(() => _isEditing = true);
  }

  void _cancelEditing() {
    _nomeController.text = widget.produto['nome'];
    _precoController.text = widget.produto['preco'].toStringAsFixed(2);
    _codigoController.text = widget.produto['codigo'] ?? '';
    _categoria = widget.produto['cat'];
    _descricaoController.text = widget.produto['descricao'] ?? '';
    _iconeSelecionado = widget.produto['icone'] as IconData;
    _disponivelEm = (widget.produto['disponivelEm'] as String? ?? 'Delivery, Salão e Online')
        .split(',')
        .map((e) => e.trim())
        .toList();

    setState(() => _isEditing = false);
  }

  void _saveEditing() {
    final preco = double.tryParse(_precoController.text) ?? widget.produto['preco'];

    setState(() {
      widget.produto['nome'] = _nomeController.text.trim();
      widget.produto['preco'] = preco;
      widget.produto['cat'] = _categoria;
      widget.produto['codigo'] = _codigoController.text.trim();
      widget.produto['descricao'] = _descricaoController.text.trim();
      widget.produto['disponivelEm'] = _disponivelEm.join(', ');
      widget.produto['icone'] = _iconeSelecionado;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Produto atualizado com sucesso!'), backgroundColor: Colors.green),
    );

    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final currentIcon = _isEditing ? _iconeSelecionado : (widget.produto['icone'] as IconData);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Editar Produto' : widget.produto['nome'],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0055FF),
        foregroundColor: Colors.white,
        actions: [
          if (!_isEditing)
            IconButton(icon: const Icon(Icons.edit), tooltip: 'Editar', onPressed: _startEditing)
          else
            Row(
              children: [
                TextButton.icon(icon: const Icon(Icons.close, color: Colors.white), label: const Text('Cancelar', style: TextStyle(color: Colors.white)), onPressed: _cancelEditing),
                TextButton.icon(icon: const Icon(Icons.save, color: Colors.white), label: const Text('Salvar', style: TextStyle(color: Colors.white)), onPressed: _saveEditing),
              ],
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================== ÍCONE PRINCIPAL (preview ao vivo) ====================
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0055FF).withOpacity(0.08),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 25, offset: const Offset(0, 12)),
                    ],
                  ),
                  child: Icon(currentIcon, size: 120, color: const Color(0xFF0055FF)),
                ),
              ),

              // Seletor de ícone (só aparece no modo edição)
              if (_isEditing) ...[
                const SizedBox(height: 16),
                const Text('Trocar ícone do produto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _availableIcons.length,
                    itemBuilder: (context, i) {
                      final icon = _availableIcons[i];
                      final isSelected = icon == _iconeSelecionado;
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GestureDetector(
                          onTap: () => setState(() => _iconeSelecionado = icon),
                          child: Container(
                            width: 74,
                            height: 74,
                            decoration: BoxDecoration(
                              color: isSelected ? const Color(0xFF0055FF).withOpacity(0.15) : Colors.grey[100],
                              shape: BoxShape.circle,
                              border: isSelected ? Border.all(color: const Color(0xFF0055FF), width: 4) : null,
                            ),
                            child: Icon(icon, size: 38, color: isSelected ? const Color(0xFF0055FF) : Colors.grey[700]),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],

              const SizedBox(height: 40),

              // ==================== CAMPOS PRINCIPAIS ====================
              _isEditing
                  ? TextField(controller: _nomeController, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold), decoration: InputDecoration(labelText: 'Nome do produto', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))
                  : Text(widget.produto['nome'], style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),

              const SizedBox(height: 8),

              _isEditing
                  ? TextField(controller: _precoController, keyboardType: const TextInputType.numberWithOptions(decimal: true), style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold), decoration: InputDecoration(labelText: 'Preço', prefixText: 'R\$ ', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))
                  : Text('R\$ ${widget.produto['preco'].toStringAsFixed(2)}', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF0055FF))),

              const SizedBox(height: 16),

              _isEditing
                  ? DropdownButtonFormField<String>(value: _categoria, decoration: InputDecoration(labelText: 'Categoria', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))), items: _categorias.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(), onChanged: (v) => v != null ? setState(() => _categoria = v) : null)
                  : Chip(label: Text(widget.produto['cat']), backgroundColor: const Color(0xFF0055FF).withOpacity(0.1), labelStyle: const TextStyle(fontWeight: FontWeight.w600)),

              const SizedBox(height: 40),

              // ==================== CARD DE DETALHES (super bonito) ====================
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Detalhes do produto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),

                      // Código
                      _isEditing
                          ? TextField(controller: _codigoController, decoration: InputDecoration(labelText: 'Código interno', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))))
                          : _infoRow('Código', widget.produto['codigo'] ?? 'AUTO-${widget.produto['nome'].substring(0, 3).toUpperCase()}'),

                      const SizedBox(height: 20),

                      // Disponível em
                      const Text('Disponível em', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                      const SizedBox(height: 8),
                      _isEditing
                          ? Wrap(
                              spacing: 10,
                              children: _disponibilidades.map((opt) {
                                final selected = _disponivelEm.contains(opt);
                                return FilterChip(
                                  label: Text(opt),
                                  selected: selected,
                                  onSelected: (s) => setState(() => s ? _disponivelEm.add(opt) : _disponivelEm.remove(opt)),
                                );
                              }).toList(),
                            )
                          : Wrap(
                              spacing: 8,
                              children: _disponivelEm.map((item) => Chip(label: Text(item), backgroundColor: const Color(0xFF0055FF).withOpacity(0.1))).toList(),
                            ),

                      const SizedBox(height: 24),

                      // Descrição
                      _isEditing
                          ? TextField(controller: _descricaoController, maxLines: 5, decoration: InputDecoration(labelText: 'Descrição completa', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), alignLabelWithHint: true))
                          : _infoRow('Descrição', widget.produto['descricao'] ?? 'Produto de alta qualidade - ideal para o seu cardápio.'),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 50),

              // ==================== BOTÕES ====================
              if (_isEditing)
                Row(
                  children: [
                    Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300], foregroundColor: Colors.black87, padding: const EdgeInsets.symmetric(vertical: 18)), onPressed: _cancelEditing, child: const Text('Cancelar', style: TextStyle(fontSize: 18)))),
                    const SizedBox(width: 16),
                    Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 18)), onPressed: _saveEditing, child: const Text('Salvar Alterações', style: TextStyle(fontSize: 18)))),
                  ],
                )
              else
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () => Navigator.pop(context), child: const Text('Voltar ao Cardápio', style: TextStyle(fontSize: 18))),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Color(0xFF0055FF))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}