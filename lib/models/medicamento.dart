import 'package:flutter/material.dart';

/// Categorias disponibles para clasificar los medicamentos.
/// Cada categoria tiene una etiqueta legible, un icono y un color.
enum Categoria {
  analgesico('Analgésico', Icons.healing, Color(0xFF1D9E75)),
  antibiotico('Antibiótico', Icons.coronavirus, Color(0xFF378ADD)),
  antiinflamatorio(
      'Antiinflamatorio', Icons.local_fire_department, Color(0xFFD85A30)),
  antialergico('Antialérgico', Icons.air, Color(0xFF7F77DD)),
  gastrointestinal('Gastrointestinal', Icons.restaurant, Color(0xFFBA7517)),
  vitamina('Vitamina', Icons.bolt, Color(0xFF639922)),
  otro('Otro', Icons.medication, Color(0xFF5F5E5A));

  const Categoria(this.label, this.icono, this.color);

  final String label;
  final IconData icono;
  final Color color;
}

/// Estado calculado del stock de un medicamento.
enum EstadoStock { disponible, bajo, agotado }

class Medicamento {
  Medicamento({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.stock,
    required this.stockMinimo,
    this.laboratorio = '',
  });

  final String id;
  String nombre;
  Categoria categoria;
  int stock;
  int stockMinimo;
  String laboratorio;

  bool get estaAgotado => stock <= 0;

  bool get tieneStockBajo => stock > 0 && stock <= stockMinimo;

  bool get estaDisponible => stock > stockMinimo;

  EstadoStock get estado {
    if (estaAgotado) return EstadoStock.agotado;
    if (tieneStockBajo) return EstadoStock.bajo;
    return EstadoStock.disponible;
  }
}
