import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colores_app.dart';

/// Tema centralizado de BEJEWELED — claro, elegante, lila + dorado,
/// tipografía Gilda Display (títulos) + Raleway (texto), igual que el
/// sistema de diseño del sitio web.
class TemaApp {
  TemaApp._();

  static TextTheme get _temaTexto {
    final base = ThemeData.light().textTheme;
    return GoogleFonts.ralewayTextTheme(base).copyWith(
      displayLarge: GoogleFonts.gildaDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        color: ColoresApp.textoPrincipal,
        letterSpacing: 0.3,
      ),
      displayMedium: GoogleFonts.gildaDisplay(
        fontSize: 25,
        fontWeight: FontWeight.w400,
        color: ColoresApp.textoPrincipal,
      ),
      headlineSmall: GoogleFonts.gildaDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w400,
        color: ColoresApp.textoPrincipal,
      ),
      titleLarge: GoogleFonts.raleway(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: ColoresApp.textoPrincipal,
      ),
      titleMedium: GoogleFonts.raleway(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: ColoresApp.textoPrincipal,
      ),
      bodyLarge: GoogleFonts.raleway(
        fontSize: 14,
        fontWeight: FontWeight.w300,
        color: ColoresApp.textoTenue,
        height: 1.5,
      ),
      bodyMedium: GoogleFonts.raleway(
        fontSize: 12,
        color: ColoresApp.textoTenue,
        height: 1.4,
      ),
      labelLarge: GoogleFonts.raleway(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.6,
      ),
    );
  }

  static ThemeData get temaClaro {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: ColoresApp.fondo,
      primaryColor: ColoresApp.primario,
      colorScheme: const ColorScheme.light(
        primary: ColoresApp.primario,
        secondary: ColoresApp.dorado,
        surface: ColoresApp.tarjeta,
        error: ColoresApp.peligro,
      ),
      textTheme: _temaTexto,
      appBarTheme: AppBarTheme(
        backgroundColor: ColoresApp.fondo,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: ColoresApp.textoPrincipal),
        titleTextStyle: GoogleFonts.gildaDisplay(
          fontSize: 19,
          fontWeight: FontWeight.w400,
          color: ColoresApp.textoPrincipal,
        ),
        surfaceTintColor: ColoresApp.fondo,
      ),
      dividerColor: ColoresApp.borde,
      iconTheme: const IconThemeData(color: ColoresApp.textoPrincipal),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColoresApp.lilaProfundo,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          textStyle: GoogleFonts.raleway(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: ColoresApp.primario,
          side: const BorderSide(color: ColoresApp.primario),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: ColoresApp.tenue,
        hintStyle: GoogleFonts.raleway(color: ColoresApp.textoTenue, fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: ColoresApp.primario),
        ),
      ),
      cardTheme: CardThemeData(
        color: ColoresApp.tarjeta,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
          side: const BorderSide(color: ColoresApp.borde),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: ColoresApp.tenue,
        selectedColor: ColoresApp.lilaProfundo,
        labelStyle: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: ColoresApp.textoPrincipal,
        ),
        secondaryLabelStyle: GoogleFonts.raleway(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide.none,
        ),
      ),
      splashColor: ColoresApp.primario.withOpacity(0.08),
      highlightColor: Colors.transparent,
    );
  }
}
