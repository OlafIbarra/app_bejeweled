import 'package:flutter/material.dart';

class ProveedorFavoritos extends ChangeNotifier {
  final Set<String> _idsFavoritos = {};

  Set<String> get idsFavoritos => _idsFavoritos;

  bool esFavorito(String idProducto) => _idsFavoritos.contains(idProducto);

  void alternar(String idProducto) {
    if (_idsFavoritos.contains(idProducto)) {
      _idsFavoritos.remove(idProducto);
    } else {
      _idsFavoritos.add(idProducto);
    }
    notifyListeners();
  }
}
