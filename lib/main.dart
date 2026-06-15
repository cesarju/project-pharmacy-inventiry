import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const FarmaciaApp());
}

/// Aplicacion de Control de Inventario de Farmacia.
///
/// Funciona completamente sin conexion: los datos viven en memoria.
class FarmaciaApp extends StatelessWidget {
  const FarmaciaApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Color principal de la marca de la app.
    const semilla = Color(0xFF0F6E56);

    return MaterialApp(
      title: 'Inventario de Farmacia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: semilla),
        scaffoldBackgroundColor: const Color(0xFFF7F8F7),
        cardTheme: const CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(14)),
            side: BorderSide(color: Color(0x14000000)),
          ),
          color: Colors.white,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0x22000000)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0x22000000)),
          ),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          elevation: 0,
          scrolledUnderElevation: 0.5,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
