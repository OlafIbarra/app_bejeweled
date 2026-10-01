/// Formatea un precio en pesos mexicanos, ej. 14900.0 -> "$14,900.00".
/// Se escribe a mano (sin el paquete `intl`) para mantener el proyecto
/// ligero; si más adelante agregan `intl` para fechas, pueden migrar
/// esto a `NumberFormat.currency(locale: 'es_MX')`.
String formatearMxn(double monto) {
  final esNegativo = monto < 0;
  final fijo = monto.abs().toStringAsFixed(2);
  final partes = fijo.split('.');
  final parteEntera = partes[0];
  final parteDecimal = partes[1];

  final buffer = StringBuffer();
  for (int i = 0; i < parteEntera.length; i++) {
    final posicionDesdeElFinal = parteEntera.length - i;
    buffer.write(parteEntera[i]);
    if (posicionDesdeElFinal > 1 && posicionDesdeElFinal % 3 == 1) {
      buffer.write(',');
    }
  }

  return '${esNegativo ? '-' : ''}\$${buffer.toString()}.$parteDecimal';
}
