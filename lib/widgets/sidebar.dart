import 'package:flutter/material.dart';

class Sidebar extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected; // ← callback para mudar tela

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  bool _isSidebarCollapsed = false;
  int _hoveredIndex = -1;

  Widget _buildMenuItem(IconData icon, String title, int index) {
    final bool selected = widget.selectedIndex == index;
    final bool hovered = _hoveredIndex == index;
    final bool showText = !_isSidebarCollapsed;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = -1),
      child: ListTile(
        contentPadding: _isSidebarCollapsed
            ? const EdgeInsets.symmetric(horizontal: 0, vertical: 4)
            : const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        minLeadingWidth: _isSidebarCollapsed ? 0 : 40,
        leading: Icon(
          icon,
          color: (selected || hovered) ? Colors.white : Colors.white70,
          size: _isSidebarCollapsed ? 32 : 24,
        ),
        title: showText
            ? Text(
                title,
                style: TextStyle(
                  color: (selected || hovered) ? Colors.white : Colors.white70,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              )
            : null,
        hoverColor: Colors.white.withOpacity(0.15),
        selected: selected,
        selectedTileColor: Colors.white.withOpacity(0.15),
        onTap: () {
          if (widget.selectedIndex == index) return;
          widget.onItemSelected(index); // ← avisa o HomeDesktop
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: _isSidebarCollapsed ? 72 : 280,
      color: const Color(0xFF0033AA),
      child: Column(
        children: [
          // ==================== HEADER ====================
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            color: const Color(0xFF0055FF),
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isSidebarCollapsed
                    ? const Icon(Icons.storefront, color: Colors.white, size: 36)
                    : const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Naoto',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Naoto Pro',
                            style: TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                if (!_isSidebarCollapsed) const SizedBox(width: 16),
                IconButton(
                  icon: Icon(
                    _isSidebarCollapsed ? Icons.chevron_right : Icons.chevron_left,
                    color: Colors.white,
                    size: 32,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: _isSidebarCollapsed ? 'Expandir menu' : 'Colapsar menu',
                  onPressed: () {
                    setState(() {
                      _isSidebarCollapsed = !_isSidebarCollapsed;
                      _hoveredIndex = -1;
                    });
                  },
                ),
              ],
            ),
          ),

          // ==================== MENU ====================
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(Icons.dashboard, 'Dashboard', 0),
            _buildMenuItem(Icons.point_of_sale, 'PDV / Frente de Caixa', 1),
            _buildMenuItem(Icons.inventory_2, 'Produtos / Cardápio', 2),
            _buildMenuItem(Icons.category, 'Categorias e Complementos', 3),
            _buildMenuItem(Icons.local_offer, 'Promoções ', 4),
           // _buildMenuItem(Icons.receipt_long, 'Comandas Abertas / Pedidos em Aberto', 5),
           // _buildMenuItem(Icons.table_restaurant, 'Gerenciamento de Mesas', 6),
           // _buildMenuItem(Icons.kitchen, 'KDS Cozinha', 7),
           // _buildMenuItem(Icons.delivery_dining, 'Delivery / Entregas', 8),
            const Divider(color: Colors.white24, height: 32),
           // _buildMenuItem(Icons.warning_amber_rounded, 'Validades / Próximas a Vencer', 9),
           // _buildMenuItem(Icons.inventory, 'Controle de Estoque', 10),
           // _buildMenuItem(Icons.list_alt, 'Lista de Compras / Sugestão', 11),
            _buildMenuItem(Icons.attach_money, 'Financeiro / Caixa', 12),
           // _buildMenuItem(Icons.trending_up, 'Relatórios e Indicadores', 13),
           // _buildMenuItem(Icons.bar_chart, 'Análises e DRE', 14),
            const Divider(color: Colors.white24, height: 32),
            _buildMenuItem(Icons.person, 'Colaboradores', 15),
           // _buildMenuItem(Icons.dashboard_customize, 'Painel do Usuário', 16),
            _buildMenuItem(Icons.settings, 'Configurações', 17),
              ],
            ),
          ),

          // ==================== RODAPÉ ====================
          Padding(
            padding: const EdgeInsets.all(12),
            child: _isSidebarCollapsed
                ? const CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Color(0xFF0055FF)),
                  )
                : Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Color(0xFF0055FF)),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Usuário', style: TextStyle(color: Colors.white, fontSize: 14)),
                            Text('Expira em: 12/11/2026',
                                style: TextStyle(color: Colors.white60, fontSize: 12)),
                          ],
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