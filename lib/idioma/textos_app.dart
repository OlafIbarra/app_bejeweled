import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedores/proveedor_idioma.dart';

/// Textos de la interfaz en español — la única fuente de verdad.
/// Cuando el idioma activo es inglés, ProveedorIdioma traduce estos
/// mismos textos en tiempo real usando la API de traducción (ver
/// proveedor_idioma.dart), en vez de un diccionario escrito a mano.
class TextosApp {
  TextosApp._();

  static const Map<String, String> _valoresBase = {
    'bienvenida': 'Bienvenida de vuelta',
    'buscar_placeholder': 'Buscar joyas, materiales, colecciones...',
    'notificaciones': 'Notificaciones',
    'agregar_al_carrito': 'Agregar al carrito',
    'detalles': 'Detalles',
    'iniciar_sesion': 'Iniciar sesión',
    'crear_cuenta': 'Crear cuenta',
    'cerrar_sesion': 'Cerrar sesión',
    'sin_resultados': 'No encontramos joyas con esos filtros',
    'favoritos_vacio': 'Aún no tienes favoritos',
    'carrito_vacio': 'Tu carrito está vacío',
    'total': 'Total',
    'ir_a_pagar': 'Ir a pagar',
    'idioma': 'Idioma',
    'titulo_favoritos': 'Favoritos',
    'titulo_carrito': 'Carrito',
    'titulo_perfil': 'Perfil',
  };

  /// Todas las claves registradas — se usa para pre-traducirlas todas
  /// de un jalón cuando el usuario cambia a inglés.
  static Iterable<String> get todasLasClaves => _valoresBase.keys;

  static String obtenerBase(String clave) => _valoresBase[clave] ?? clave;
}

extension ExtensionTraduccion on BuildContext {
  /// Uso: `Text(context.traducir('bienvenida'))`.
  /// Si el idioma es español, regresa el texto base al instante.
  /// Si es inglés, regresa la traducción ya obtenida de la API (o,
  /// mientras llega la respuesta, el texto en español como respaldo).
  String traducir(String clave) {
    final proveedorIdioma = watch<ProveedorIdioma>();
    final textoBase = TextosApp.obtenerBase(clave);
    if (proveedorIdioma.esEspanol) return textoBase;
    return proveedorIdioma.obtenerTraduccion(clave, textoBase);
  }
}