import 'dart:convert';
import 'package:http/http.dart' as http;
import '../datos/datos_productos.dart';
import '../modelos/producto.dart';

/// Configuración de la API de Gemini (Google AI Studio).
///
/// ⚠️ Igual que con PayPal: en una app real de producción esta llamada
/// debería vivir en el backend, no en el celular. Aquí es aceptable
/// para la demo académica porque es la API gratuita (sin tarjeta), así
/// que el peor caso es que se agote la cuota diaria gratuita, no un
/// cobro real.
class ConfiguracionGemini {
  ConfiguracionGemini._();

  static const String apiKey =
      String.fromEnvironment('GEMINI_API_KEY');

  static const String modelo = 'gemini-3.5-flash-lite';

  static const String urlBase =
      'https://generativelanguage.googleapis.com/v1beta';

  static bool get hayApiKey => apiKey.isNotEmpty;
}

class RespuestaChatbot {
  final String texto;
  final List<Producto> productos;
  final bool deUsuario;

  const RespuestaChatbot({
    required this.texto,
    this.productos = const [],
    this.deUsuario = false,
  });
}

/// Asistente virtual de BEJEWELED, ahora con IA real (Gemini) en vez
/// de reglas fijas. Le manda a Gemini el catálogo completo como
/// contexto, para que solo recomiende productos que existen de
/// verdad, y le pide que marque sus recomendaciones con una línea
/// especial que esta clase interpreta y convierte en tarjetas de
/// producto dentro del chat.
class ServicioChatbot {
  ServicioChatbot._();

  /// Historial de la conversación, para que Gemini tenga contexto de
  /// lo que ya se habló. Vive mientras la app esté abierta.
  static final List<Map<String, dynamic>> _historial = [];

  static String _construirCatalogoTexto() {
    final buffer = StringBuffer();
    for (final p in DatosProductos.productos) {
      buffer.writeln(
        '- id:${p.id} | ${p.nombre} | ${p.categoria} | ${p.material}'
        '${p.coleccion != null ? ' | Colección: ${p.coleccion}' : ''}'
        ' | \$${p.precio.toStringAsFixed(2)} MXN'
        '${p.disponible ? '' : ' | AGOTADO'}',
      );
    }
    return buffer.toString();
  }

  static String get _promptSistema => '''
Eres el asistente virtual de BEJEWELED, una joyería en línea mexicana.
Responde siempre en español de México, de forma breve (máximo 3-4 líneas), cálida y profesional.
Este es el catálogo disponible. NO inventes productos que no estén en esta lista:
${_construirCatalogoTexto()}

Si algún producto dice AGOTADO, acláralo si el usuario pregunta por él y ofrece alternativas similares.

Cuando recomiendes productos del catálogo, termina tu respuesta con una línea nueva, exactamente así y sin nada más en esa línea:
PRODUCTOS_SUGERIDOS: id1,id2,id3
Usa como máximo 4 ids, separados por comas, sin espacios, usando los ids reales del catálogo (ej. p1, p6). Si no estás recomendando ningún producto en particular, omite esa línea por completo.
''';
    /// Reintenta la petición si Gemini responde 503 (servidor saturado,
  /// común en la capa gratuita). Espera un poco más en cada intento.
  static Future<http.Response> _postConReintentos(Uri uri, String cuerpo, {int intentosMaximos = 3}) async {
    for (var intento = 1; intento <= intentosMaximos; intento++) {
      final respuesta = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: cuerpo,
      );

      final saturado = respuesta.statusCode == 503;
      if (!saturado || intento == intentosMaximos) return respuesta;

      await Future.delayed(Duration(seconds: intento * 2)); // 2s, 4s...
    }
    throw Exception('No se pudo contactar a Gemini tras varios intentos.');
  }
  /// Envía [mensaje] a Gemini y regresa su respuesta ya procesada
  /// (texto limpio + productos sugeridos, si los hubo).
  static Future<RespuestaChatbot> preguntar(String mensaje) async {
    if (!ConfiguracionGemini.hayApiKey) {
      return const RespuestaChatbot(
        texto: 'Falta configurar la API Key de Gemini en '
            'servicio_chatbot.dart (ConfiguracionGemini.apiKey). '
            'Mientras tanto no puedo responder preguntas.',
      );
    }

    _historial.add({
      'role': 'user',
      'parts': [
        {'text': mensaje},
      ],
    });

        try {
      final respuesta = await _postConReintentos(
        Uri.parse(
          '${ConfiguracionGemini.urlBase}/models/${ConfiguracionGemini.modelo}:generateContent'
          '?key=${ConfiguracionGemini.apiKey}',
        ),
        jsonEncode({
          'system_instruction': {
            'parts': [
              {'text': _promptSistema},
            ],
          },
          'contents': _historial,
        }),
      );

      if (respuesta.statusCode >= 400) {
        return RespuestaChatbot(
          texto: 'Error al hablar con Gemini (${respuesta.statusCode}): ${respuesta.body}',
        );
      }

      final datos = jsonDecode(utf8.decode(respuesta.bodyBytes)) as Map<String, dynamic>;
      final candidatos = datos['candidates'] as List<dynamic>?;

      if (candidatos == null || candidatos.isEmpty) {
        return const RespuestaChatbot(
          texto: 'Gemini no regresó ninguna respuesta. Intenta reformular tu pregunta.',
        );
      }

      final partes = candidatos.first['content']['parts'] as List<dynamic>;
      final textoCompleto = partes.map((p) => p['text'] as String? ?? '').join();

      _historial.add({
        'role': 'model',
        'parts': [
          {'text': textoCompleto},
        ],
      });

      return _procesarRespuesta(textoCompleto);
    } catch (error) {
      return RespuestaChatbot(texto: 'No se pudo conectar con Gemini: $error');
    }
  }

  /// Separa el texto visible de la línea "PRODUCTOS_SUGERIDOS: ..." y
  /// convierte esos ids en objetos Producto reales del catálogo.
  static RespuestaChatbot _procesarRespuesta(String textoCompleto) {
    final lineas = textoCompleto.split('\n');
    final lineaSugeridos = lineas.firstWhere(
      (l) => l.trim().startsWith('PRODUCTOS_SUGERIDOS:'),
      orElse: () => '',
    );

    var textoLimpio = textoCompleto;
    var productosSugeridos = <Producto>[];

    if (lineaSugeridos.isNotEmpty) {
      final idsTexto = lineaSugeridos.split(':').last.trim();
      final ids = idsTexto.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toSet();
      productosSugeridos = DatosProductos.productos.where((p) => ids.contains(p.id)).toList();
      textoLimpio = textoCompleto.replaceAll(lineaSugeridos, '').trim();
    }

    return RespuestaChatbot(texto: textoLimpio, productos: productosSugeridos);
  }

  /// Borra el historial, por si quieren agregar un botón de "nueva
  /// conversación" más adelante.
  static void reiniciarConversacion() => _historial.clear();
}