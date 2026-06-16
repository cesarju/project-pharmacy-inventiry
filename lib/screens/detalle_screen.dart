import 'package:flutter/material.dart';

import '../models/medicamento.dart';
import '../services/inventario_store.dart';
import '../widgets/stock_badge.dart';
import 'form_medicamento_screen.dart';

class DetalleScreen extends StatelessWidget {
  const DetalleScreen({super.key, required this.medicamento});

  final Medicamento medicamento;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle'),
        actions: [
          IconButton(
            tooltip: 'Editar',
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      FormMedicamentoScreen(medicamento: medicamento),
                ),
              );
            },
          ),
          IconButton(
            tooltip: 'Eliminar',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmarEliminar(context),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: inventarioStore,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _encabezado(theme),
              const SizedBox(height: 20),
              _tarjetaStock(theme),
              const SizedBox(height: 20),
              _datos(theme),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: medicamento.estaAgotado
                          ? null
                          : () => _dialogoCantidad(context, esSalida: true),
                      icon: const Icon(Icons.remove_circle_outline),
                      label: const Text('Dispensar'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _dialogoCantidad(context, esSalida: false),
                      icon: const Icon(Icons.add_circle_outline),
                      label: const Text('Ingresar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _encabezado(ThemeData theme) {
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: medicamento.categoria.color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(medicamento.categoria.icono,
              color: medicamento.categoria.color, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medicamento.nombre,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              StockBadge(estado: medicamento.estado),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tarjetaStock(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Text(
              '${medicamento.stock}',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
              'unidades en stock',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _datos(ThemeData theme) {
    return Card(
      child: Column(
        children: [
          _fila(
              theme, Icons.category, 'Categoría', medicamento.categoria.label),
          const Divider(height: 1),
          _fila(theme, Icons.business, 'Laboratorio',
              medicamento.laboratorio.isEmpty ? '—' : medicamento.laboratorio),
          const Divider(height: 1),
          _fila(theme, Icons.low_priority, 'Stock mínimo',
              '${medicamento.stockMinimo} unidades'),
        ],
      ),
    );
  }

  Widget _fila(ThemeData theme, IconData icono, String titulo, String valor) {
    return ListTile(
      leading: Icon(icono, color: theme.colorScheme.primary),
      title: Text(titulo),
      trailing: Text(
        valor,
        style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
      ),
    );
  }

  /// Dialogo para pedir la cantidad a dispensar o ingresar.
  void _dialogoCantidad(BuildContext context, {required bool esSalida}) {
    final cantidadCtrl = TextEditingController();
    final responsableCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(esSalida ? 'Dispensar medicamento' : 'Ingresar stock'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (esSalida)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Disponible: ${medicamento.stock} unidades',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                TextFormField(
                  controller: cantidadCtrl,
                  keyboardType: TextInputType.number,
                  autofocus: true,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                  validator: (v) {
                    final n = int.tryParse(v?.trim() ?? '');
                    if (n == null || n <= 0) return 'Cantidad inválida';
                    if (esSalida && n > medicamento.stock) {
                      return 'No hay suficiente stock';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: responsableCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    labelText: 'Responsable (opcional)',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                final cantidad = int.parse(cantidadCtrl.text.trim());
                final responsable = responsableCtrl.text;

                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);

                if (esSalida) {
                  inventarioStore.dispensar(medicamento,
                      cantidad: cantidad, responsable: responsable);
                } else {
                  inventarioStore.ingresarStock(medicamento,
                      cantidad: cantidad, responsable: responsable);
                }

                navigator.pop();
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(esSalida
                        ? 'Dispensadas $cantidad unidades'
                        : 'Ingresadas $cantidad unidades'),
                  ),
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _confirmarEliminar(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar medicamento'),
          content: Text('¿Eliminar "${medicamento.nombre}" del inventario?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFFA32D2D)),
              onPressed: () {
                inventarioStore.eliminarMedicamento(medicamento);
                Navigator.pop(context); // cierra el dialogo
                Navigator.pop(context); // vuelve a la lista
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
