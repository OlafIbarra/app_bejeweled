/// Modelo de producto — espejo del modelo `Producto` de Django
/// (productos/models.py), para que cuando se conecte la API real el
/// mapeo sea directo campo por campo.
class Producto {
  final String id;
  final String nombre;
  final String categoria; // Categoria.nombre
  final String material; // Material.nombre
  final String? coleccion; // Coleccion.nombre (puede no tener)
  final String colorColeccion; // Coleccion.color_acento (hex)
  final double precio; // MXN, como Producto.precio
  final int existencias; // Producto.existencias
  final String urlImagen;
  final String descripcion;
  final bool destacado;
  final bool esNuevo;
  final bool activo;

  const Producto({
    required this.id,
    required this.nombre,
    required this.categoria,
    required this.material,
    this.coleccion,
    this.colorColeccion = '#8A74A8',
    required this.precio,
    required this.existencias,
    required this.urlImagen,
    required this.descripcion,
    this.destacado = false,
    this.esNuevo = false,
    this.activo = true,
  });

  /// Espejo de la propiedad `disponible` del modelo Django.
  bool get disponible => activo && existencias > 0;

  /// Texto combinado usado para búsqueda y para el asistente virtual.
  String get indiceBusqueda =>
      '$nombre $categoria $material ${coleccion ?? ''} $descripcion'.toLowerCase();
}
