import 'package:flutter/material.dart';
import '../modelos/producto.dart';
import '../tema/colores_app.dart';
import '../utilidades/moneda.dart';

class TarjetaProducto extends StatelessWidget {
  final Producto producto;
  final bool esFavorito;
  final VoidCallback alTocar;
  final VoidCallback alAlternarFavorito;

  const TarjetaProducto({
    super.key,
    required this.producto,
    required this.alTocar,
    required this.alAlternarFavorito,
    this.esFavorito = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: alTocar,
      child: Container(
        decoration: BoxDecoration(
          color: ColoresApp.tarjeta,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: ColoresApp.borde),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    child: SizedBox.expand(child: _ImagenProducto(url: producto.urlImagen)),
                  ),
                  if (producto.esNuevo)
                    _etiqueta('NUEVO', ColoresApp.primario)
                  else if (producto.destacado)
                    _etiqueta('DESTACADO', ColoresApp.dorado, arriba: producto.esNuevo ? 40 : 10),
                  if (!producto.disponible)
                    _etiqueta('AGOTADO', ColoresApp.plateado, arriba: 10, izquierda: null, derecha: 10),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: alAlternarFavorito,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
                        child: Icon(
                          esFavorito ? Icons.favorite : Icons.favorite_border,
                          size: 16,
                          color: esFavorito ? ColoresApp.dorado : ColoresApp.textoPrincipal,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    producto.material,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: ColoresApp.textoTenue, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    formatearMxn(producto.precio),
                    style: const TextStyle(
                      color: ColoresApp.lilaProfundo,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _etiqueta(String texto, Color color, {double arriba = 10, double? izquierda = 10, double? derecha}) {
    return Positioned(
      top: arriba,
      left: izquierda,
      right: derecha,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        child: Text(
          texto,
          style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: 0.6),
        ),
      ),
    );
  }
}

class _ImagenProducto extends StatelessWidget {
  final String url;
  const _ImagenProducto({required this.url});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progreso) {
        if (progreso == null) return child;
        return Container(
          color: ColoresApp.tenue,
          child: const Center(
            child: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: ColoresApp.primario),
            ),
          ),
        );
      },
      errorBuilder: (context, error, stack) => Container(
        color: ColoresApp.tenue,
        child: const Icon(Icons.diamond_outlined, color: ColoresApp.dorado, size: 32),
      ),
    );
  }
}
