import 'package:flutter/material.dart';

import '../models/medicamento.dart';
import '../services/inventario_store.dart';

/// Pantalla de resumen: muestra estadisticas generales del inventario
/// calculadas en memoria a partir de la lista de medicamentos.
class ResumenScreen extends StatelessWidget {
  const ResumenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Resumen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListenableBuilder(
        listenable: inventarioStore,
        builder: (context, _) {
          final store = inventarioStore;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Tarjetas de metricas principales.
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _metrica(theme, 'Medicamentos',
                      '${store.totalMedicamentos}', Icons.medication,
                      const Color(0xFF0F6E56)),
                  _metrica(theme, 'Unidades totales',
                      '${store.unidadesTotales}', Icons.inventory_2,
                      const Color(0xFF378ADD)),
                  _metrica(theme, 'Stock bajo', '${store.totalBajos}',
                      Icons.warning_amber_rounded, const Color(0xFFBA7517)),
                  _metrica(theme, 'Agotados', '${store.totalAgotados}',
                      Icons.cancel, const Color(0xFFA32D2D)),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Existencias por categoría',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _porCategoria(theme, store),
            ],
          );
        },
      ),
    );
  }

  Widget _metrica(ThemeData theme, String titulo, String valor, IconData icono,
      Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icono, color: color),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valor,
                  style: theme.textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold, color: color),
                ),
                Text(
                  titulo,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Lista la cantidad de unidades acumuladas por cada categoria.
  Widget _porCategoria(ThemeData theme, InventarioStore store) {
    // Suma las unidades en stock agrupadas por categoria (en memoria).
    final mapa = <Categoria, int>{};
    for (final m in store.medicamentos) {
      mapa[m.categoria] = (mapa[m.categoria] ?? 0) + m.stock;
    }

    final entradas = mapa.entries.where((e) => e.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final maximo = entradas.isEmpty
        ? 1
        : entradas.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    if (entradas.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Sin existencias registradas'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            for (final e in entradas) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(e.key.icono, color: e.key.color, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text(e.key.label)),
                        Text(
                          '${e.value}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Barra de progreso proporcional al maximo.
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: e.value / maximo,
                        minHeight: 8,
                        backgroundColor: e.key.color.withValues(alpha: 0.12),
                        valueColor: AlwaysStoppedAnimation(e.key.color),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
