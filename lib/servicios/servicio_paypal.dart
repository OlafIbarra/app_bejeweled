import 'dart:convert';
import 'package:http/http.dart' as http;

/// Credenciales de PayPal Sandbox (Apps & Credentials en
/// developer.paypal.com).
///
/// ⚠️ SOLO PARA PRUEBAS ACADÉMICAS: en una app real, el Secret Key
/// NUNCA debe vivir en el código del cliente — cualquiera podría
/// extraerlo del APK con herramientas gratuitas y usarlo para hacer
/// llamadas a la API en nombre de la cuenta. Aquí se hace así porque
/// el backend Django todavía no tiene el endpoint de pagos. Cuando lo
/// tenga, esta llave se mueve al servidor y Flutter solo le pide a
/// Django que cree/capture la orden.
class ConfiguracionPaypal {
  ConfiguracionPaypal._();

  static const String clientId = 'BAATwL_yNUn7kJhQFTDCJxy0Ilu68g5qjQbBxchl8VUcycOsfPHcrdwHI8j9OiUprhpisI-HMWK-Y0UKPY';
  static const String secretKey = 'EBGIeU9uC3iKnEXhwIoA_li4Etdr_ST3_UZa8GktgOZqrjUTYsdu7YU0eB6itVPVZb_ZnZ6fvvOoR93b';

  /// api-m.sandbox.paypal.com = pruebas. Para producción sería
  /// api-m.paypal.com (sin ".sandbox").
  static const String urlBase = 'https://api-m.sandbox.paypal.com';

  /// URLs "de mentira" — la app intercepta la navegación hacia ellas
  /// dentro del WebView antes de que lleguen a cargar, así que no
  /// necesitan ser páginas reales.
  static const String urlRegreso = 'https://bejeweled.app/pago-exitoso';
  static const String urlCancelacion = 'https://bejeweled.app/pago-cancelado';

   static bool get credencialesConfiguradas => clientId.isNotEmpty && secretKey.isNotEmpty;
}

/// Resultado de crear una orden: su id y el link al que hay que
/// mandar al usuario para que apruebe el pago.
class OrdenPaypal {
  final String id;
  final String urlAprobacion;
  const OrdenPaypal({required this.id, required this.urlAprobacion});
}

class ServicioPaypal {
  ServicioPaypal._();

  /// Pide un token de acceso a PayPal usando Client ID + Secret
  /// (autenticación básica HTTP).
  static Future<String> _obtenerTokenAcceso() async {
    final credenciales = base64Encode(
      utf8.encode('${ConfiguracionPaypal.clientId}:${ConfiguracionPaypal.secretKey}'),
    );

    final respuesta = await http.post(
      Uri.parse('${ConfiguracionPaypal.urlBase}/v1/oauth2/token'),
      headers: {
        'Authorization': 'Basic $credenciales',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (respuesta.statusCode != 200) {
      throw Exception('No se pudo autenticar con PayPal (${respuesta.statusCode}): ${respuesta.body}');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    return datos['access_token'] as String;
  }

  /// Crea una orden de pago por [monto] y regresa su id + el link de
  /// aprobación al que hay que llevar al usuario.
  static Future<OrdenPaypal> crearOrden(double monto) async {
    final token = await _obtenerTokenAcceso();

    final respuesta = await http.post(
      Uri.parse('${ConfiguracionPaypal.urlBase}/v2/checkout/orders'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'intent': 'CAPTURE',
        'purchase_units': [
          {
            'amount': {
              // NOTA: para simplificar la demo en sandbox se manda el
              // monto tal cual en USD (no se convierte de MXN). Para
              // producción real habría que convertir el monto o usar
              // MXN si la cuenta de PayPal lo tiene habilitado.
              'currency_code': 'USD',
              'value': monto.toStringAsFixed(2),
            },
            'description': 'Compra en BEJEWELED',
          },
        ],
        'payment_source': {
          'paypal': {
            'experience_context': {
              'return_url': ConfiguracionPaypal.urlRegreso,
              'cancel_url': ConfiguracionPaypal.urlCancelacion,
              'brand_name': 'BEJEWELED',
              'user_action': 'PAY_NOW',
              'shipping_preference': 'NO_SHIPPING',
            },
          },
        },
      }),
    );

        if (respuesta.statusCode >= 400) {
      throw Exception('No se pudo crear la orden (${respuesta.statusCode}): ${respuesta.body}');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    final idOrden = datos['id'] as String;
    final enlaces = datos['links'] as List<dynamic>;
    final enlaceAprobacion = enlaces.firstWhere(
      (enlace) => enlace['rel'] == 'payer-action',
      orElse: () => enlaces.firstWhere((enlace) => enlace['rel'] == 'approve'),
    ) as Map<String, dynamic>;

    return OrdenPaypal(id: idOrden, urlAprobacion: enlaceAprobacion['href'] as String);
  }

  /// Captura (cobra) una orden ya aprobada por el usuario.
  /// Regresa true si el cobro se completó.
  static Future<bool> capturarOrden(String idOrden) async {
    final token = await _obtenerTokenAcceso();

    final respuesta = await http.post(
      Uri.parse('${ConfiguracionPaypal.urlBase}/v2/checkout/orders/$idOrden/capture'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (respuesta.statusCode != 200 && respuesta.statusCode != 201) return false;

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    return datos['status'] == 'COMPLETED';
  }
}