import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../proveedores/proveedor_autenticacion.dart';
import '../proveedores/proveedor_idioma.dart';
import '../idioma/textos_app.dart';
import '../tema/colores_app.dart';

class PantallaPerfil extends StatelessWidget {
  const PantallaPerfil({super.key});

  @override
  Widget build(BuildContext context) {
    final autenticacion = context.watch<ProveedorAutenticacion>();
    final usuario = autenticacion.usuarioActual;
    final idioma = context.watch<ProveedorIdioma>();

    final opciones = [
      (Icons.receipt_long_outlined, 'Mis pedidos'),
      (Icons.location_on_outlined, 'Mis direcciones'),
      (Icons.payment_outlined, 'Métodos de pago'),
      (Icons.notifications_none_rounded, context.traducir('notificaciones')),
      (Icons.settings_outlined, 'Configuración'),
      (Icons.help_outline_rounded, 'Ayuda y soporte'),
    ];

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        children: [
          Text(context.traducir('titulo_perfil'), style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 22),
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(gradient: ColoresApp.degradadoDorado, shape: BoxShape.circle),
                child: const Icon(Icons.person, color: Colors.white, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(usuario?.nombre ?? 'Invitada', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 2),
                    Text(usuario?.correo ?? 'Sin sesión iniciada', style: Theme.of(context).textTheme.bodyMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          ...opciones.map(
            (opcion) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                decoration: BoxDecoration(color: ColoresApp.tarjeta, borderRadius: BorderRadius.circular(10), border: Border.all(color: ColoresApp.borde)),
                child: ListTile(
                  leading: Icon(opcion.$1, color: ColoresApp.dorado),
                  title: Text(opcion.$2, style: Theme.of(context).textTheme.titleMedium),
                  trailing: const Icon(Icons.chevron_right, color: ColoresApp.textoTenue),
                  onTap: () {},
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: ColoresApp.tarjeta, borderRadius: BorderRadius.circular(10), border: Border.all(color: ColoresApp.borde)),
            child: ListTile(
              leading: const Icon(Icons.language_rounded, color: ColoresApp.dorado),
              title: Text(context.traducir('idioma'), style: Theme.of(context).textTheme.titleMedium),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (idioma.hayTraduccionesPendientes) ...[
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: ColoresApp.lilaProfundo),
                    ),
                    const SizedBox(width: 8),
                  ],
                  Text(idioma.esEspanol ? 'Español' : 'English', style: const TextStyle(color: ColoresApp.textoTenue, fontSize: 13)),
                  const SizedBox(width: 8),
                  Switch(
                    value: !idioma.esEspanol,
                    activeColor: ColoresApp.lilaProfundo,
                    onChanged: (_) => context.read<ProveedorIdioma>().alternar(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(color: ColoresApp.tarjeta, borderRadius: BorderRadius.circular(10), border: Border.all(color: ColoresApp.borde)),
            child: ListTile(
              leading: const Icon(Icons.logout_rounded, color: ColoresApp.peligro),
              title: Text(context.traducir('cerrar_sesion'), style: const TextStyle(color: ColoresApp.peligro, fontWeight: FontWeight.w600)),
              onTap: () => context.read<ProveedorAutenticacion>().cerrarSesion(),
            ),
          ),
        ],
      ),
    );
  }
}