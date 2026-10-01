import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedores/proveedor_favoritos.dart';
import '../servicios/servicio_chatbot.dart';
import '../tema/colores_app.dart';
import '../utilidades/moneda.dart';
import 'pantalla_detalle_producto.dart';

class PantallaChatbot extends StatefulWidget {
  const PantallaChatbot({super.key});

  @override
  State<PantallaChatbot> createState() => _PantallaChatbotState();
}

class _PantallaChatbotState extends State<PantallaChatbot> {
  final _controlador = TextEditingController();
  final _controladorScroll = ScrollController();
  bool _escribiendo = false;
  final List<RespuestaChatbot> _mensajes = [
    const RespuestaChatbot(
      texto: '¡Hola! Soy el asistente de BEJEWELED 💎, ahora con IA de '
          'Gemini. Pregúntame lo que quieras sobre nuestras joyas: '
          'categorías, materiales, colecciones, precios o '
          'recomendaciones para alguna ocasión especial.',
    ),
  ];

  Future<void> _enviar() async {
    final texto = _controlador.text.trim();
    if (texto.isEmpty || _escribiendo) return;

    setState(() {
      _mensajes.add(RespuestaChatbot(texto: texto, deUsuario: true));
      _escribiendo = true;
    });
    _controlador.clear();
    _desplazarAlFinal();

    final respuesta = await ServicioChatbot.preguntar(texto);

    if (!mounted) return;
    setState(() {
      _escribiendo = false;
      _mensajes.add(respuesta);
    });
    _desplazarAlFinal();
  }

  void _desplazarAlFinal() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_controladorScroll.hasClients) {
        _controladorScroll.animateTo(
          _controladorScroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controlador.dispose();
    _controladorScroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(gradient: ColoresApp.degradadoDorado, shape: BoxShape.circle),
                  child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Asistente BEJEWELED', style: Theme.of(context).textTheme.titleLarge),
                    Text('Con IA de Gemini', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: ColoresApp.borde),
          Expanded(
            child: ListView.builder(
              controller: _controladorScroll,
              padding: const EdgeInsets.all(20),
              itemCount: _mensajes.length + (_escribiendo ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _mensajes.length) {
                  return const _BurbujaEscribiendo();
                }
                return _BurbujaChat(mensaje: _mensajes[index]);
              },
            ),
          ),
          _construirBarraEntrada(),
        ],
      ),
    );
  }

  Widget _construirBarraEntrada() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controlador,
              style: const TextStyle(color: ColoresApp.textoPrincipal),
              onSubmitted: (_) => _enviar(),
              decoration: const InputDecoration(hintText: 'Ej. "quiero un regalo de menos de 1000 pesos"'),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _enviar,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _escribiendo ? ColoresApp.plateado : ColoresApp.lilaProfundo,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _BurbujaEscribiendo extends StatelessWidget {
  const _BurbujaEscribiendo();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: ColoresApp.tarjeta,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColoresApp.borde),
        ),
        child: const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2, color: ColoresApp.lilaProfundo),
        ),
      ),
    );
  }
}

class _BurbujaChat extends StatelessWidget {
  final RespuestaChatbot mensaje;
  const _BurbujaChat({required this.mensaje});

  @override
  Widget build(BuildContext context) {
    final esUsuario = mensaje.deUsuario;
    return Align(
      alignment: esUsuario ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: esUsuario ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: esUsuario ? ColoresApp.lilaProfundo : ColoresApp.tarjeta,
              borderRadius: BorderRadius.circular(16),
              border: esUsuario ? null : Border.all(color: ColoresApp.borde),
            ),
            child: Text(
              mensaje.texto,
              style: TextStyle(color: esUsuario ? Colors.white : ColoresApp.textoPrincipal, fontSize: 14, height: 1.4),
            ),
          ),
          if (mensaje.productos.isNotEmpty)
            SizedBox(
              height: 175,
              width: MediaQuery.of(context).size.width * 0.85,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: mensaje.productos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final producto = mensaje.productos[index];
                  return GestureDetector(
                    onTap: () {
                      final favoritos = context.read<ProveedorFavoritos>();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PantallaDetalleProducto(
                            producto: producto,
                            esFavorito: favoritos.esFavorito(producto.id),
                            alAlternarFavorito: () => favoritos.alternar(producto.id),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 130,
                      decoration: BoxDecoration(color: ColoresApp.tarjeta, borderRadius: BorderRadius.circular(10), border: Border.all(color: ColoresApp.borde)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                              child: Image.network(
                                producto.urlImagen,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) => const Icon(Icons.diamond_outlined, color: ColoresApp.dorado),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(producto.nombre, maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(color: ColoresApp.textoPrincipal, fontSize: 12, fontWeight: FontWeight.w600)),
                                Text(formatearMxn(producto.precio),
                                    style: const TextStyle(color: ColoresApp.lilaProfundo, fontSize: 12, fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}