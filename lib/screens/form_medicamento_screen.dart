import 'package:flutter/material.dart';

import '../models/medicamento.dart';
import '../services/inventario_store.dart';

class FormMedicamentoScreen extends StatefulWidget {
  const FormMedicamentoScreen({super.key, this.medicamento});

  final Medicamento? medicamento;

  @override
  State<FormMedicamentoScreen> createState() => _FormMedicamentoScreenState();
}

class _FormMedicamentoScreenState extends State<FormMedicamentoScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nombreCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _minimoCtrl;
  late final TextEditingController _laboratorioCtrl;
  late Categoria _categoria;

  bool get _esEdicion => widget.medicamento != null;

  @override
  void initState() {
    super.initState();
    final m = widget.medicamento;
    _nombreCtrl = TextEditingController(text: m?.nombre ?? '');
    _stockCtrl = TextEditingController(text: m?.stock.toString() ?? '');
    _minimoCtrl = TextEditingController(text: m?.stockMinimo.toString() ?? '');
    _laboratorioCtrl = TextEditingController(text: m?.laboratorio ?? '');
    _categoria = m?.categoria ?? Categoria.analgesico;
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _stockCtrl.dispose();
    _minimoCtrl.dispose();
    _laboratorioCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esEdicion ? 'Editar medicamento' : 'Nuevo medicamento'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nombreCtrl,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Nombre del medicamento',
                prefixIcon: Icon(Icons.medication),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Ingresa un nombre' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<Categoria>(
              initialValue: _categoria,
              decoration: const InputDecoration(
                labelText: 'Categoría',
                prefixIcon: Icon(Icons.category),
              ),
              items: [
                for (final c in Categoria.values)
                  DropdownMenuItem(
                    value: c,
                    child: Row(
                      children: [
                        Icon(c.icono, color: c.color, size: 20),
                        const SizedBox(width: 8),
                        Text(c.label),
                      ],
                    ),
                  ),
              ],
              onChanged: (c) => setState(() => _categoria = c!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _laboratorioCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Laboratorio (opcional)',
                prefixIcon: Icon(Icons.business),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _stockCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stock actual',
                      prefixIcon: Icon(Icons.inventory),
                    ),
                    validator: _validarEntero,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _minimoCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Stock mínimo',
                      prefixIcon: Icon(Icons.low_priority),
                    ),
                    validator: _validarEntero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: _guardar,
              icon: const Icon(Icons.save),
              label: Text(
                  _esEdicion ? 'Guardar cambios' : 'Agregar al inventario'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _validarEntero(String? v) {
    if (v == null || v.trim().isEmpty) return 'Requerido';
    final n = int.tryParse(v.trim());
    if (n == null) return 'Número inválido';
    if (n < 0) return 'No puede ser negativo';
    return null;
  }

  void _guardar() {
    if (!_formKey.currentState!.validate()) return;

    final nombre = _nombreCtrl.text;
    final stock = int.parse(_stockCtrl.text.trim());
    final minimo = int.parse(_minimoCtrl.text.trim());
    final lab = _laboratorioCtrl.text;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    if (_esEdicion) {
      inventarioStore.editarMedicamento(
        widget.medicamento!,
        nombre: nombre,
        categoria: _categoria,
        stock: stock,
        stockMinimo: minimo,
        laboratorio: lab,
      );
    } else {
      inventarioStore.agregarMedicamento(
        nombre: nombre,
        categoria: _categoria,
        stock: stock,
        stockMinimo: minimo,
        laboratorio: lab,
      );
    }

    navigator.pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
            _esEdicion ? 'Medicamento actualizado' : 'Medicamento agregado'),
      ),
    );
  }
}
