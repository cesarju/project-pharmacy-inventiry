/// Tipo de movimiento que afecta al inventario.
enum TipoMovimiento {
  salida('Dispensación'),
  ingreso('Ingreso de stock');

  const TipoMovimiento(this.label);
  final String label;
}

/// Registra un cambio en el stock de un medicamento (salida o ingreso).
///
/// Sirve para construir el historial de movimientos en memoria.
class Movimiento {
  Movimiento({
    required this.id,
    required this.medicamentoNombre,
    required this.cantidad,
    required this.tipo,
    required this.fecha,
    this.responsable = '',
  });

  final String id;
  final String medicamentoNombre;
  final int cantidad;
  final TipoMovimiento tipo;
  final DateTime fecha;
  final String responsable;
}
