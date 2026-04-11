import 'package:flutter/material.dart';

class SettingsDesktop extends StatefulWidget {
  const SettingsDesktop({super.key});

  @override
  State<SettingsDesktop> createState() => _SettingsDesktopState();
}

class _SettingsDesktopState extends State<SettingsDesktop> {
  // Controle de abas
  String _abaSelecionada = 'Geral';
  
  // Lista de abas atualizada (Sem Impressão e Etiquetas)
  final List<String> _abas = [
    'Geral',
    'Taxas e Pagamentos',
    'Segurança'
  ];

  // ==========================================
  // CONTROLADORES E VARIÁVEIS
  // ==========================================
  
  // Variáveis - ABA GERAL (Nome da loja agora é apenas uma String estática)
  final String _nomeLojaEstatico = 'Minha Loja Principal';
  
  final _cnpjCtrl = TextEditingController(text: '00.000.000/0001-00');
  final _telefoneCtrl = TextEditingController(text: '(11) 99999-9999');
  final _emailCtrl = TextEditingController(text: 'contato@minhaloja.com.br');
  final _enderecoCtrl = TextEditingController(text: 'Av. Principal, 1000 - Centro');
  final _horarioCtrl = TextEditingController(text: 'Seg a Sáb, das 08h às 18h');
  String _segmentoSelecionado = 'Alimentação / Restaurante';

  // Variáveis - ABA PAGAMENTOS
  final _taxaEntregaCtrl = TextEditingController(text: '5.00');
  bool _aceitaPix = true;
  bool _aceitaCartao = true;
  bool _aceitaDinheiro = true;

  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    // === LÓGICA DE RESPONSIVIDADE ===
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmall = screenWidth < 700;
    
    final double paddingGeral = isSmall ? 16 : 32;
    final double headerTextSize = isSmall ? 24 : 32;

