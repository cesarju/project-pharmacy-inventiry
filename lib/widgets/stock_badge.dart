import 'package:flutter/material.dart';

import '../models/medicamento.dart';

class StockBadge extends StatelessWidget {
  const StockBadge({super.key, required this.estado});

  final EstadoStock estado;

  @override
  Widget build(BuildContext context) {
    final (texto, color, icono) = switch (estado) {
      EstadoStock.disponible => (
          'Disponible',
          const Color(0xFF1D9E75),
          Icons.check_circle
        ),
      EstadoStock.bajo => (
          'Stock bajo',
          const Color(0xFFBA7517),
          Icons.warning_amber_rounded
        ),
      EstadoStock.agotado => ('Agotado', const Color(0xFFA32D2D), Icons.cancel),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            texto,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
