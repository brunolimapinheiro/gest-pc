import 'package:flutter/material.dart';
import 'screens/dashboard/home_desktop.dart';
import 'screens/mobile/home_mobile.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Gest());
}

class Gest extends StatelessWidget {
  const Gest({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF0055FF),     // Azul exato das suas telas
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0055FF)),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0055FF),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const PlatformHome(),
    );
  }
}

class PlatformHome extends StatelessWidget {
  const PlatformHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Detecta se está rodando no PC (Windows/Linux/Mac)
    final isDesktop = MediaQuery.of(context).size.width > 1024;

    return isDesktop 
        ? const HomeDesktop()   // ← VERSÃO PC COMPLETA (PDV + tudo)
        : const HomeMobile();   // ← Sua versão mobile leve (etiquetas)
  }
}