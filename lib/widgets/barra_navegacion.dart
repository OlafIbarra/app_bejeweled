import 'package:flutter/material.dart';
import '../tema/colores_app.dart';

class BarraNavegacion extends StatelessWidget {
  final int indiceActual;
  final ValueChanged<int> alTocar;

  const BarraNavegacion({
    super.key,
    required this.indiceActual,
    required this.alTocar,
  });

  static const _iconos = [
    Icons.home_rounded,
    Icons.auto_awesome_rounded,
    Icons.favorite_rounded,
    Icons.shopping_bag_rounded,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
      child: Container(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: ColoresApp.borde),
          boxShadow: [
            BoxShadow(
              color: ColoresApp.textoPrincipal.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_iconos.length, (index) {
            final estaSeleccionado = index == indiceActual;
            return GestureDetector(
              onTap: () => alTocar(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: estaSeleccionado ? 48 : 44,
                height: estaSeleccionado ? 48 : 44,
                decoration: BoxDecoration(
                  color: estaSeleccionado ? ColoresApp.lilaProfundo : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconos[index],
                  color: estaSeleccionado ? Colors.white : ColoresApp.textoTenue,
                  size: 22,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
