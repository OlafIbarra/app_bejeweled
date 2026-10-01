import '../modelos/producto.dart';

/// Catálogo de ejemplo — portado 1:1 desde el comando `poblar_bd.py`
/// del backend Django, para que la demo de la app y la demo web
/// muestren exactamente los mismos productos, precios (MXN) y
/// colecciones. Cuando se conecte la API real, este archivo se
/// reemplaza por un servicio que haga `GET` a Django.
class DatosProductos {
  DatosProductos._();

  static const List<String> categorias = [
    'Todo',
    'Anillos',
    'Collares',
    'Pulseras',
    'Aretes',
    'Dijes',
  ];

  static const List<String> materiales = [
    'Oro 18k',
    'Oro 14k',
    'Oro blanco',
    'Plata 925',
    'Acero inoxidable',
    'Chapa de oro',
  ];

  /// (nombre, color de acento) — igual que Coleccion en Django.
  static const Map<String, String> colecciones = {
    'Colección Dorada': '#C9A84C',
    'Elegancia en Plata': '#A8AAAD',
    'Regalos Especiales': '#8A74A8',
    'Novias 2026': '#E8D28A',
  };

  static const List<String> opcionesFiltroColeccion = [
    'Todas',
    'Colección Dorada',
    'Elegancia en Plata',
    'Regalos Especiales',
    'Novias 2026',
  ];

