import 'package:flutter/material.dart';

import '../models/movimiento.dart';
import '../services/inventario_store.dart';

/// Pantalla que muestra el historial de movimientos (dispensaciones e
/// ingresos) registrados durante el uso de la app.
class MovimientosScreen extends StatelessWidget {
  const MovimientosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Movimientos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListenableBuilder(
        listenable: inventarioStore,
        builder: (context, _) {
          final movimientos = inventarioStore.movimientos;

          if (movimientos.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history,
                      size: 64, color: theme.colorScheme.outline),
                  const SizedBox(height: 12),
                  Text(
                    'Aún no hay movimientos registrados',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Dispensa o ingresa stock para verlos aquí',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: movimientos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) => _tarjeta(theme, movimientos[i]),
          );
        },
      ),
    );
  }

  Widget _tarjeta(ThemeData theme, Movimiento m) {
    final esSalida = m.tipo == TipoMovimiento.salida;
    final color = esSalida ? const Color(0xFFD85A30) : const Color(0xFF1D9E75);
    final icono = esSalida ? Icons.arrow_upward : Icons.arrow_downward;
    final signo = esSalida ? '-' : '+';

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.14),
          child: Icon(icono, color: color),
        ),
        title: Text(
          m.medicamentoNombre,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${m.tipo.label}'
          '${m.responsable.isEmpty ? '' : ' · ${m.responsable}'}\n'
          '${_formatearFecha(m.fecha)}',
        ),
        isThreeLine: true,
        trailing: Text(
          '$signo${m.cantidad}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  /// Da formato legible a la fecha sin usar paquetes externos.
  String _formatearFecha(DateTime f) {
    String dos(int n) => n.toString().padLeft(2, '0');
    return '${dos(f.day)}/${dos(f.month)}/${f.year}  ${dos(f.hour)}:${dos(f.minute)}';
  }
}
