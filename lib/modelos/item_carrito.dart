import 'producto.dart';

class ItemCarrito {
  final Producto producto;
  final String? tallaSeleccionada;
  int cantidad;

  ItemCarrito({
    required this.producto,
    this.tallaSeleccionada,
    this.cantidad = 1,
  });

  double get subtotal => producto.precio * cantidad;

  /// Clave única para agrupar el mismo producto+talla en el carrito.
  String get clave => '${producto.id}_${tallaSeleccionada ?? ''}';
}
