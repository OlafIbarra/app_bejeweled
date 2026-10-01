import 'package:flutter/material.dart';
import '../tema/colores_app.dart';

class ChipsCategoria extends StatelessWidget {
  final List<String> categorias;
  final String seleccionada;
  final ValueChanged<String> alSeleccionar;

  const ChipsCategoria({
    super.key,
    required this.categorias,
    required this.seleccionada,
    required this.alSeleccionar,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categorias.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          final estaSeleccionada = categoria == seleccionada;
          return GestureDetector(
            onTap: () => alSeleccionar(categoria),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: estaSeleccionada ? ColoresApp.lilaProfundo : ColoresApp.tenue,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                categoria,
                style: TextStyle(
                  color: estaSeleccionada ? Colors.white : ColoresApp.textoPrincipal,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
