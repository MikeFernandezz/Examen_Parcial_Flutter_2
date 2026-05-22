import 'package:flutter/material.dart';

import '../../../../shared/widgets/header_card.dart';
import '../../../registro/domain/models/registro_vehiculo_data.dart';
import '../../domain/models/prioridad_summary.dart';
import '../../domain/models/urgencia.dart';
import '../widgets/categoria_urgencia_card.dart';
import '../widgets/info_chip.dart';
import '../widgets/resumen_card.dart';

class MecanicoPage extends StatefulWidget {
  const MecanicoPage({super.key, required this.registro});

  final RegistroVehiculoData registro;

  @override
  State<MecanicoPage> createState() => _MecanicoPageState();
}

class _MecanicoPageState extends State<MecanicoPage> {
  final _observacionesController = TextEditingController();
  final Map<String, Urgencia> _prioridades = {
    'Frenos': Urgencia.baja,
    'Aceite': Urgencia.baja,
    'Bateria': Urgencia.baja,
    'Llanta': Urgencia.baja,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mostrarRegistroPopup();
    });
  }

  @override
  void dispose() {
    _observacionesController.dispose();
    super.dispose();
  }

  void _mostrarModalPrioridad() {
    final summary = _calcularPrioridad();
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Prioridad general',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                      tooltip: 'Cerrar',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    InfoChip(label: 'Alta: ${summary.alta}'),
                    InfoChip(label: 'Media: ${summary.media}'),
                    InfoChip(label: 'Baja: ${summary.baja}'),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: summary.general.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(summary.general.icon, color: summary.general.color),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          summary.general.label,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: summary.general.color,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'La prioridad general se calcula por cantidad de urgencias en categorias.',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black54),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _mostrarRegistroPopup() async {
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resumen del vehiculo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                ResumenCard(registro: widget.registro),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Continuar'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  PrioridadSummary _calcularPrioridad() {
    int alta = 0;
    int media = 0;
    int baja = 0;

    for (final value in _prioridades.values) {
      switch (value) {
        case Urgencia.alta:
          alta++;
          break;
        case Urgencia.media:
          media++;
          break;
        case Urgencia.baja:
          baja++;
          break;
      }
    }

    Urgencia general;
    if (alta >= 2) {
      general = Urgencia.alta;
    } else if (alta == 1 || media >= 2) {
      general = Urgencia.media;
    } else {
      general = Urgencia.baja;
    }

    return PrioridadSummary(alta: alta, media: media, baja: baja, general: general);
  }

  void _guardarDiagnostico() {
    _mostrarModalPrioridad();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Diagnostico guardado.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final registro = widget.registro;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel del mecanico'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            HeaderCard(
              title: 'Orden de servicio',
              subtitle: '${registro.vehiculo} - ${registro.placas}',
              icon: Icons.build_circle,
            ),
            const SizedBox(height: 16),
            ResumenCard(registro: registro),
            const SizedBox(height: 16),
            Text(
              'Categorias de urgencia',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            ..._prioridades.entries.map((entry) {
              return CategoriaUrgenciaCard(
                categoria: entry.key,
                seleccionada: entry.value,
                onSelected: (urgencia) {
                  setState(() {
                    _prioridades[entry.key] = urgencia;
                  });
                },
              );
            }),
            const SizedBox(height: 12),
            Text(
              'Observaciones',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _observacionesController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Notas del mecanico sobre el diagnostico...',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _mostrarModalPrioridad,
                    icon: const Icon(Icons.assignment_turned_in_outlined),
                    label: const Text('Ver prioridad general'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _guardarDiagnostico,
                    icon: const Icon(Icons.save),
                    label: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
