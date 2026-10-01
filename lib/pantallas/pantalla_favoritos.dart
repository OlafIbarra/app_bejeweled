import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos/datos_productos.dart';
import '../proveedores/proveedor_favoritos.dart';
import '../idioma/textos_app.dart';
import '../tema/colores_app.dart';
import '../widgets/tarjeta_producto.dart';
import 'pantalla_detalle_producto.dart';

class PantallaFavoritos extends StatelessWidget {
  const PantallaFavoritos({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritos = context.watch<ProveedorFavoritos>();
    final productosFavoritos = DatosProductos.productos.where((p) => favoritos.esFavorito(p.id)).toList();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.traducir('titulo_favoritos'), style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 18),
            Expanded(
              child: productosFavoritos.isEmpty
                  ? _construirEstadoVacio(context)
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.66,
                      ),
                      itemCount: productosFavoritos.length,
                      itemBuilder: (context, index) {
                        final producto = productosFavoritos[index];
                        return TarjetaProducto(
                          producto: producto,
                          esFavorito: true,
                          alAlternarFavorito: () => favoritos.alternar(producto.id),
                          alTocar: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PantallaDetalleProducto(
                                  producto: producto,
                                  esFavorito: true,
                                  alAlternarFavorito: () => favoritos.alternar(producto.id),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _construirEstadoVacio(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite_border, size: 56, color: ColoresApp.textoTenue),
          const SizedBox(height: 12),
          Text(context.traducir('favoritos_vacio'), style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
