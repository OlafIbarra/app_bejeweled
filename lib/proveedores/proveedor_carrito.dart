import 'package:flutter/material.dart';
import '../modelos/item_carrito.dart';
import '../modelos/producto.dart';

class ProveedorCarrito extends ChangeNotifier {
  final Map<String, ItemCarrito> _items = {};

  List<ItemCarrito> get items => _items.values.toList();
  int get cantidadItems => _items.values.fold(0, (suma, item) => suma + item.cantidad);
  double get total => _items.values.fold(0, (suma, item) => suma + item.subtotal);
  bool get estaVacio => _items.isEmpty;

  void agregar(Producto producto, {String? talla, int cantidad = 1}) {
    final clave = '${producto.id}_${talla ?? ''}';
    if (_items.containsKey(clave)) {
      _items[clave]!.cantidad += cantidad;
    } else {
      _items[clave] = ItemCarrito(producto: producto, tallaSeleccionada: talla, cantidad: cantidad);
    }
    notifyListeners();
  }

  void actualizarCantidad(String clave, int cantidad) {
    if (cantidad <= 0) {
      _items.remove(clave);
    } else if (_items.containsKey(clave)) {
      _items[clave]!.cantidad = cantidad;
    }
    notifyListeners();
  }

  void eliminar(String clave) {
    _items.remove(clave);
    notifyListeners();
  }

  void vaciar() {
    _items.clear();
    notifyListeners();
  }
}
