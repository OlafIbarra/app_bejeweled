import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'proveedores/proveedor_autenticacion.dart';
import 'proveedores/proveedor_carrito.dart';
import 'proveedores/proveedor_favoritos.dart';
import 'proveedores/proveedor_idioma.dart';
import 'pantallas/puerta_autenticacion.dart';
import 'tema/tema_app.dart';


void main() {
  runApp(const AplicacionBejeweled());
}

class AplicacionBejeweled extends StatelessWidget {
  const AplicacionBejeweled({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProveedorAutenticacion()),
        ChangeNotifierProvider(create: (_) => ProveedorFavoritos()),
        ChangeNotifierProvider(create: (_) => ProveedorCarrito()),
        ChangeNotifierProvider(create: (_) => ProveedorIdioma()),
      ],
      child: MaterialApp(
        title: 'BEJEWELED',
        debugShowCheckedModeBanner: false,
        theme: TemaApp.temaClaro,
        home: const PuertaAutenticacion(),
      ),
    );
  }
}
