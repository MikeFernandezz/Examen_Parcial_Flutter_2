import 'package:flutter/material.dart';

import '../features/registro/presentation/pages/registro_vehiculo_page.dart';
import 'theme/app_theme.dart';

class AgenciaVehicularApp extends StatelessWidget {
  const AgenciaVehicularApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Agencia Vehicular',
      theme: AppTheme.build(),
      home: const RegistroVehiculoPage(),
    );
  }
}
