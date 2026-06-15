import 'package:flutter/material.dart';

import '../models/medicamento.dart';
import '../services/inventario_store.dart';
import '../widgets/medicamento_card.dart';
import 'detalle_screen.dart';
import 'form_medicamento_screen.dart';

/// Pantalla principal: muestra la lista de medicamentos del inventario,
/// con una barra de busqueda y filtros por estado y categoria.
class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  String _busqueda = '';
  FiltroEstado _filtroEstado = FiltroEstado.todos;
  Categoria? _filtroCategoria;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inventario de Farmacia',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      // Escucha el store en memoria: la lista se refresca sola al cambiar.
      body: ListenableBuilder(
        listenable: inventarioStore,
        builder: (context, _) {
          final lista = inventarioStore.filtrar(
            estado: _filtroEstado,
            categoria: _filtroCategoria,
            busqueda: _busqueda,
          );

          return Column(
            children: [
              _barraBusqueda(),
              _bannerAlerta(),
              _filtrosEstado(theme),
              const SizedBox(height: 4),
              Expanded(
                child: lista.isEmpty
                    ? _vacio(theme)
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 90, top: 4),
                        itemCount: lista.length,
                        itemBuilder: (context, i) {
                          final m = lista[i];
                          return MedicamentoCard(
                            medicamento: m,
                            onTap: () => _abrirDetalle(m),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _abrirFormularioNuevo,
        icon: const Icon(Icons.add),
        label: const Text('Agregar'),
      ),
    );
  }

  // ----- SECCIONES DE LA INTERFAZ -----

  Widget _barraBusqueda() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Buscar medicamento...',
          prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(vertical: 0),
        ),
        onChanged: (v) => setState(() => _busqueda = v),
      ),
    );
  }

  /// Banner que avisa cuando hay medicamentos en stock bajo o agotados.
  Widget _bannerAlerta() {
    final bajos = inventarioStore.totalBajos;
    final agotados = inventarioStore.totalAgotados;
    if (bajos == 0 && agotados == 0) return const SizedBox.shrink();

    final partes = <String>[];
    if (bajos > 0) partes.add('$bajos con stock bajo');
    if (agotados > 0) partes.add('$agotados agotado(s)');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAEEDA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEF9F27)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFF854F0B)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Atención: ${partes.join(' y ')}.',
              style: const TextStyle(
                color: Color(0xFF854F0B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Chips para filtrar por estado del stock.
  Widget _filtrosEstado(ThemeData theme) {
    final opciones = <(String, FiltroEstado)>[
      ('Todos', FiltroEstado.todos),
      ('Disponibles', FiltroEstado.disponibles),
      ('Stock bajo', FiltroEstado.bajos),
      ('Agotados', FiltroEstado.agotados),
    ];

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          for (final (etiqueta, valor) in opciones)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(etiqueta),
                selected: _filtroEstado == valor,
                onSelected: (_) => setState(() => _filtroEstado = valor),
              ),
            ),
          // Filtro adicional por categoria.
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              avatar: const Icon(Icons.filter_list, size: 18),
              label: Text(_filtroCategoria?.label ?? 'Categoría'),
              onPressed: _elegirCategoria,
            ),
          ),
        ],
      ),
    );
  }

  Widget _vacio(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.medication_outlined,
              size: 64, color: theme.colorScheme.outline),
          const SizedBox(height: 12),
          Text(
            'No hay medicamentos que coincidan',
            style: theme.textTheme.titleMedium
                ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  // ----- NAVEGACION Y ACCIONES -----

  void _abrirDetalle(Medicamento m) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => DetalleScreen(medicamento: m)),
    );
  }

  void _abrirFormularioNuevo() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const FormMedicamentoScreen()),
    );
  }

  /// Muestra una hoja inferior para escoger la categoria a filtrar.
  void _elegirCategoria() {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Filtrar por categoría',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              ListTile(
                leading: const Icon(Icons.clear_all),
                title: const Text('Todas las categorías'),
                onTap: () {
                  setState(() => _filtroCategoria = null);
                  Navigator.pop(context);
                },
              ),
              for (final c in Categoria.values)
                ListTile(
                  leading: Icon(c.icono, color: c.color),
                  title: Text(c.label),
                  trailing: _filtroCategoria == c
                      ? const Icon(Icons.check)
                      : null,
                  onTap: () {
                    setState(() => _filtroCategoria = c);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
