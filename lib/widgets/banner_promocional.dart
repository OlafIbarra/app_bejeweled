import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../tema/colores_app.dart';

/// Hero de inicio — mismo mensaje que la web ("Encuentra la joya
/// perfecta para cada momento"), adaptado a una tarjeta compacta para
/// el celular.
class BannerPromocional extends StatelessWidget {
  const BannerPromocional({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1558882268-15aa056d885f?w=1200&q=80'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          gradient: ColoresApp.superposicionHero,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'JOYERÍA FINA',
              style: TextStyle(
                color: ColoresApp.doradoClaro.withOpacity(0.9),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Encuentra la joya\nperfecta para cada momento',
              style: GoogleFonts.gildaDisplay(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w400, height: 1.25),
            ),
            const SizedBox(height: 10),
            Text(
              'Piezas únicas con los metales y piedras más selectas.',
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
