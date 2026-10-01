import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modelos/usuario.dart';

/// Autenticación 100% local (sin backend todavía).
/// Guarda usuarios registrados y la sesión activa en SharedPreferences.
/// Cuando el equipo tenga el backend Django, solo hay que reemplazar
/// los métodos `registrar`/`iniciarSesion` por llamadas HTTP a la API
/// real y guardar el token en vez del usuario completo.
class ProveedorAutenticacion extends ChangeNotifier {
  static const _claveUsuarios = 'bejeweled_usuarios';
  static const _claveSesion = 'bejeweled_sesion_correo';

  Usuario? _usuarioActual;
  bool _cargando = true;

  Usuario? get usuarioActual => _usuarioActual;
  bool get sesionIniciada => _usuarioActual != null;
  bool get cargando => _cargando;

  ProveedorAutenticacion() {
    _restaurarSesion();
  }

  String _hash(String valor) {
    // Hash simple SOLO para demo académica. No usar en producción real.
    return valor.split('').map((c) => c.codeUnitAt(0)).fold<int>(
          0,
          (previo, codigo) => (previo * 31 + codigo) % 1000000007,
        ).toString();
  }

  Future<List<Usuario>> _cargarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    final crudo = prefs.getString(_claveUsuarios);
    if (crudo == null) return [];
    final lista = jsonDecode(crudo) as List<dynamic>;
    return lista.map((e) => Usuario.desdeJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> _guardarUsuarios(List<Usuario> usuarios) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _claveUsuarios,
      jsonEncode(usuarios.map((u) => u.aJson()).toList()),
    );
  }

  Future<void> _restaurarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    final correo = prefs.getString(_claveSesion);
    if (correo != null) {
      final usuarios = await _cargarUsuarios();
      _usuarioActual = usuarios.where((u) => u.correo == correo).isNotEmpty
          ? usuarios.firstWhere((u) => u.correo == correo)
          : null;
    }
    _cargando = false;
    notifyListeners();
  }

  /// Retorna null si el registro fue exitoso, o un mensaje de error.
  Future<String?> registrar({
    required String nombre,
    required String correo,
    required String contrasena,
  }) async {
    final usuarios = await _cargarUsuarios();
    final correoMinusculas = correo.trim().toLowerCase();

    if (nombre.trim().isEmpty) return 'Ingresa tu nombre.';
    if (!correoMinusculas.contains('@')) return 'Ingresa un correo válido.';
    if (contrasena.length < 4) {
      return 'La contraseña debe tener al menos 4 caracteres.';
    }
    if (usuarios.any((u) => u.correo == correoMinusculas)) {
      return 'Ya existe una cuenta con ese correo.';
    }

    final nuevoUsuario = Usuario(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: nombre.trim(),
      correo: correoMinusculas,
      hashContrasena: _hash(contrasena),
    );
    usuarios.add(nuevoUsuario);
    await _guardarUsuarios(usuarios);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveSesion, nuevoUsuario.correo);
    _usuarioActual = nuevoUsuario;
    notifyListeners();
    return null;
  }

  /// Retorna null si el inicio de sesión fue exitoso, o un mensaje de error.
  Future<String?> iniciarSesion({
    required String correo,
    required String contrasena,
  }) async {
    final usuarios = await _cargarUsuarios();
    final correoMinusculas = correo.trim().toLowerCase();
    final coincidencias = usuarios.where((u) => u.correo == correoMinusculas);

    if (coincidencias.isEmpty) return 'No existe una cuenta con ese correo.';
    final usuario = coincidencias.first;
    if (usuario.hashContrasena != _hash(contrasena)) {
      return 'Contraseña incorrecta.';
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveSesion, usuario.correo);
    _usuarioActual = usuario;
    notifyListeners();
    return null;
  }

  Future<void> cerrarSesion() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_claveSesion);
    _usuarioActual = null;
    notifyListeners();
  }
}
