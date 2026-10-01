import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedores/proveedor_autenticacion.dart';
import '../tema/colores_app.dart';
import 'pantalla_login.dart';
import 'pantalla_principal.dart';

class PuertaAutenticacion extends StatelessWidget {
  const PuertaAutenticacion({super.key});

  @override
  Widget build(BuildContext context) {
    final autenticacion = context.watch<ProveedorAutenticacion>();

    if (autenticacion.cargando) {
      return const Scaffold(
        backgroundColor: ColoresApp.fondo,
        body: Center(child: CircularProgressIndicator(color: ColoresApp.lilaProfundo)),
      );
    }

    return autenticacion.sesionIniciada ? const PantallaPrincipal() : const PantallaLogin();
  }
}
