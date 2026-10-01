import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedores/proveedor_carrito.dart';
import '../idioma/textos_app.dart';
import '../tema/colores_app.dart';
import '../utilidades/moneda.dart';
import 'pantalla_pago.dart';

class PantallaCarrito extends StatelessWidget {
  const PantallaCarrito({super.key});

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<ProveedorCarrito>();

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.traducir('titulo_carrito'), style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 18),
            Expanded(child: carrito.estaVacio ? _construirEstadoVacio(context) : _construirLista(carrito)),
            if (!carrito.estaVacio) _construirResumen(context, carrito),
          ],
        ),
      ),
    );
  }

  Widget _construirLista(ProveedorCarrito carrito) {
    return ListView.separated(
      itemCount: carrito.items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = carrito.items[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: ColoresApp.tarjeta, borderRadius: BorderRadius.circular(10), border: Border.all(color: ColoresApp.borde)),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  item.producto.urlImagen,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 64,
                    height: 64,
                    color: ColoresApp.tenue,
                    child: const Icon(Icons.diamond_outlined, color: ColoresApp.dorado),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.producto.nombre, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: ColoresApp.textoPrincipal, fontWeight: FontWeight.w600, fontSize: 14)),
                    if (item.tallaSeleccionada != null)
                      Text('Talla ${item.tallaSeleccionada}', style: const TextStyle(color: ColoresApp.textoTenue, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(formatearMxn(item.producto.precio),
                        style: const TextStyle(color: ColoresApp.lilaProfundo, fontWeight: FontWeight.w700, fontSize: 13)),
                  ],
                ),
              ),
              Row(
                children: [
                  _botonPaso(icono: Icons.remove, alTocar: () => carrito.actualizarCantidad(item.clave, item.cantidad - 1)),
                  SizedBox(
                    width: 28,
                    child: Text('${item.cantidad}', textAlign: TextAlign.center, style: const TextStyle(color: ColoresApp.textoPrincipal, fontSize: 14)),
                  ),
                  _botonPaso(icono: Icons.add, alTocar: () => carrito.actualizarCantidad(item.clave, item.cantidad + 1)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _botonPaso({required IconData icono, required VoidCallback alTocar}) {
    return GestureDetector(
      onTap: alTocar,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(color: ColoresApp.tenue, shape: BoxShape.circle, border: Border.all(color: ColoresApp.borde)),
        child: Icon(icono, size: 14, color: ColoresApp.textoPrincipal),
      ),
    );
  }

  Widget _construirResumen(BuildContext context, ProveedorCarrito carrito) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: ColoresApp.tarjeta, borderRadius: BorderRadius.circular(10), border: Border.all(color: ColoresApp.borde)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.traducir('total'), style: const TextStyle(color: ColoresApp.textoTenue)),
              Text(formatearMxn(carrito.total), style: const TextStyle(color: ColoresApp.lilaProfundo, fontSize: 20, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PantallaPago()));
              },
              child: Text(context.traducir('ir_a_pagar')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirEstadoVacio(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shopping_bag_outlined, size: 56, color: ColoresApp.textoTenue),
          const SizedBox(height: 12),
          Text(context.traducir('carrito_vacio'), style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
