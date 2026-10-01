import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../modelos/producto.dart';
import '../proveedores/proveedor_carrito.dart';
import '../idioma/textos_app.dart';
import '../tema/colores_app.dart';
import '../widgets/texto_traducido.dart';
import '../utilidades/moneda.dart';

class PantallaDetalleProducto extends StatefulWidget {
  final Producto producto;
  final bool esFavorito;
  final VoidCallback alAlternarFavorito;

  const PantallaDetalleProducto({
    super.key,
    required this.producto,
    required this.esFavorito,
    required this.alAlternarFavorito,
  });

  @override
  State<PantallaDetalleProducto> createState() => _PantallaDetalleProductoState();
}

class _PantallaDetalleProductoState extends State<PantallaDetalleProducto> {
  bool _esFavorito = false;

  @override
  void initState() {
    super.initState();
    _esFavorito = widget.esFavorito;
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: Column(
          children: [
            _construirBarraSuperior(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _construirImagen(producto),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: TextoTraducido(producto.nombre, estilo: Theme.of(context).textTheme.displayMedium),
                        ),
                        if (!producto.disponible)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: ColoresApp.plateado, borderRadius: BorderRadius.circular(4)),
                            child: const Text('AGOTADO',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      formatearMxn(producto.precio),
                      style: const TextStyle(color: ColoresApp.lilaProfundo, fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _etiqueta(Icons.category_outlined, producto.categoria),
                        _etiqueta(Icons.diamond_outlined, producto.material),
                        if (producto.coleccion != null) _etiqueta(Icons.auto_awesome_outlined, producto.coleccion!),
                        if (producto.disponible)
                          _etiqueta(Icons.inventory_2_outlined, '${producto.existencias} disponibles'),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(context.traducir('detalles'), style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    TextoTraducido(producto.descripcion, estilo: Theme.of(context).textTheme.bodyLarge),
                    const SizedBox(height: 110),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _construirBarraInferior(context),
    );
  }

  Widget _etiqueta(IconData icono, String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: ColoresApp.tenue, borderRadius: BorderRadius.circular(20), border: Border.all(color: ColoresApp.borde)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icono, size: 13, color: ColoresApp.dorado),
          const SizedBox(width: 5),
          Text(texto, style: const TextStyle(color: ColoresApp.textoTenue, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _construirBarraSuperior(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _botonCircular(icono: Icons.arrow_back_ios_new_rounded, alTocar: () => Navigator.of(context).pop()),
          _botonCircular(icono: Icons.shopping_bag_outlined, alTocar: () {}),
        ],
      ),
    );
  }

  Widget _botonCircular({required IconData icono, required VoidCallback alTocar}) {
    return GestureDetector(
      onTap: alTocar,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(color: ColoresApp.tenue, shape: BoxShape.circle, border: Border.all(color: ColoresApp.borde)),
        child: Icon(icono, size: 18, color: ColoresApp.textoPrincipal),
      ),
    );
  }

  Widget _construirImagen(Producto producto) {
    return Container(
      height: 280,
      width: double.infinity,
      decoration: BoxDecoration(color: ColoresApp.tenue, borderRadius: BorderRadius.circular(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          producto.urlImagen,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) => const Center(child: Icon(Icons.diamond_outlined, color: ColoresApp.dorado, size: 60)),
        ),
      ),
    );
  }

  Widget _construirBarraInferior(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
      decoration: const BoxDecoration(color: ColoresApp.fondo, border: Border(top: BorderSide(color: ColoresApp.borde))),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                setState(() => _esFavorito = !_esFavorito);
                widget.alAlternarFavorito();
              },
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(color: ColoresApp.tenue, shape: BoxShape.circle, border: Border.all(color: ColoresApp.borde)),
                child: Icon(_esFavorito ? Icons.favorite : Icons.favorite_border, color: _esFavorito ? ColoresApp.dorado : ColoresApp.textoPrincipal),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: widget.producto.disponible
                    ? () {
                        context.read<ProveedorCarrito>().agregar(widget.producto);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: ColoresApp.lilaProfundo,
                            behavior: SnackBarBehavior.floating,
                            content: Text('${widget.producto.nombre} agregado al carrito', style: const TextStyle(color: Colors.white)),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                label: Text(widget.producto.disponible ? context.traducir('agregar_al_carrito') : 'Sin existencias'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}