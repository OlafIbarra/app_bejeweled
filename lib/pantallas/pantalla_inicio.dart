import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../datos/datos_productos.dart';
import '../modelos/producto.dart';
import '../proveedores/proveedor_favoritos.dart';
import '../idioma/textos_app.dart';
import '../tema/colores_app.dart';
import '../widgets/chips_categoria.dart';
import '../widgets/tarjeta_producto.dart';
import '../widgets/banner_promocional.dart';
import 'pantalla_detalle_producto.dart';

class PantallaInicio extends StatefulWidget {
  const PantallaInicio({super.key});

  @override
  State<PantallaInicio> createState() => _PantallaInicioState();
}

class _PantallaInicioState extends State<PantallaInicio> {
  String _categoriaSeleccionada = 'Todo';
  String _coleccionSeleccionada = 'Todas';
  String _busqueda = '';
  bool _buscando = false;
  final _controladorBusqueda = TextEditingController();

  @override
  void dispose() {
    _controladorBusqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favoritos = context.watch<ProveedorFavoritos>();
    final productos = DatosProductos.filtrar(
      categoria: _categoriaSeleccionada,
      coleccion: _coleccionSeleccionada,
      busqueda: _busqueda,
    );

    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _construirEncabezado(context),
                  const SizedBox(height: 16),
                  if (_buscando) _construirCampoBusqueda() else const BannerPromocional(),
                  const SizedBox(height: 22),
                  ChipsCategoria(
                    categorias: DatosProductos.categorias,
                    seleccionada: _categoriaSeleccionada,
                    alSeleccionar: (c) => setState(() => _categoriaSeleccionada = c),
                  ),
                  const SizedBox(height: 12),
                  _construirFiltroColeccion(),
                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
          if (productos.isEmpty)
            SliverToBoxAdapter(child: _construirSinResultados(context))
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.66,
                ),
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final Producto producto = productos[index];
                    return TarjetaProducto(
                      producto: producto,
                      esFavorito: favoritos.esFavorito(producto.id),
                      alAlternarFavorito: () => favoritos.alternar(producto.id),
                      alTocar: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => PantallaDetalleProducto(
                              producto: producto,
                              esFavorito: favoritos.esFavorito(producto.id),
                              alAlternarFavorito: () => favoritos.alternar(producto.id),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  childCount: productos.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  Widget _construirEncabezado(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.traducir('bienvenida'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColoresApp.textoTenue),
              ),
              const SizedBox(height: 2),
              Text('BEJEWELED', style: Theme.of(context).textTheme.headlineSmall),
            ],
          ),
        ),
        _botonCircular(
          _buscando ? Icons.close : Icons.search,
          () => setState(() {
            _buscando = !_buscando;
            if (!_buscando) {
              _controladorBusqueda.clear();
              _busqueda = '';
            }
          }),
        ),
        const SizedBox(width: 10),
        _botonCircular(Icons.notifications_none_rounded, () {}, mostrarPunto: true),
      ],
    );
  }

  Widget _construirCampoBusqueda() {
    return TextField(
      controller: _controladorBusqueda,
      autofocus: true,
      style: const TextStyle(color: ColoresApp.textoPrincipal),
      onChanged: (valor) => setState(() => _busqueda = valor),
      decoration: InputDecoration(
        hintText: context.traducir('buscar_placeholder'),
        prefixIcon: const Icon(Icons.search, color: ColoresApp.textoTenue),
      ),
    );
  }

  Widget _construirFiltroColeccion() {
    return SizedBox(
      height: 34,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: DatosProductos.opcionesFiltroColeccion.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final coleccion = DatosProductos.opcionesFiltroColeccion[index];
          final estaSeleccionada = coleccion == _coleccionSeleccionada;
          return GestureDetector(
            onTap: () => setState(() => _coleccionSeleccionada = coleccion),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: estaSeleccionada ? ColoresApp.dorado : ColoresApp.borde),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                coleccion,
                style: TextStyle(
                  fontSize: 12,
                  color: estaSeleccionada ? ColoresApp.doradoOscuro : ColoresApp.textoTenue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _construirSinResultados(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.search_off_rounded, size: 48, color: ColoresApp.textoTenue),
            const SizedBox(height: 10),
            Text(context.traducir('sin_resultados'), style: Theme.of(context).textTheme.bodyLarge),
          ],
        ),
      ),
    );
  }

  Widget _botonCircular(IconData icono, VoidCallback alTocar, {bool mostrarPunto = false}) {
    return GestureDetector(
      onTap: alTocar,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: ColoresApp.tenue, shape: BoxShape.circle, border: Border.all(color: ColoresApp.borde)),
            child: Icon(icono, size: 20, color: ColoresApp.textoPrincipal),
          ),
          if (mostrarPunto)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(color: ColoresApp.dorado, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}
