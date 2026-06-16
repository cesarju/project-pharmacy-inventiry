import 'package:flutter/foundation.dart';

import '../models/medicamento.dart';
import '../models/movimiento.dart';

enum FiltroEstado { todos, disponibles, bajos, agotados }

class InventarioStore extends ChangeNotifier {
  // Listas privadas que guardan el estado de la aplicacion.
  final List<Medicamento> _medicamentos = [];
  final List<Movimiento> _movimientos = [];

  int _contadorId = 0;

  InventarioStore() {
    _cargarDatosIniciales();
  }

  List<Medicamento> get medicamentos => List.unmodifiable(_medicamentos);

  List<Movimiento> get movimientos => List.unmodifiable(_movimientos);

  int get totalMedicamentos => _medicamentos.length;

  int get totalBajos => _medicamentos.where((m) => m.tieneStockBajo).length;

  int get totalAgotados => _medicamentos.where((m) => m.estaAgotado).length;

  int get unidadesTotales => _medicamentos.fold(0, (suma, m) => suma + m.stock);

  List<Medicamento> filtrar({
    FiltroEstado estado = FiltroEstado.todos,
    Categoria? categoria,
    String busqueda = '',
  }) {
    final texto = busqueda.trim().toLowerCase();

    return _medicamentos.where((m) {
      final coincideEstado = switch (estado) {
        FiltroEstado.todos => true,
        FiltroEstado.disponibles => m.estaDisponible,
        FiltroEstado.bajos => m.tieneStockBajo,
        FiltroEstado.agotados => m.estaAgotado,
      };

      final coincideCategoria = categoria == null || m.categoria == categoria;

      final coincideBusqueda =
          texto.isEmpty || m.nombre.toLowerCase().contains(texto);

      return coincideEstado && coincideCategoria && coincideBusqueda;
    }).toList();
  }

  void agregarMedicamento({
    required String nombre,
    required Categoria categoria,
    required int stock,
    required int stockMinimo,
    String laboratorio = '',
  }) {
    _medicamentos.add(
      Medicamento(
        id: _nuevoId(),
        nombre: nombre.trim(),
        categoria: categoria,
        stock: stock,
        stockMinimo: stockMinimo,
        laboratorio: laboratorio.trim(),
      ),
    );
    notifyListeners();
  }

  void editarMedicamento(
    Medicamento medicamento, {
    required String nombre,
    required Categoria categoria,
    required int stock,
    required int stockMinimo,
    String laboratorio = '',
  }) {
    medicamento
      ..nombre = nombre.trim()
      ..categoria = categoria
      ..stock = stock
      ..stockMinimo = stockMinimo
      ..laboratorio = laboratorio.trim();
    notifyListeners();
  }

  void eliminarMedicamento(Medicamento medicamento) {
    _medicamentos.remove(medicamento);
    notifyListeners();
  }

  bool dispensar(
    Medicamento medicamento, {
    required int cantidad,
    String responsable = '',
  }) {
    if (cantidad <= 0 || cantidad > medicamento.stock) {
      return false;
    }

    medicamento.stock -= cantidad;

    _movimientos.insert(
      0,
      Movimiento(
        id: _nuevoId(),
        medicamentoNombre: medicamento.nombre,
        cantidad: cantidad,
        tipo: TipoMovimiento.salida,
        fecha: DateTime.now(),
        responsable: responsable.trim(),
      ),
    );

    notifyListeners();
    return true;
  }

  void ingresarStock(
    Medicamento medicamento, {
    required int cantidad,
    String responsable = '',
  }) {
    if (cantidad <= 0) return;

    medicamento.stock += cantidad;

    _movimientos.insert(
      0,
      Movimiento(
        id: _nuevoId(),
        medicamentoNombre: medicamento.nombre,
        cantidad: cantidad,
        tipo: TipoMovimiento.ingreso,
        fecha: DateTime.now(),
        responsable: responsable.trim(),
      ),
    );

    notifyListeners();
  }

  String _nuevoId() => 'id_${_contadorId++}';

  void _cargarDatosIniciales() {
    final ejemplos = <Map<String, Object>>[
      {
        'n': 'Paracetamol 500mg',
        'c': Categoria.analgesico,
        's': 120,
        'm': 30,
        'l': 'Genfar'
      },
      {
        'n': 'Ibuprofeno 400mg',
        'c': Categoria.antiinflamatorio,
        's': 18,
        'm': 25,
        'l': 'Bayer'
      },
      {
        'n': 'Amoxicilina 500mg',
        'c': Categoria.antibiotico,
        's': 0,
        'm': 20,
        'l': 'MK'
      },
      {
        'n': 'Loratadina 10mg',
        'c': Categoria.antialergico,
        's': 64,
        'm': 15,
        'l': 'Genfar'
      },
      {
        'n': 'Omeprazol 20mg',
        'c': Categoria.gastrointestinal,
        's': 9,
        'm': 20,
        'l': 'Lafrancol'
      },
      {
        'n': 'Vitamina C 1g',
        'c': Categoria.vitamina,
        's': 200,
        'm': 40,
        'l': 'Redoxon'
      },
      {
        'n': 'Diclofenaco 50mg',
        'c': Categoria.antiinflamatorio,
        's': 45,
        'm': 20,
        'l': 'MK'
      },
      {
        'n': 'Azitromicina 500mg',
        'c': Categoria.antibiotico,
        's': 12,
        'm': 15,
        'l': 'Pfizer'
      },
    ];

    for (final e in ejemplos) {
      _medicamentos.add(
        Medicamento(
          id: _nuevoId(),
          nombre: e['n'] as String,
          categoria: e['c'] as Categoria,
          stock: e['s'] as int,
          stockMinimo: e['m'] as int,
          laboratorio: e['l'] as String,
        ),
      );
    }
  }
}

final inventarioStore = InventarioStore();
