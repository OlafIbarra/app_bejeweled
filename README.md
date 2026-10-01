# BEJEWELED 💎

App de e-commerce de joyería en **Flutter**, con el mismo sistema de
diseño que la versión web (Django): fondo crema, lila como color
principal, dorado como acento, tipografías **Gilda Display** (títulos)
y **Raleway** (texto). El catálogo, categorías, materiales y
colecciones están portados 1:1 del comando `poblar_bd.py` del backend.


## Pantallas incluidas

- **Login / Registro** (`pantalla_login.dart`, `pantalla_registro.dart`): autenticación local, persistida en el dispositivo.
- **Inicio** (`pantalla_inicio.dart`): saludo, hero, buscador, filtro por categoría y por colección, cuadrícula de productos con etiquetas (Nuevo/Destacado/Agotado).
- **Asistente** (`pantalla_chatbot.dart`): reglas simples sobre categoría, material, colección o presupuesto.
- **Detalle de producto** (`pantalla_detalle_producto.dart`): imagen, precio en MXN, categoría/material/colección/existencias, descripción, "Agregar al carrito".
- **Favoritos**, **Carrito** y **Pago** (`pantalla_favoritos.dart`, `pantalla_carrito.dart`, `pantalla_pago.dart`): PayPal simulado.
- **Perfil** (`pantalla_perfil.dart`): datos de cuenta, selector de idioma (ES/EN) y cerrar sesión.

## Cómo correrlo

```bash
cd bejeweled_app
flutter create .      # solo si faltan las carpetas android/ios/etc.
flutter pub get
flutter run
```

## Sobre el backend Django (estado actual)

- Su proyecto Django es **100% de vistas HTML**, sin Django REST
  Framework ni endpoints JSON todavía. Por eso esta app sigue usando
  datos locales (`lib/datos/datos_productos.dart`).
- Su modelo de datos usa **Categoría, Material y Colección** — no
  "marcas". El modelo `Producto` de Flutter ya refleja exactamente eso.
- El chatbot con IA en la web todavía es un botón deshabilitado
  ("Próximamente"). En Flutter ya funciona con reglas simples.

## Plan para conectar con Django + PayPal (próxima etapa)

1. **Ella agrega Django REST Framework** y crea endpoints JSON para
   productos, categorías, materiales, colecciones y autenticación
   (recomendado: `djangorestframework-simplejwt` para tokens).
2. **Ella agrega un endpoint de pago** (ej. `/api/pedidos/<id>/crear-pago/`)
   que llama a la API de PayPal **desde el servidor** — la llave
   secreta nunca debe viajar dentro de la app, o cualquiera podría
   extraerla del APK.
3. **Aquí en Flutter**, se reemplazan los proveedores actuales para
   que hagan peticiones HTTP a esos endpoints en vez de usar datos
   locales.
4. La pantalla de pago deja de simular y llama al endpoint de Django,
   que confirma con PayPal y regresa el resultado.

## Estructura del proyecto (todo en español)

```
lib/
 ├─ main.dart                              # obligatorio en inglés (requisito de Dart/Flutter)
 ├─ tema/
 │   ├─ colores_app.dart                   # paleta portada del CSS de la web
 │   └─ tema_app.dart                      # Gilda Display + Raleway, tema claro
 ├─ modelos/
 │   ├─ producto.dart                      # espejo del modelo Producto de Django
 │   ├─ usuario.dart
 │   └─ item_carrito.dart
 ├─ datos/
 │   └─ datos_productos.dart               # catálogo idéntico a poblar_bd.py
 ├─ utilidades/
 │   └─ moneda.dart                        # formato de precios en MXN
 ├─ proveedores/
 │   ├─ proveedor_autenticacion.dart       # login/registro local (SharedPreferences)
 │   ├─ proveedor_carrito.dart
 │   ├─ proveedor_favoritos.dart
 │   └─ proveedor_idioma.dart              # idioma ES/EN
 ├─ idioma/
 │   └─ textos_app.dart                    # diccionario de traducción
 ├─ servicios/
 │   └─ servicio_chatbot.dart              # asistente por reglas simples
 ├─ widgets/
 │   ├─ tarjeta_producto.dart
 │   ├─ banner_promocional.dart
 │   ├─ chips_categoria.dart
 │   └─ barra_navegacion.dart
 └─ pantallas/
     ├─ puerta_autenticacion.dart
     ├─ pantalla_login.dart
     ├─ pantalla_registro.dart
     ├─ pantalla_principal.dart
     ├─ pantalla_inicio.dart
     ├─ pantalla_chatbot.dart
     ├─ pantalla_detalle_producto.dart
     ├─ pantalla_favoritos.dart
     ├─ pantalla_carrito.dart
     ├─ pantalla_pago.dart                 # PayPal simulado (ver nota arriba)
     └─ pantalla_perfil.dart
```



## Permisos de Android

Para que las imágenes de red carguen en modo **release** (no solo en
debug), agrega el permiso de internet en
`android/app/src/main/AndroidManifest.xml`, justo antes de `<application`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
```
