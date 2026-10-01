import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import '../idioma/textos_app.dart';

/// Controla el idioma activo de la app (español/inglés) y traduce los
/// textos usando una API real de traducción (paquete `translator`,
/// que usa el motor gratuito de Google Translate — sin costo, sin
/// llave de API, ideal para un proyecto académico).
///
/// Cómo funciona:
/// 1. El texto base siempre vive en español (ver textos_app.dart).
/// 2. Al cambiar a inglés, se dispara una traducción en segundo plano
///    por cada texto de la interfaz.
/// 3. Mientras la traducción no ha llegado, se muestra el texto en
///    español como respaldo (para que la app nunca se vea en blanco).
/// 4. Cuando la traducción llega, se guarda en caché y se notifica a
///    la interfaz para que se redibuje ya en inglés.
class ProveedorIdioma extends ChangeNotifier {
  static const _clave = 'bejeweled_idioma';
  String _idioma = 'es'; // 'es' o 'en'

  final GoogleTranslator _traductor = GoogleTranslator();
  final Map<String, String> _cachePorClave = {};
  final Map<String, String> _cacheLibre = {};
  final Set<String> _pendientes = {};

  String get idioma => _idioma;
  bool get esEspanol => _idioma == 'es';

  /// true mientras haya al menos una traducción en camino (útil para
  /// mostrar un indicador de carga pequeño en la pantalla de Perfil).
  bool get hayTraduccionesPendientes => _pendientes.isNotEmpty;

  ProveedorIdioma() {
    _restaurar();
  }

  Future<void> _restaurar() async {
    final prefs = await SharedPreferences.getInstance();
    _idioma = prefs.getString(_clave) ?? 'es';
    notifyListeners();
    if (_idioma == 'en') _precargarTextosDeInterfaz();
  }

  Future<void> alternar() async {
    _idioma = _idioma == 'es' ? 'en' : 'es';
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_clave, _idioma);

    if (_idioma == 'en') _precargarTextosDeInterfaz();
  }

  /// Traduce de una vez todos los textos fijos de la interfaz
  /// (los que están en textos_app.dart), para que no se vayan
  /// traduciendo uno por uno según se van mostrando en pantalla.
  void _precargarTextosDeInterfaz() {
    for (final clave in TextosApp.todasLasClaves) {
      _traducirPorClave(clave, TextosApp.obtenerBase(clave));
    }
  }

  /// Usado por `context.traducir('clave')` en textos_app.dart.
  String obtenerTraduccion(String clave, String textoBase) {
    if (_cachePorClave.containsKey(clave)) return _cachePorClave[clave]!;
    _traducirPorClave(clave, textoBase);
    return textoBase;
  }

  /// De uso libre para texto dinámico que NO está en el diccionario
  /// fijo — por ejemplo, el nombre o la descripción de un producto.
  /// Ver ejemplo de uso en el widget TextoTraducido.
  String obtenerTraduccionLibre(String textoOriginal) {
    if (_cacheLibre.containsKey(textoOriginal)) return _cacheLibre[textoOriginal]!;
    _traducirLibre(textoOriginal);
    return textoOriginal;
  }

  Future<void> _traducirPorClave(String clave, String textoBase) async {
    if (_pendientes.contains('clave:$clave')) return;
    _pendientes.add('clave:$clave');
    try {
      final resultado = await _traductor.translate(textoBase, from: 'es', to: 'en');
      _cachePorClave[clave] = resultado.text;
      notifyListeners();
    } catch (_) {
      // Si falla la red, la app se queda mostrando el texto en
      // español — no se rompe la interfaz.
    } finally {
      _pendientes.remove('clave:$clave');
      notifyListeners();
    }
  }

  Future<void> _traducirLibre(String textoOriginal) async {
    if (_pendientes.contains('libre:$textoOriginal')) return;
    _pendientes.add('libre:$textoOriginal');
    try {
      final resultado = await _traductor.translate(textoOriginal, from: 'es', to: 'en');
      _cacheLibre[textoOriginal] = resultado.text;
      notifyListeners();
    } catch (_) {
      // Igual que arriba: se queda el texto original si falla.
    } finally {
      _pendientes.remove('libre:$textoOriginal');
      notifyListeners();
    }
  }
}