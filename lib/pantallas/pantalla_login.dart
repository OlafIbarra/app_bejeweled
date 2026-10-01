import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../proveedores/proveedor_autenticacion.dart';
import '../tema/colores_app.dart';
import 'pantalla_registro.dart';

class PantallaLogin extends StatefulWidget {
  const PantallaLogin({super.key});

  @override
  State<PantallaLogin> createState() => _PantallaLoginState();
}

class _PantallaLoginState extends State<PantallaLogin> {
  final _controladorCorreo = TextEditingController();
  final _controladorContrasena = TextEditingController();
  bool _ocultarContrasena = true;
  bool _enviando = false;
  String? _mensajeError;

  @override
  void dispose() {
    _controladorCorreo.dispose();
    _controladorContrasena.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    setState(() {
      _enviando = true;
      _mensajeError = null;
    });
    final error = await context.read<ProveedorAutenticacion>().iniciarSesion(
          correo: _controladorCorreo.text,
          contrasena: _controladorContrasena.text,
        );
    if (!mounted) return;
    setState(() {
      _enviando = false;
      _mensajeError = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'BEJEWELED',
                    style: GoogleFonts.gildaDisplay(color: ColoresApp.lilaProfundo, fontSize: 32, letterSpacing: 3),
                  ),
                  const SizedBox(height: 6),
                  Text('Bienvenida de vuelta', style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 36),
                  TextField(
                    controller: _controladorCorreo,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: ColoresApp.textoPrincipal),
                    decoration: const InputDecoration(
                      hintText: 'Correo electrónico',
                      prefixIcon: Icon(Icons.mail_outline, color: ColoresApp.textoTenue),
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _controladorContrasena,
                    obscureText: _ocultarContrasena,
                    style: const TextStyle(color: ColoresApp.textoPrincipal),
                    decoration: InputDecoration(
                      hintText: 'Contraseña',
                      prefixIcon: const Icon(Icons.lock_outline, color: ColoresApp.textoTenue),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarContrasena ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: ColoresApp.textoTenue,
                        ),
                        onPressed: () => setState(() => _ocultarContrasena = !_ocultarContrasena),
                      ),
                    ),
                  ),
                  if (_mensajeError != null) ...[
                    const SizedBox(height: 12),
                    Text(_mensajeError!, style: const TextStyle(color: ColoresApp.peligro, fontSize: 13)),
                  ],
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _enviando ? null : _enviar,
                      child: _enviando
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Iniciar sesión'),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const PantallaRegistro()),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: '¿No tienes cuenta? ',
                          style: const TextStyle(color: ColoresApp.textoTenue, fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'Regístrate',
                              style: TextStyle(color: ColoresApp.dorado, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
