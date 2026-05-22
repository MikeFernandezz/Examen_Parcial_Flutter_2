import 'package:flutter/material.dart';

import '../../../registro/domain/models/registro_vehiculo_data.dart';

class ResumenCard extends StatelessWidget {
  const ResumenCard({super.key, required this.registro});

  final RegistroVehiculoData registro;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datos del registro',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ResumenItem(label: 'Vehiculo', value: registro.vehiculo),
          ResumenItem(label: 'Placas', value: registro.placas),
          ResumenItem(label: 'Asesor', value: registro.asesor),
          ResumenItem(label: 'Dueño', value: registro.duenio),
          ResumenItem(label: 'Costo estimado', value: registro.costoEstimado),
        ],
      ),
    );
  }
}

class ResumenItem extends StatelessWidget {
  const ResumenItem({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.black54),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
