import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../servicios/servicio_paypal.dart';
import '../tema/colores_app.dart';

/// Muestra el checkout real de PayPal Sandbox dentro de un WebView.
/// Cuando detecta que PayPal intenta navegar hacia la URL de regreso
/// (aprobado) o de cancelación, cierra la pantalla y regresa el
/// resultado (true = aprobado, false = cancelado) a quien la llamó.
class PantallaWebviewPaypal extends StatefulWidget {
  final String urlAprobacion;

  const PantallaWebviewPaypal({super.key, required this.urlAprobacion});

  @override
  State<PantallaWebviewPaypal> createState() => _PantallaWebviewPaypalState();
}

class _PantallaWebviewPaypalState extends State<PantallaWebviewPaypal> {
  late final WebViewController _controlador;
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _controlador = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _cargando = true),
          onPageFinished: (_) => setState(() => _cargando = false),
          onNavigationRequest: (solicitud) {
            final url = solicitud.url;
            if (url.startsWith(ConfiguracionPaypal.urlRegreso)) {
              Navigator.of(context).pop(true);
              return NavigationDecision.prevent;
            }
            if (url.startsWith(ConfiguracionPaypal.urlCancelacion)) {
              Navigator.of(context).pop(false);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.urlAprobacion));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        title: const Text('PayPal Sandbox'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controlador),
          if (_cargando)
            const Center(child: CircularProgressIndicator(color: ColoresApp.lilaProfundo)),
        ],
      ),
    );
  }
}