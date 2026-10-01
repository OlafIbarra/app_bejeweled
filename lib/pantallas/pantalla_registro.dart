import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedores/proveedor_autenticacion.dart';
import '../tema/colores_app.dart';

class PantallaRegistro extends StatefulWidget {
  const PantallaRegistro({super.key});

  @override
  State<PantallaRegistro> createState() => _PantallaRegistroState();
}

class _PantallaRegistroState extends State<PantallaRegistro> {
  final _controladorNombre = TextEditingController();
  final _controladorCorreo = TextEditingController();
  final _controladorContrasena = TextEditingController();
  bool _ocultarContrasena = true;
  bool _enviando = false;
  String? _mensajeError;

  @override
  void dispose() {
    _controladorNombre.dispose();
    _controladorCorreo.dispose();
    _controladorContrasena.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    setState(() {
      _enviando = true;
      _mensajeError = null;
    });
    final error = await context.read<ProveedorAutenticacion>().registrar(
          nombre: _controladorNombre.text,
          correo: _controladorCorreo.text,
          contrasena: _controladorContrasena.text,
        );
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _enviando = false;
        _mensajeError = error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text('Únete a BEJEWELED', style: Theme.of(context).textTheme.displayMedium),
                const SizedBox(height: 6),
                Text(
                  'Crea tu cuenta para guardar favoritos y comprar más rápido.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 28),
                TextField(
                  controller: _controladorNombre,
                  style: const TextStyle(color: ColoresApp.textoPrincipal),
                  decoration: const InputDecoration(
                    hintText: 'Nombre completo',
                    prefixIcon: Icon(Icons.person_outline, color: ColoresApp.textoTenue),
                  ),
                ),
                const SizedBox(height: 14),
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
                    hintText: 'Contraseña (mín. 4 caracteres)',
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
                        : const Text('Crear cuenta'),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
