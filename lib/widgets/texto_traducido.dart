import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedores/proveedor_idioma.dart';

/// Muestra un texto que se traduce automáticamente al inglés cuando
/// ese es el idioma activo, usando la API real de traducción. A
/// diferencia de `context.traducir('clave')` (para textos fijos de la
/// interfaz), este widget sirve para contenido que cambia según los
/// datos — por ejemplo, el nombre o la descripción de un producto.
///
/// Uso:
/// ```dart
/// TextoTraducido(producto.nombre, estilo: Theme.of(context).textTheme.titleLarge)
/// ```
class TextoTraducido extends StatelessWidget {
  final String textoOriginal;
  final TextStyle? estilo;
  final int? maxLineas;
  final TextOverflow? overflow;

  const TextoTraducido(
    this.textoOriginal, {
    super.key,
    this.estilo,
    this.maxLineas,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    final proveedorIdioma = context.watch<ProveedorIdioma>();
    final texto = proveedorIdioma.esEspanol
        ? textoOriginal
        : proveedorIdioma.obtenerTraduccionLibre(textoOriginal);

    return Text(texto, style: estilo, maxLines: maxLineas, overflow: overflow);
  }
}