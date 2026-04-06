import 'package:flutter/material.dart';
import '../pdv/pdv_desktop.dart';
import '../card_menu/card_menu.dart';
import '../categories/categories.dart';
import '../promotions/promotions.dart';
import '../command/command.dart';
import '../table/table.dart';
import '../kitchen/kitchen.dart';
import '../delivery/deliviry_manegement.dart ';
import '../validity/validity.dart';
import '../stock/stock.dart';
import '../shopping list/shopping list.dart';
import '../collaborators/collaborators.dart';

void main() {
  runApp(const NaotoProApp());
}

class NaotoProApp extends StatelessWidget {
  const NaotoProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0055FF),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Segoe UI',
      ),
      home: const HomeDesktop(),
    );
  }
}

class HomeDesktop extends StatefulWidget {
  const HomeDesktop({super.key});

  @override
  State<HomeDesktop> createState() => _HomeDesktopState();
}

class _HomeDesktopState extends State<HomeDesktop> {
  bool _isRestaurantMode = false;
  int _selectedIndex = 0;
  bool _isLoading = false;
  bool _isSidebarCollapsed = false;   // ← NOVO: esconder menu
  int _hoveredIndex = -1;             // ← NOVO: hover do mouse

  final List<Widget> _screens = [
    // 0 - Dashboard
    SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStatusCardStatic(Icons.warning_amber_rounded, Colors.red, 'Validades\nVencidas', '0 un.'),
              _buildStatusCardStatic(Icons.calendar_today, const Color(0xFF0055FF), 'Validades\nRegistradas', '0 un.'),
              _buildStatusCardStatic(Icons.inventory_2, Colors.green, 'Produtos\nCadastrados', '1 un.'),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(child: _buildActionButtonStatic('Cadastrar Produto', Icons.add_circle_outline)),
              const SizedBox(width: 16),
              Expanded(child: _buildActionButtonStatic('Responsáveis', Icons.person_add_alt_1)),
              const SizedBox(width: 16),
              Expanded(child: _buildActionButtonStatic('Painel do Usuário', Icons.dashboard_customize)),
            ],
          ),
          const SizedBox(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildSmallInfoCardStatic('Vendas Hoje', 'R\$ 245,00', Icons.attach_money, Colors.green),
              _buildSmallInfoCardStatic('Itens em Baixo Estoque', '2', Icons.trending_down, Colors.orange),
              _buildSmallInfoCardStatic('Comandas Abertas / Pedidos em Aberto', '3', Icons.receipt_long, const Color(0xFF0055FF)),
            ],
          ),
        ],
      ),
    ),

    const PdvDesktop(),

    const ProductsDesktop(),
    const CategoriesDesktop(),
    const PromotionsAndCombosDesktop(),
    const OpenOrdersDesktop(),
    const TableManagementDesktop(),
    const KdsKitchenDesktop(),
    const DeliveryManagementDesktop(),
    const ExpirationsDesktop(),
    const StockControlDesktop(),
    const ShoppingListDesktop(),
    const SimpleScreen(title: 'Financeiro / Caixa'),
    const SimpleScreen(title: 'Relatórios e Indicadores'),
    const SimpleScreen(title: 'Análises e DRE'),
    const EmployeesDesktop(),
    const SimpleScreen(title: 'Painel do Usuário'),
    const SimpleScreen(title: 'Configurações'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar com animação de esconder
AnimatedContainer(
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  width: _isSidebarCollapsed ? 72 : 280,
  color: const Color(0xFF0033AA),
  child: Column(
    children: [
      // Header corrigido - botão sempre centralizado quando colapsado
      // HEADER CORRIGIDO - SEM OVERFLOW
Container(
  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
  color: const Color(0xFF0055FF),
  width: double.infinity,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center, // centraliza tudo quando colapsado
    children: [
      // Ícone ou logo
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

      // Espaço só quando EXPANDIDO
      if (!_isSidebarCollapsed) const SizedBox(width: 16),

      // Botão de toggle (sempre visível)
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
      // Menu itens
      Expanded(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: [
            _buildMenuItem(Icons.dashboard, 'Dashboard', 0),
            _buildMenuItem(Icons.point_of_sale, 'PDV / Frente de Caixa', 1),
            _buildMenuItem(Icons.inventory_2, 'Produtos / Cardápio', 2),
            _buildMenuItem(Icons.category, 'Categorias e Complementos', 3),
            _buildMenuItem(Icons.local_offer, 'Promoções e Combos', 4),
            _buildMenuItem(Icons.receipt_long, 'Comandas Abertas / Pedidos em Aberto', 5),
            _buildMenuItem(Icons.table_restaurant, 'Gerenciamento de Mesas', 6),
            _buildMenuItem(Icons.kitchen, 'KDS Cozinha', 7),
            _buildMenuItem(Icons.delivery_dining, 'Delivery / Entregas', 8),
            const Divider(color: Colors.white24, height: 32),
            _buildMenuItem(Icons.warning_amber_rounded, 'Validades / Próximas a Vencer', 9),
            _buildMenuItem(Icons.inventory, 'Controle de Estoque', 10),
            _buildMenuItem(Icons.list_alt, 'Lista de Compras / Sugestão', 11),
            _buildMenuItem(Icons.attach_money, 'Financeiro / Caixa', 12),
            _buildMenuItem(Icons.trending_up, 'Relatórios e Indicadores', 13),
            _buildMenuItem(Icons.bar_chart, 'Análises e DRE', 14),
            const Divider(color: Colors.white24, height: 32),
            _buildMenuItem(Icons.person, 'Colaboradores / Garçons / Motoboys', 15),
            _buildMenuItem(Icons.dashboard_customize, 'Painel do Usuário', 16),
            _buildMenuItem(Icons.settings, 'Configurações', 17),
          ],
        ),
      ),

      // Rodapé
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
                        Text(
                          'Usuário',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        Text(
                          'Expira em: 12/11/2026',
                          style: TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    ],
  ),
),
          // Conteúdo principal
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 70,
                  color: const Color(0xFF0055FF),
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Text(
                        _selectedIndex == 0 ? 'Dashboard - Naoto Pro' : 'Naoto Pro',
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Text('Modo: ', style: TextStyle(color: Colors.white70)),
                          Text(_isRestaurantMode ? 'Restaurante' : 'Loja', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          Switch(
                            value: _isRestaurantMode,
                            activeColor: Colors.white,
                            onChanged: (val) => setState(() => _isRestaurantMode = val),
                          ),
                          const SizedBox(width: 32),
                          const CircleAvatar(radius: 18, backgroundColor: Colors.white, child: Icon(Icons.person, color: Color(0xFF0055FF))),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(color: Color(0xFF0055FF), strokeWidth: 6),
                              SizedBox(height: 20),
                              Text('Carregando...', style: TextStyle(fontSize: 18, color: Colors.grey)),
                            ],
                          ),
                        )
                      : _screens[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== MENU COM HOVER E COLAPSADO ====================
Widget _buildMenuItem(IconData icon, String title, int index) {
  final bool selected = _selectedIndex == index;
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
        size: _isSidebarCollapsed ? 32 : 24,  // ícone maior quando colapsado
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
        if (_selectedIndex == index) return;

        setState(() => _isLoading = true);

        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            setState(() {
              _selectedIndex = index;
              _isLoading = false;
            });
          }
        });
      },
    ),
  );
}
  // Funções estáticas do Dashboard (mesmas de antes)
  static Widget _buildStatusCardStatic(IconData icon, Color color, String label, String value) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(icon, size: 56, color: color),
              const SizedBox(height: 16),
              Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildActionButtonStatic(String text, IconData icon) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28),
      label: Text(text, style: const TextStyle(fontSize: 18)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0055FF),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {},
    );
  }

  static Widget _buildSmallInfoCardStatic(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

class SimpleScreen extends StatelessWidget {
  final String title;
  const SimpleScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
    );
  }
}