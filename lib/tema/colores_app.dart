import 'package:flutter/material.dart';

/// Paleta de marca BEJEWELED — tomada directamente del sistema de
/// diseño del sitio web (static/css/style.css) para que la app y la
/// web se vean como una sola marca.
class ColoresApp {
  ColoresApp._();

  // Base
  static const Color fondo = Color(0xFFFDFBFF);
  static const Color textoPrincipal = Color(0xFF1E1728);
  static const Color tarjeta = Color(0xFFFAF8FC);
  static const Color textoTarjeta = Color(0xFF1E1728);

  // Lila (color primario de la marca)
  static const Color primario = Color(0xFF8A74A8);
  static const Color textoSobrePrimario = Color(0xFFFFFFFF);
  static const Color lilaProfundo = Color(0xFF6B5487);
  static const Color lilaSuave = Color(0xFFD4C6E8);
  static const Color lilaPalido = Color(0xFFF0EAF8);

  // Secundarios / neutros
  static const Color secundario = Color(0xFFEDE7F6);
  static const Color textoSecundario = Color(0xFF3D2F55);
  static const Color tenue = Color(0xFFF3EEF8);
  static const Color textoTenue = Color(0xFF7C6A94);
  static const Color borde = Color(0xFFE4D9F0);

  // Dorado (acento)
  static const Color dorado = Color(0xFFC9A84C);
  static const Color doradoClaro = Color(0xFFE8D28A);
  static const Color doradoOscuro = Color(0xFFB8942E);

  static const Color plateado = Color(0xFFA8AAAD);
  static const Color beige = Color(0xFFF5F0E8);

  // Estados
  static const Color peligro = Color(0xFFB3261E);
  static const Color exito = Color(0xFF2E7D32);

  static const LinearGradient degradadoDorado = LinearGradient(
    colors: [doradoOscuro, dorado, doradoClaro],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient superposicionHero = LinearGradient(
    colors: [Color(0xE6231B33), Color(0x99231B33), Color(0x1F231B33)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
