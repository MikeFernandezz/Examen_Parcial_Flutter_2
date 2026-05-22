import 'package:flutter/material.dart';

enum Urgencia { baja, media, alta }

extension UrgenciaX on Urgencia {
  String get label {
    switch (this) {
      case Urgencia.baja:
        return 'Baja';
      case Urgencia.media:
        return 'Media';
      case Urgencia.alta:
        return 'Alta';
    }
  }

  Color get color {
    switch (this) {
      case Urgencia.baja:
        return const Color(0xFF2E7D32);
      case Urgencia.media:
        return const Color.fromARGB(255, 219, 219, 70);
      case Urgencia.alta:
        return const Color(0xFFD32F2F);
    }
  }

  IconData get icon {
    switch (this) {
      case Urgencia.baja:
        return Icons.check_circle_outline_sharp;
      case Urgencia.media:
        return Icons.warning_amber_rounded;
      case Urgencia.alta:
        return Icons.error_outline;
    }
  }
}
