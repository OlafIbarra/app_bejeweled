import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedores/proveedor_carrito.dart';
import '../servicios/servicio_paypal.dart';
import '../tema/colores_app.dart';
import '../utilidades/moneda.dart';
import 'pantalla_webview_paypal.dart';

class PantallaPago extends StatefulWidget {
  const PantallaPago({super.key});

  @override
  State<PantallaPago> createState() => _PantallaPagoState();
}

class _PantallaPagoState extends State<PantallaPago> {
  bool _procesando = false;

  @override
  Widget build(BuildContext context) {
    final carrito = context.watch<ProveedorCarrito>();

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(title: const Text('Resumen de compra')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ...carrito.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.producto.urlImagen,
                              width: 56,
                              height: 56,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 56,
                                height: 56,
                                color: ColoresApp.tenue,
                                child: const Icon(Icons.diamond_outlined, color: ColoresApp.dorado),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.producto.nombre, style: Theme.of(context).textTheme.titleMedium),
                                Text('x${item.cantidad}', style: const TextStyle(color: ColoresApp.textoTenue, fontSize: 12)),
                              ],
                            ),
                          ),
                          Text(formatearMxn(item.subtotal), style: const TextStyle(color: ColoresApp.lilaProfundo, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  const Divider(color: ColoresApp.borde, height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Total', style: Theme.of(context).textTheme.titleLarge),
                      Text(formatearMxn(carrito.total), style: const TextStyle(color: ColoresApp.lilaProfundo, fontSize: 20, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: ColoresApp.tenue,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ColoresApp.dorado.withOpacity(0.4)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline, color: ColoresApp.doradoOscuro, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            ConfiguracionPaypal.credencialesConfiguradas
                                ? 'Pago real de PRUEBA en PayPal Sandbox (dinero ficticio, no se cobra nada real).'
                                : 'Faltan credenciales de PayPal en servicio_paypal.dart — se usará el pago simulado.',
                            style: const TextStyle(color: ColoresApp.textoTenue, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: carrito.estaVacio || _procesando ? null : () => _iniciarPago(context, carrito),
                  icon: _procesando
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.lock_outline, size: 18),
                  label: const Text('Pagar con PayPal'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _iniciarPago(BuildContext context, ProveedorCarrito carrito) async {
    if (!ConfiguracionPaypal.credencialesConfiguradas) {
      _mostrarHojaSimulada(context, carrito);
      return;
    }

    setState(() => _procesando = true);
    try {
      final orden = await ServicioPaypal.crearOrden(carrito.total);

      if (!mounted) return;
      final aprobado = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (_) => PantallaWebviewPaypal(urlAprobacion: orden.urlAprobacion)),
      );

      if (aprobado != true) {
        setState(() => _procesando = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pago cancelado.')),
        );
        return;
      }

      final capturado = await ServicioPaypal.capturarOrden(orden.id);
      setState(() => _procesando = false);
      if (!mounted) return;

      if (capturado) {
        carrito.vaciar();
        _mostrarDialogoResultado(exito: true, mensaje: '¡Pago aprobado y capturado en PayPal Sandbox! (Orden: ${orden.id})');
      } else {
        _mostrarDialogoResultado(exito: false, mensaje: 'PayPal aprobó el pago pero no se pudo capturar. Intenta de nuevo.');
      }
    } catch (error) {
      setState(() => _procesando = false);
      if (!mounted) return;
      _mostrarDialogoResultado(exito: false, mensaje: 'Error al conectar con PayPal: $error');
    }
  }

  // --- Modo simulado de respaldo (si no hay credenciales configuradas) ---

  void _mostrarHojaSimulada(BuildContext context, ProveedorCarrito carrito) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (contextoHoja) => _HojaPaypalSimulada(
        monto: carrito.total,
        alConfirmar: () => _simularPago(contextoHoja, carrito),
      ),
    );
  }

  Future<void> _simularPago(BuildContext contextoHoja, ProveedorCarrito carrito) async {
    Navigator.of(contextoHoja).pop();
    setState(() => _procesando = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _procesando = false);
    carrito.vaciar();
    _mostrarDialogoResultado(exito: true, mensaje: '¡Pago simulado exitosamente! (modo demo, sin credenciales configuradas)');
  }

  void _mostrarDialogoResultado({required bool exito, required String mensaje}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: ColoresApp.tarjeta,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Row(
          children: [
            Icon(exito ? Icons.check_circle : Icons.error_outline, color: exito ? ColoresApp.dorado : ColoresApp.peligro),
            const SizedBox(width: 10),
            Text(exito ? '¡Listo!' : 'Ups', style: const TextStyle(color: ColoresApp.textoPrincipal)),
          ],
        ),
        content: Text(mensaje, style: const TextStyle(color: ColoresApp.textoTenue)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (exito) Navigator.of(context).popUntil((r) => r.isFirst);
            },
            child: const Text('Aceptar', style: TextStyle(color: ColoresApp.lilaProfundo)),
          ),
        ],
      ),
    );
  }
}

/// Hoja de respaldo que imita visualmente el checkout de PayPal,
/// usada solo si todavía no se configuran credenciales reales.
class _HojaPaypalSimulada extends StatelessWidget {
  final double monto;
  final VoidCallback alConfirmar;

  const _HojaPaypalSimulada({required this.monto, required this.alConfirmar});

  static const _azulPaypal = Color(0xFF003087);
  static const _azulClaroPaypal = Color(0xFF0070BA);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Pay', style: TextStyle(color: _azulPaypal, fontSize: 26, fontWeight: FontWeight.w800)),
                const Text('Pal', style: TextStyle(color: _azulClaroPaypal, fontSize: 26, fontWeight: FontWeight.w800)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(6)),
                  child: const Text('SANDBOX (DEMO)', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text('${formatearMxn(monto)} MXN', style: const TextStyle(color: Colors.black87, fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Total a pagar a BEJEWELED', style: TextStyle(color: Colors.black54, fontSize: 13)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: alConfirmar,
                style: ElevatedButton.styleFrom(backgroundColor: _azulClaroPaypal, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26))),
                child: const Text('Confirmar y pagar', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar', style: TextStyle(color: Colors.black54)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}