import 'package:flutter/material.dart';

import 'inventario_screen.dart';
import 'movimientos_screen.dart';
import 'resumen_screen.dart';

/// Pantalla contenedora con la barra de navegacion inferior.
///
/// Permite moverse entre las tres secciones principales de la app:
/// Inventario, Movimientos y Resumen.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indice = 0;

  // Pantallas asociadas a cada pestana de la barra inferior.
  static const _pantallas = <Widget>[
    InventarioScreen(),
    MovimientosScreen(),
    ResumenScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pantallas[_indice],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indice,
        onDestinationSelected: (i) => setState(() => _indice = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventario',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_vert_outlined),
            selectedIcon: Icon(Icons.swap_vert),
            label: 'Movimientos',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights),
            label: 'Resumen',
          ),
        ],
      ),
    );
  }
}