  static const List<Producto> productos = [
    Producto(
      id: 'p1',
      nombre: 'Anillo Solitario Lumière',
      categoria: 'Anillos',
      material: 'Oro blanco',
      coleccion: 'Novias 2026',
      colorColeccion: '#E8D28A',
      precio: 14900.00,
      existencias: 4,
      destacado: true,
      urlImagen: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=800&q=80',
      descripcion:
          'Anillo solitario en oro blanco de 18k con diamante de talla brillante. '
          'El clásico absoluto para una pedida de mano.',
    ),
    Producto(
      id: 'p2',
      nombre: 'Anillo Trenzado Vienne',
      categoria: 'Anillos',
      material: 'Plata 925',
      coleccion: 'Elegancia en Plata',
      colorColeccion: '#A8AAAD',
      precio: 890.00,
      existencias: 24,
      esNuevo: true,
      urlImagen: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800&q=80',
      descripcion:
          'Anillo de plata 925 con diseño trenzado a mano. Ligero y cómodo '
          'para uso diario.',
    ),
    Producto(
      id: 'p3',
      nombre: 'Anillo Eternity Dorado',
      categoria: 'Anillos',
      material: 'Oro 18k',
      coleccion: 'Colección Dorada',
      colorColeccion: '#C9A84C',
      precio: 9800.00,
      existencias: 6,
      destacado: true,
      urlImagen: 'https://images.unsplash.com/photo-1602751584547-6d181d3d1c14?w=800&q=80',
      descripcion:
          'Banda completa de oro 18k con circonias engastadas en todo el '
          'contorno.',
    ),
    Producto(
      id: 'p4',
      nombre: 'Anillo Sello Clásico',
      categoria: 'Anillos',
      material: 'Oro 14k',
      coleccion: 'Colección Dorada',
      colorColeccion: '#C9A84C',
      precio: 5400.00,
      existencias: 9,
      urlImagen: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&q=80',
      descripcion: 'Anillo tipo sello en oro 14k, disponible para grabado personalizado.',
    ),
    Producto(
      id: 'p5',
      nombre: 'Anillo Minimal Acero',
      categoria: 'Anillos',
      material: 'Acero inoxidable',
      precio: 390.00,
      existencias: 45,
      esNuevo: true,
      urlImagen: 'https://images.unsplash.com/photo-1611955167811-4711904bb9f8?w=800&q=80',
      descripcion: 'Anillo delgado de acero inoxidable, resistente al agua y al uso diario.',
    ),
    Producto(
      id: 'p6',
      nombre: 'Collar Cadena Veneciana',
      categoria: 'Collares',
      material: 'Oro 14k',
      coleccion: 'Colección Dorada',
      colorColeccion: '#C9A84C',
      precio: 6200.00,
      existencias: 10,
      destacado: true,
      urlImagen: 'https://images.unsplash.com/photo-1617038220319-276d3cfab638?w=800&q=80',
      descripcion:
          'Collar de oro 14k con tejido veneciano de 45 cm. Ligero, firme y '
          'elegante.',
    ),
    Producto(
      id: 'p7',
      nombre: 'Gargantilla Minimalista',
      categoria: 'Collares',
      material: 'Plata 925',
      coleccion: 'Elegancia en Plata',
      colorColeccion: '#A8AAAD',
      precio: 1150.00,
      existencias: 18,
      esNuevo: true,
      urlImagen: 'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=800&q=80',
      descripcion:
          'Gargantilla de plata 925 con dije circular. Perfecta para combinar '
          'en capas.',
    ),
    Producto(
      id: 'p8',
      nombre: 'Collar Eternal Rose',
      categoria: 'Collares',
      material: 'Oro 18k',
      coleccion: 'Regalos Especiales',
      colorColeccion: '#8A74A8',
      precio: 12850.00,
      existencias: 3,
      destacado: true,
      urlImagen: 'https://images.unsplash.com/photo-1596944924616-7b38e7cfac36?w=800&q=80',
      descripcion:
          'Collar de oro 18k con dije en forma de rosa y rubí central. Pieza '
          'de edición limitada.',
    ),
    Producto(
      id: 'p9',
      nombre: 'Collar Perla Solitaria',
      categoria: 'Collares',
      material: 'Oro blanco',
      coleccion: 'Novias 2026',
      colorColeccion: '#E8D28A',
      precio: 4600.00,
      existencias: 7,
      urlImagen: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=800&q=80',
      descripcion:
          'Perla cultivada de agua dulce montada en cadena de oro blanco de '
          '42 cm.',
    ),
    Producto(
      id: 'p10',
      nombre: 'Collar Capas Doradas',
      categoria: 'Collares',
      material: 'Chapa de oro',
      precio: 760.00,
      existencias: 0,
      urlImagen: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800&q=80',
      descripcion:
          'Set de tres cadenas de distinto largo en chapa de oro, listas para '
          'usar en capas.',
    ),
    Producto(
      id: 'p11',
      nombre: 'Pulsera Tenis Céleste',
      categoria: 'Pulseras',
      material: 'Oro blanco',
      coleccion: 'Novias 2026',
      colorColeccion: '#E8D28A',
      precio: 18400.00,
      existencias: 2,
      destacado: true,
      urlImagen: 'https://images.unsplash.com/photo-1602751584547-6d181d3d1c14?w=800&q=80',
      descripcion:
          'Pulsera tenis en oro blanco con circonias de corte brillante y '
          'broche de seguridad doble.',
    ),
    Producto(
      id: 'p12',
      nombre: 'Pulsera de Eslabones',
      categoria: 'Pulseras',
      material: 'Acero inoxidable',
      precio: 650.00,
      existencias: 32,
      urlImagen: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&q=80',
      descripcion: 'Pulsera de acero inoxidable resistente al agua, con broche de seguridad.',
    ),
    Producto(
      id: 'p13',
      nombre: 'Pulsera Soleil',
      categoria: 'Pulseras',
      material: 'Oro 18k',
      coleccion: 'Colección Dorada',
      colorColeccion: '#C9A84C',
      precio: 7980.00,
      existencias: 5,
      esNuevo: true,
      urlImagen: 'https://images.unsplash.com/photo-1611955167811-4711904bb9f8?w=800&q=80',
      descripcion:
          'Pulsera de oro 18k con zafiro central engastado. Ajustable de 16 a '
          '19 cm.',
    ),
    Producto(
      id: 'p14',
      nombre: 'Esclava Grabable',
      categoria: 'Pulseras',
      material: 'Plata 925',
      coleccion: 'Regalos Especiales',
      colorColeccion: '#8A74A8',
      precio: 1390.00,
      existencias: 14,
      urlImagen: 'https://images.unsplash.com/photo-1617038220319-276d3cfab638?w=800&q=80',
      descripcion:
          'Esclava de plata 925 con placa lisa lista para grabar nombre o '
          'fecha.',
    ),
    Producto(
      id: 'p15',
      nombre: 'Pulsera Hilo Rojo',
      categoria: 'Pulseras',
      material: 'Chapa de oro',
      coleccion: 'Regalos Especiales',
      colorColeccion: '#8A74A8',
      precio: 290.00,
      existencias: 60,
      esNuevo: true,
      urlImagen: 'https://images.unsplash.com/photo-1573408301185-9146fe634ad0?w=800&q=80',
      descripcion:
          'Hilo rojo tejido con dije en chapa de oro. Un detalle pequeño y '
          'significativo.',
    ),
    Producto(
      id: 'p16',
      nombre: 'Aretes Argolla Pequeños',
      categoria: 'Aretes',
      material: 'Chapa de oro',
      precio: 420.00,
      existencias: 48,
      urlImagen: 'https://images.unsplash.com/photo-1596944924616-7b38e7cfac36?w=800&q=80',
      descripcion: 'Argollas de 15 mm en chapa de oro. Ligeras y cómodas para todo el día.',
    ),
    Producto(
      id: 'p17',
      nombre: 'Aretes Broquel Perla',
      categoria: 'Aretes',
      material: 'Plata 925',
      coleccion: 'Elegancia en Plata',
      colorColeccion: '#A8AAAD',
      precio: 980.00,
      existencias: 16,
      urlImagen: 'https://images.unsplash.com/photo-1611591437281-460bfbe1220a?w=800&q=80',
      descripcion: 'Broqueles de plata 925 con perla cultivada de agua dulce de 7 mm.',
    ),
    Producto(
      id: 'p18',
      nombre: 'Aretes Céleste Aguamarina',
      categoria: 'Aretes',
      material: 'Plata 925',
      coleccion: 'Elegancia en Plata',
      colorColeccion: '#A8AAAD',
      precio: 1120.00,
      existencias: 11,
      destacado: true,
      esNuevo: true,
      urlImagen: 'https://images.unsplash.com/photo-1515562141207-7a88fb7ce338?w=800&q=80',
      descripcion: 'Aretes de plata 925 con aguamarina de talla gota. Cierre de presión seguro.',
    ),
    Producto(
      id: 'p19',
      nombre: 'Dije Corazón Grabable',
      categoria: 'Dijes',
      material: 'Plata 925',
      coleccion: 'Regalos Especiales',
      colorColeccion: '#8A74A8',
      precio: 560.00,
      existencias: 28,
      urlImagen: 'https://images.unsplash.com/photo-1602751584547-6d181d3d1c14?w=800&q=80',
      descripcion: 'Dije de plata en forma de corazón, disponible para grabado personalizado.',
    ),
    Producto(
      id: 'p20',
      nombre: 'Dije Inicial Oro',
      categoria: 'Dijes',
      material: 'Oro 14k',
      coleccion: 'Regalos Especiales',
      colorColeccion: '#8A74A8',
      precio: 2300.00,
      existencias: 0,
      urlImagen: 'https://images.unsplash.com/photo-1599643478518-a784e5dc4c8f?w=800&q=80',
      descripcion: 'Dije con letra inicial en oro 14k. Se vende por pieza, cadena no incluida.',
    ),
  ];

  static List<Producto> filtrar({
    String categoria = 'Todo',
    String coleccion = 'Todas',
    String busqueda = '',
  }) {
    return productos.where((p) {
      final coincideCategoria = categoria == 'Todo' || p.categoria == categoria;
      final coincideColeccion = coleccion == 'Todas' || p.coleccion == coleccion;
      final coincideBusqueda =
          busqueda.trim().isEmpty || p.indiceBusqueda.contains(busqueda.toLowerCase());
      return coincideCategoria && coincideColeccion && coincideBusqueda;
    }).toList();
  }
}
