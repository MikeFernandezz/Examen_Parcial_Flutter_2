import 'package:flutter/material.dart';

import '../../../../shared/widgets/header_card.dart';
import '../../../mecanico/presentation/pages/mecanico_page.dart';
import '../../domain/models/registro_vehiculo_data.dart';

class RegistroVehiculoPage extends StatefulWidget {
  const RegistroVehiculoPage({super.key});

  @override
  State<RegistroVehiculoPage> createState() => _RegistroVehiculoPageState();
}

class _RegistroVehiculoPageState extends State<RegistroVehiculoPage> {
  final _formKey = GlobalKey<FormState>();
  final _vehiculoController = TextEditingController();
  final _placasController = TextEditingController();
  final _asesorController = TextEditingController();
  final _duenioController = TextEditingController();
  final _costoController = TextEditingController();

  @override
  void dispose() {
    _vehiculoController.dispose();
    _placasController.dispose();
    _asesorController.dispose();
    _duenioController.dispose();
    _costoController.dispose();
    super.dispose();
  }

  void _continuar() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final data = RegistroVehiculoData(
      vehiculo: _vehiculoController.text.trim(),
      placas: _placasController.text.trim(),
      asesor: _asesorController.text.trim(),
      duenio: _duenioController.text.trim(),
      costoEstimado: _costoController.text.trim(),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MecanicoPage(registro: data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const HeaderCard(
              title: 'Registro de vehiculo',
              subtitle: 'Captura la informacion inicial del servicio.',
              icon: Icons.directions_car_filled,
            ),
            const SizedBox(height: 18),
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildInput(
                        controller: _vehiculoController,
                        label: 'Vehiculo',
                        hint: 'Marca y modelo',
                        icon: Icons.directions_car,
                      ),
                      const SizedBox(height: 14),
                      _buildInput(
                        controller: _placasController,
                        label: 'Placas',
                        hint: 'ABC-123',
                        icon: Icons.credit_card,
                      ),
                      const SizedBox(height: 14),
                      _buildInput(
                        controller: _asesorController,
                        label: 'Asesor',
                        hint: 'Nombre del asesor',
                        icon: Icons.support_agent,
                      ),
                      const SizedBox(height: 14),
                      _buildInput(
                        controller: _duenioController,
                        label: 'Dueño',
                        hint: 'Nombre del propietario',
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 14),
                      _buildInput(
                        controller: _costoController,
                        label: 'Costo estimado',
                        hint: r'Ej. $12,000',
                        icon: Icons.attach_money,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _continuar,
                          child: const Text('Continuar a mecanico'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Este campo es obligatorio';
        }
        return null;
      },
    );
  }
}
