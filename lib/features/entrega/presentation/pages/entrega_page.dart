import 'package:flutter/material.dart';

import '../../../../shared/widgets/header_card.dart';
import '../../../registro/domain/models/registro_vehiculo_data.dart';

class EntregaPage extends StatefulWidget {
  const EntregaPage({super.key, required this.registro});

  final RegistroVehiculoData registro;

  @override
  State<EntregaPage> createState() => _EntregaPageState();
}

class _EntregaPageState extends State<EntregaPage> {
  final _arreglosController = TextEditingController();
  final Map<String, bool> _checklist = {
    'Frenos': false,
    'Aceite': false,
    'Bateria': false,
    'Llanta': false,
  };
  DateTime? _fechaEntrega;
  TimeOfDay? _horaEntrega;

  @override
  void dispose() {
    _arreglosController.dispose();
    super.dispose();
  }

  Future<void> _seleccionarFecha() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      initialDate: _fechaEntrega ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 2),
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _fechaEntrega = selected;
    });
  }

  Future<void> _seleccionarHora() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _horaEntrega ?? TimeOfDay.now(),
    );

    if (selected == null) {
      return;
    }

    setState(() {
      _horaEntrega = selected;
    });
  }

  String _formatearFecha(DateTime? fecha) {
    if (fecha == null) {
      return 'Pendiente';
    }

    final day = fecha.day.toString().padLeft(2, '0');
    final month = fecha.month.toString().padLeft(2, '0');
    return '$day/$month/${fecha.year}';
  }

  String _formatearHora(TimeOfDay? hora) {
    if (hora == null) {
      return 'Pendiente';
    }

    final hour = hora.hour.toString().padLeft(2, '0');
    final minute = hora.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Entrega del vehiculo'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Detalle'),
              Tab(text: 'Resumen'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildDetalleTab(context),
            _buildResumenTab(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetalleTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Arreglos realizados',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _arreglosController,
          maxLines: 4,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            hintText: 'Describe los trabajos realizados por el mecanico...',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Checklist de reparaciones',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        _SectionCard(
          child: Column(
            children: _checklist.entries.map((entry) {
              return CheckboxListTile(
                value: entry.value,
                onChanged: (value) {
                  setState(() {
                    _checklist[entry.key] = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(entry.key),
                activeColor: Theme.of(context).colorScheme.primary,
                contentPadding: EdgeInsets.zero,
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Fecha y hora de entrega',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _PickerCard(
                label: 'Fecha de entrega',
                value: _formatearFecha(_fechaEntrega),
                icon: Icons.calendar_today,
                onTap: _seleccionarFecha,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PickerCard(
                label: 'Hora de entrega',
                value: _formatearHora(_horaEntrega),
                icon: Icons.access_time,
                onTap: _seleccionarHora,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResumenTab(BuildContext context) {
    final registro = widget.registro;
    final arreglos = _arreglosController.text.trim();
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        HeaderCard(
          title: 'Resumen de entrega',
          subtitle: '${registro.vehiculo} - ${registro.placas}',
          icon: Icons.assignment_turned_in,
        ),
        const SizedBox(height: 16),
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Datos del vehiculo',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _ResumenRow(label: 'Vehiculo', value: registro.vehiculo),
              _ResumenRow(label: 'Placas', value: registro.placas),
              _ResumenRow(label: 'Asesor', value: registro.asesor),
              _ResumenRow(label: 'Dueno', value: registro.duenio),
              _ResumenRow(label: 'Costo estimado', value: registro.costoEstimado),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Arreglos realizados',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Text(
                arreglos.isEmpty ? 'Sin notas registradas.' : arreglos,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Checklist de reparaciones',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _checklist.entries.map((entry) {
                  return _StatusChip(
                    label: entry.key,
                    isDone: entry.value,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Entrega programada',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              _ResumenRow(
                label: 'Fecha',
                value: _formatearFecha(_fechaEntrega),
              ),
              _ResumenRow(
                label: 'Hora',
                value: _formatearHora(_horaEntrega),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

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
      child: child,
    );
  }
}

class _ResumenRow extends StatelessWidget {
  const _ResumenRow({required this.label, required this.value});

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

class _PickerCard extends StatelessWidget {
  const _PickerCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE4E8EC)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.isDone});

  final String label;
  final bool isDone;

  @override
  Widget build(BuildContext context) {
    final color = isDone
        ? Theme.of(context).colorScheme.primary
        : const Color(0xFF9CA3AF);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