    return Padding(
      padding: EdgeInsets.all(paddingGeral),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              Text(
                'Configurações',
                style: TextStyle(fontSize: headerTextSize, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text('Salvar Alterações', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, 
                  padding: EdgeInsets.symmetric(horizontal: isSmall ? 20 : 28, vertical: isSmall ? 14 : 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 3,
                ),
                onPressed: _salvarConfiguracoes,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // CONTEÚDO PRINCIPAL (Dividido entre Desktop e Mobile)
          Expanded(
            child: isSmall ? _buildMobileLayout() : _buildDesktopLayout(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // LAYOUT DESKTOP (Menu Lateral + Form)
  // ==========================================
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar de Menus
        Container(
          width: 250,
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(16), 
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(20), 
                child: Text('Preferências', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _abas.length,
                  itemBuilder: (context, i) {
                    final aba = _abas[i];
                    final selecionado = aba == _abaSelecionada;
                    return ListTile(
                      selected: selecionado,
                      selectedTileColor: const Color(0xFF0055FF).withOpacity(0.12),
                      leading: Icon(
                        _getIconForAba(aba), 
                        color: selecionado ? const Color(0xFF0055FF) : Colors.grey[600]
                      ),
                      title: Text(aba, style: TextStyle(fontWeight: selecionado ? FontWeight.bold : FontWeight.w500)),
                      onTap: () => setState(() => _abaSelecionada = aba),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),

        // Área do Formulário Ativo
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(16), 
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)]
            ),
            child: SingleChildScrollView(
              child: _buildFormularioAtivo(),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // LAYOUT MOBILE (Chips no topo + Form)
  // ==========================================
  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Menu Horizontal ROLÁVEL (Chips)
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _abas.map((aba) {
              final isSelected = aba == _abaSelecionada;
              return Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 16),
                child: FilterChip(
                  selected: isSelected,
                  label: Text(aba),
                  onSelected: (_) => setState(() => _abaSelecionada = aba),
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

        // Área do Formulário Ativo
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(16), 
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)]
            ),
            child: SingleChildScrollView(
              child: _buildFormularioAtivo(),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // RENDERIZAÇÃO DOS FORMULÁRIOS
  // ==========================================
  Widget _buildFormularioAtivo() {
    switch (_abaSelecionada) {
      case 'Geral':
        return _buildAbaGeral();
      case 'Taxas e Pagamentos':
        return _buildAbaPagamentos();
      case 'Segurança':
        return const Center(child: Text('Configurações de segurança e senhas...', style: TextStyle(color: Colors.grey)));
      default:
        return const Center(child: Text('Em desenvolvimento...', style: TextStyle(color: Colors.grey)));
    }
  }

  Widget _buildAbaGeral() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Informações Básicas', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Dados do seu estabelecimento exibidos no aplicativo e recibos.', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 32),
        
        // NOME DA LOJA (ESTÁTICO)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome da Loja (Não alterável)', style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.storefront, color: Colors.black54),
                  const SizedBox(width: 12),
                  Text(
                    _nomeLojaEstatico, 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)
                  ),
                ],
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // NOVOS CAMPOS ADICIONADOS
        Row(
          children: [
            Expanded(child: TextField(controller: _cnpjCtrl, decoration: const InputDecoration(labelText: 'CNPJ', border: OutlineInputBorder()))),
            const SizedBox(width: 16),
            Expanded(child: TextField(controller: _telefoneCtrl, decoration: const InputDecoration(labelText: 'Telefone / WhatsApp', border: OutlineInputBorder()))),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(child: TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'E-mail de Contato', border: OutlineInputBorder()))),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _segmentoSelecionado,
                decoration: const InputDecoration(labelText: 'Segmento da Loja', border: OutlineInputBorder()),
                items: ['Alimentação / Restaurante', 'Varejo / Roupas', 'Serviços', 'Mercado / Conveniência', 'Outros']
                    .map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) { if (val != null) setState(() => _segmentoSelecionado = val); },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        TextField(controller: _enderecoCtrl, decoration: const InputDecoration(labelText: 'Endereço Completo', border: OutlineInputBorder())),
        const SizedBox(height: 16),

        TextField(controller: _horarioCtrl, decoration: const InputDecoration(labelText: 'Horário de Funcionamento', border: OutlineInputBorder())),
      ],
    );
  }

  Widget _buildAbaPagamentos() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Taxas e Formas de Pagamento', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        
        SizedBox(
          width: 300,
          child: TextField(
            controller: _taxaEntregaCtrl, 
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Taxa de Entrega Padrão (R\$)', prefixText: 'R\$ ', border: OutlineInputBorder())
          ),
        ),
        const SizedBox(height: 32),

        const Text('Aceitar Pagamentos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Pix'),
                secondary: const Icon(Icons.pix, color: Colors.teal),
                value: _aceitaPix,
                activeColor: const Color(0xFF0055FF),
                onChanged: (val) => setState(() => _aceitaPix = val),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Cartão de Crédito/Débito'),
                secondary: const Icon(Icons.credit_card, color: Colors.blueGrey),
                value: _aceitaCartao,
                activeColor: const Color(0xFF0055FF),
                onChanged: (val) => setState(() => _aceitaCartao = val),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Dinheiro'),
                secondary: const Icon(Icons.payments_outlined, color: Colors.green),
                value: _aceitaDinheiro,
                activeColor: const Color(0xFF0055FF),
                onChanged: (val) => setState(() => _aceitaDinheiro = val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ==========================================
  // LÓGICAS E UTILITÁRIOS
  // ==========================================
  IconData _getIconForAba(String aba) {
    switch (aba) {
      case 'Geral': return Icons.storefront_outlined;
      case 'Taxas e Pagamentos': return Icons.attach_money_outlined;
      case 'Segurança': return Icons.security_outlined;
      default: return Icons.settings;
    }
  }

  void _salvarConfiguracoes() async {
    setState(() => _isSaving = true);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Salvando configurações...'))
    );

    // Simulando API
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Preferências atualizadas com sucesso!'), backgroundColor: Colors.green)
      );
    }
  }
}