import 'package:flutter/material.dart';
import '../tema/colores_app.dart';
import '../widgets/barra_navegacion.dart';
import 'pantalla_carrito.dart';
import 'pantalla_chatbot.dart';
import 'pantalla_favoritos.dart';
import 'pantalla_inicio.dart';
import 'pantalla_perfil.dart';

/// Contenedor principal con la navegación inferior. El estado de
/// favoritos/carrito/autenticación vive en Proveedores (ver
/// lib/proveedores/), así que este widget solo controla qué pestaña
/// se muestra.
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int _indiceActual = 0;

  static const _pantallas = [
    PantallaInicio(),
    PantallaChatbot(),
    PantallaFavoritos(),
    PantallaCarrito(),
    PantallaPerfil(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: IndexedStack(index: _indiceActual, children: _pantallas),
      bottomNavigationBar: BarraNavegacion(
        indiceActual: _indiceActual,
        alTocar: (indice) => setState(() => _indiceActual = indice),
      ),
    );
  }
}
