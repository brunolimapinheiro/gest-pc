// lib/screens/mobile/home_mobile.dart
import 'package:flutter/material.dart';

class HomeMobile extends StatefulWidget {
  const HomeMobile({super.key});

  @override
  State<HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<HomeMobile> {
  int _selectedIndex = 0;

  static const List<Widget> _telas = <Widget>[
    Center(child: Text('Início - Dashboard Mobile', style: TextStyle(fontSize: 24))),
    Center(child: Text('Produtos - Cadastro e Lista')),
    Center(child: Text('Validades - Alertas e Lista')),
    Center(child: Text('Impressão - Etiquetas (chama KMP)')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Naoto Mobile')),
      body: _telas[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF0055FF),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: 'Produtos'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Validades'),
          BottomNavigationBarItem(icon: Icon(Icons.print), label: 'Impressão'),
        ],
      ),
    );
  }
}