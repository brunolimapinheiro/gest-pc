import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> produto;
  const ProductDetailsScreen({super.key, required this.produto});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isEditing = false;

  // ==================== CONTROLLERS ====================
  late TextEditingController _skuController;           // Código interno
  late TextEditingController _eanController;           // Código de barras
  late TextEditingController _nomeController;
  late TextEditingController _nomeComercialController;
  late TextEditingController _descricaoController;
  late TextEditingController _unidadePrincipalController;
  late TextEditingController _unidadeSecundariaController;
  late TextEditingController _categoriaController;
  late TextEditingController _subcategoriaController;
  late TextEditingController _marcaController;
  late TextEditingController _modeloController;
  late TextEditingController _referenciaFabricanteController;
  late TextEditingController _aplicacaoController;

  late String _imageUrl;

  final List<String> _unidades = ['un', 'kg', 'g', 'l', 'ml', 'cx', 'pct', 'm', 'm²'];

  @override
  void initState() {
    super.initState();

    _skuController = TextEditingController(text: widget.produto['sku'] ?? '');
    _eanController = TextEditingController(text: widget.produto['ean'] ?? '');
    _nomeController = TextEditingController(text: widget.produto['nome'] ?? '');
    _nomeComercialController = TextEditingController(text: widget.produto['nomeComercial'] ?? '');
    _descricaoController = TextEditingController(text: widget.produto['descricao'] ?? '');
    _unidadePrincipalController = TextEditingController(text: widget.produto['unidadePrincipal'] ?? 'un');
    _unidadeSecundariaController = TextEditingController(text: widget.produto['unidadeSecundaria'] ?? '');
    _categoriaController = TextEditingController(text: widget.produto['categoria'] ?? 'Geral');
    _subcategoriaController = TextEditingController(text: widget.produto['subcategoria'] ?? '');
    _marcaController = TextEditingController(text: widget.produto['marca'] ?? '');
    _modeloController = TextEditingController(text: widget.produto['modelo'] ?? '');
    _referenciaFabricanteController = TextEditingController(text: widget.produto['referenciaFabricante'] ?? '');
    _aplicacaoController = TextEditingController(text: widget.produto['aplicacao'] ?? '');

    _imageUrl = widget.produto['imagem'] ?? 'https://via.placeholder.com/400x400/0055FF/FFFFFF?text=Produto';

    // Garante que todos os campos existam no Map
    widget.produto.putIfAbsent('sku', () => _skuController.text);
    widget.produto.putIfAbsent('ean', () => _eanController.text);
    widget.produto.putIfAbsent('nomeComercial', () => _nomeComercialController.text);
    widget.produto.putIfAbsent('descricao', () => _descricaoController.text);
    widget.produto.putIfAbsent('unidadePrincipal', () => _unidadePrincipalController.text);
    widget.produto.putIfAbsent('unidadeSecundaria', () => _unidadeSecundariaController.text);
    widget.produto.putIfAbsent('categoria', () => _categoriaController.text);
    widget.produto.putIfAbsent('subcategoria', () => _subcategoriaController.text);
    widget.produto.putIfAbsent('marca', () => _marcaController.text);
    widget.produto.putIfAbsent('modelo', () => _modeloController.text);
    widget.produto.putIfAbsent('referenciaFabricante', () => _referenciaFabricanteController.text);
    widget.produto.putIfAbsent('aplicacao', () => _aplicacaoController.text);
    widget.produto.putIfAbsent('imagem', () => _imageUrl);
  }

  @override
  void dispose() {
    _skuController.dispose();
    _eanController.dispose();
    _nomeController.dispose();
    _nomeComercialController.dispose();
    _descricaoController.dispose();
    _unidadePrincipalController.dispose();
    _unidadeSecundariaController.dispose();
    _categoriaController.dispose();
    _subcategoriaController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _referenciaFabricanteController.dispose();
    _aplicacaoController.dispose();
    super.dispose();
  }

  void _startEditing() => setState(() => _isEditing = true);

  void _cancelEditing() {
    // Recarrega valores originais
    _skuController.text = widget.produto['sku'] ?? '';
    _eanController.text = widget.produto['ean'] ?? '';
    _nomeController.text = widget.produto['nome'] ?? '';
    _nomeComercialController.text = widget.produto['nomeComercial'] ?? '';
    _descricaoController.text = widget.produto['descricao'] ?? '';
    _unidadePrincipalController.text = widget.produto['unidadePrincipal'] ?? 'un';
    _unidadeSecundariaController.text = widget.produto['unidadeSecundaria'] ?? '';
    _categoriaController.text = widget.produto['categoria'] ?? 'Geral';
    _subcategoriaController.text = widget.produto['subcategoria'] ?? '';
    _marcaController.text = widget.produto['marca'] ?? '';
    _modeloController.text = widget.produto['modelo'] ?? '';
    _referenciaFabricanteController.text = widget.produto['referenciaFabricante'] ?? '';
    _aplicacaoController.text = widget.produto['aplicacao'] ?? '';
    _imageUrl = widget.produto['imagem'] ?? 'https://via.placeholder.com/400x400/0055FF/FFFFFF?text=Produto';

    setState(() => _isEditing = false);
  }

  void _saveEditing() {
    setState(() {
      widget.produto['sku'] = _skuController.text.trim();
      widget.produto['ean'] = _eanController.text.trim();
      widget.produto['nome'] = _nomeController.text.trim();
      widget.produto['nomeComercial'] = _nomeComercialController.text.trim();
      widget.produto['descricao'] = _descricaoController.text.trim();
      widget.produto['unidadePrincipal'] = _unidadePrincipalController.text.trim();
      widget.produto['unidadeSecundaria'] = _unidadeSecundariaController.text.trim();
      widget.produto['categoria'] = _categoriaController.text.trim();
      widget.produto['subcategoria'] = _subcategoriaController.text.trim();
      widget.produto['marca'] = _marcaController.text.trim();
      widget.produto['modelo'] = _modeloController.text.trim();
      widget.produto['referenciaFabricante'] = _referenciaFabricanteController.text.trim();
      widget.produto['aplicacao'] = _aplicacaoController.text.trim();
      widget.produto['imagem'] = _imageUrl;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Produto salvo com sucesso!'), backgroundColor: Colors.green),
    );
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Editar Produto' : (widget.produto['nome'] ?? 'Produto'),
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
                TextButton.icon(
                  icon: const Icon(Icons.close, color: Colors.white),
                  label: const Text('Cancelar', style: TextStyle(color: Colors.white)),
                  onPressed: _cancelEditing,
                ),
                TextButton.icon(
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text('Salvar', style: TextStyle(color: Colors.white)),
                  onPressed: _saveEditing,
                ),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================== IMAGEM DO PRODUTO ====================
            Center(
              child: Column(
                children: [
                  Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey[100],
                      image: _imageUrl.isNotEmpty
                          ? DecorationImage(image: NetworkImage(_imageUrl), fit: BoxFit.cover)
                          : null,
                    ),
                    child: _imageUrl.isEmpty
                        ? const Icon(Icons.image, size: 80, color: Colors.grey)
                        : null,
                  ),
                  if (_isEditing)
                    TextButton.icon(
                      onPressed: () {
                        // Aqui você pode integrar image_picker no futuro
                        setState(() {
                          _imageUrl = 'https://picsum.photos/id/${DateTime.now().millisecond}/600/600';
                        });
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Trocar imagem'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // ==================== CAMPOS PRINCIPAIS ====================
            _buildTextField(_nomeController, 'Nome do produto', enabled: _isEditing),
            const SizedBox(height: 12),
            _buildTextField(_nomeComercialController, 'Nome comercial (opcional)', enabled: _isEditing),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: _buildTextField(_skuController, 'Código interno (SKU)', enabled: _isEditing)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(_eanController, 'Código de barras (EAN/UPC)', enabled: _isEditing)),
              ],
            ),
            const SizedBox(height: 24),

            // ==================== UNIDADES ====================
            Row(
              children: [
                Expanded(
                  child: _buildTextField(_unidadePrincipalController, 'Unidade principal (ex: un, kg, l)', enabled: _isEditing),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(_unidadeSecundariaController, 'Unidade secundária (opcional)', enabled: _isEditing),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // ==================== CLASSIFICAÇÃO ====================
            const Text('Classificação', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextField(_categoriaController, 'Categoria / Grupo', enabled: _isEditing),
            const SizedBox(height: 12),
            _buildTextField(_subcategoriaController, 'Subcategoria', enabled: _isEditing),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: _buildTextField(_marcaController, 'Marca', enabled: _isEditing)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField(_modeloController, 'Modelo', enabled: _isEditing)),
              ],
            ),
            const SizedBox(height: 12),
            _buildTextField(_referenciaFabricanteController, 'Referência do fabricante', enabled: _isEditing),

            const SizedBox(height: 32),

            // ==================== DESCRIÇÃO E APLICAÇÃO ====================
            _buildTextField(_descricaoController, 'Descrição detalhada', maxLines: 4, enabled: _isEditing),
            const SizedBox(height: 24),
            _buildTextField(_aplicacaoController, 'Aplicação ou uso (opcional)', maxLines: 3, enabled: _isEditing),

            const SizedBox(height: 50),

            // ==================== BOTÕES ====================
            if (_isEditing)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300], foregroundColor: Colors.black87, padding: const EdgeInsets.symmetric(vertical: 18)),
                      onPressed: _cancelEditing,
                      child: const Text('Cancelar', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 18)),
                      onPressed: _saveEditing,
                      child: const Text('Salvar Alterações', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              )
            else
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Voltar ao Cardápio', style: TextStyle(fontSize: 18)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ==================== WIDGET AUXILIAR ====================
  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}