import 'package:flutter/material.dart';

class EntregaSummary {
  const EntregaSummary({
    required this.reparacion,
    required this.fechaSalida,
    required this.horaSalida,
  });

  final int reparacion;
  final DateTime fechaSalida;
  final TimeOfDay horaSalida;
}