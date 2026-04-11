import 'package:flutter/material.dart';

import '../pdv/pdv_desktop.dart';
import '../card_menu/card_menu.dart';
import '../categories/categories.dart';
import '../promotions/promotions.dart';
import '../financial/financial.dart';
import '../command/command.dart';
import '../table/table.dart';
import '../kitchen/kitchen.dart';
import '../delivery/deliviry_manegement.dart';
import '../validity/validity.dart';
import '../stock/stock.dart';
import '../shopping list/shopping list.dart';
import '../collaborators/collaborators.dart';
import '../settings/settings.dart';

// ← NOVO IMPORT (o sidebar que criamos separado)
import '../../widgets/sidebar.dart';          // ← mude o caminho se estiver em outra pasta

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

  // Lista de telas (continua igual)
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
    const FinanceDesktop(),
   // const OpenOrdersDesktop(),
    // const TableManagementDesktop(),
    // const KdsKitchenDesktop(),
    // const DeliveryManagementDesktop(),
    // const ExpirationsDesktop(),
    // const StockControlDesktop(),
    // const ShoppingListDesktop(),
        const EmployeesDesktop(),
    // const SimpleScreen(title: 'Relatórios e Indicadores'),
    // const SimpleScreen(title: 'Análises e DRE'),
    // const EmployeesDesktop(),
    // const SimpleScreen(title: 'Painel do Usuário'),
    const SettingsDesktop(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // ← SIDEBAR SEPARADO (agora é um widget limpo)
          Sidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) {
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

          // Conteúdo principal
          Expanded(
            child: Column(
              children: [
                // Top Bar
                Container(
                  height: 70,
                  color: const Color(0xFF0055FF),
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    children: [
                      Text(
                        _selectedIndex == 0 ? 'Dashboard - Naoto Pro' : 'Naoto Pro',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Text('Modo: ', style: TextStyle(color: Colors.white70)),
                          Text(
                            _isRestaurantMode ? 'Restaurante' : 'Loja',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Switch(
                            value: _isRestaurantMode,
                            activeColor: Colors.white,
                            onChanged: (val) => setState(() => _isRestaurantMode = val),
                          ),
                          const SizedBox(width: 32),
                          const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, color: Color(0xFF0055FF)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Área de conteúdo
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

  // ==================== FUNÇÕES ESTÁTICAS DO DASHBOARD ====================
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