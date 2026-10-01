/// Modelo simple de usuario para autenticación local (sin backend).
/// Cuando conecten Django, esto se reemplaza por el usuario que
/// devuelva la API (idealmente con un token JWT).
class Usuario {
  final String id;
  final String nombre;
  final String correo;
  final String hashContrasena; // hash simple solo para demo local
  final bool esAdministrador;

  const Usuario({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.hashContrasena,
    this.esAdministrador = false,
  });

  Map<String, dynamic> aJson() => {
        'id': id,
        'nombre': nombre,
        'correo': correo,
        'hashContrasena': hashContrasena,
        'esAdministrador': esAdministrador,
      };

  factory Usuario.desdeJson(Map<String, dynamic> json) => Usuario(
        id: json['id'] as String,
        nombre: json['nombre'] as String,
        correo: json['correo'] as String,
        hashContrasena: json['hashContrasena'] as String,
        esAdministrador: json['esAdministrador'] as bool? ?? false,
      );
}
