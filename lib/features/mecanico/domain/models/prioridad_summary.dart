import 'urgencia.dart';

class PrioridadSummary {
  const PrioridadSummary({
    required this.alta,
    required this.media,
    required this.baja,
    required this.general,
  });

  final int alta;
  final int media;
  final int baja;
  final Urgencia general;
}
