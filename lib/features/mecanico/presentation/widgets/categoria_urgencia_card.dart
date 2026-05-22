import 'package:flutter/material.dart';

import '../../domain/models/urgencia.dart';

class CategoriaUrgenciaCard extends StatelessWidget {
  const CategoriaUrgenciaCard({
    super.key,
    required this.categoria,
    required this.seleccionada,
    required this.onSelected,
  });

  final String categoria;
  final Urgencia seleccionada;
  final ValueChanged<Urgencia> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE4E8EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            categoria,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: Urgencia.values.map((urgencia) {
              final selected = urgencia == seleccionada;
              return ChoiceChip(
                label: Text(urgencia.label),
                selected: selected,
                onSelected: (_) => onSelected(urgencia),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : urgencia.color,
                  fontWeight: FontWeight.w600,
                ),
                selectedColor: urgencia.color,
                backgroundColor: urgencia.color.withValues(alpha: 0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
