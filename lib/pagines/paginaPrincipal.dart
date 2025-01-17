import 'package:flutter/material.dart';
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_loggin/provider/theme_provider.dart'; // Importamos el ThemeProvider

class Paginaprincipal extends StatelessWidget {
  const Paginaprincipal({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener las dimensiones de la pantalla
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'TAMA PLANT',
              style:
                  TextStyle(color: Colors.black, fontFamily: 'RiverAdventurer'),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 105, 198, 130),
            actions: [
              IconButton(
                icon: const Icon(Icons.brightness_6), // Icono para cambiar tema
                onPressed: () {
                  // Cambiar el tema cuando el usuario toque el botón
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20), // Espacio superior

              // Panel superior de madera
              Container(
                height: screenHeight * 0.30, // 30% de la altura de la pantalla
                width: screenWidth * 0.85, // 85% del ancho de la pantalla
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/letreroMadera.webp'),
                    colorFilter: ColorFilter.srgbToLinearGamma(), // Opcional
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Botones centrados
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Rutes.paginaLoggin);
                      },
                      child: const Text(
                        'Login',
                        style: TextStyle(
                            fontFamily: 'RiverAdventurer', fontSize: 30),
                      ),
                    ),
                    const SizedBox(height: 10), // Espacio entre botones
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Rutes.paginaRegistre);
                      },
                      child: const Text(
                        'Registra\'t',
                        style: TextStyle(
                            fontFamily: 'RiverAdventurer', fontSize: 30),
                      ),
                    ),
                  ],
                ),
              ),

              // Texto destacado
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  'Beta 0.0.1',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RiverAdventurer',
                    color: Color.fromARGB(255, 105, 198, 130),
                  ),
                ),
              ),

              const SizedBox(height: 20), // Espacio antes del panel inferior

              // Panel inferior de madera
              Container(
                height: screenHeight * 0.15, // 15% de la altura de la pantalla
                width: screenWidth * 0.85, // 85% del ancho de la pantalla
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/letreroMaderaa.webp'),
                    fit: BoxFit.contain, // Ajusta la imagen al contenedor
                  ),
                ),
              ),

              const SizedBox(height: 20), // Espacio después del panel inferior

              // Enlace de donación
              InkWell(
                onTap: () {
                  print("Redirigiendo a la página de donación...");
                  // Aquí puedes usar un URL para redirigir al navegador.
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.monetization_on,
                        color: Colors.green,
                        size: 30,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Donació per a un café ☕',
                        style: TextStyle(
                          fontFamily: 'RiverAdventurer',
                          color: themeProvider
                              .textColor, // Usamos el color de texto dinámico
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: themeProvider
              .backgroundColor, // Usamos el color de fondo dinámico
        );
      },
    );
  }
}
