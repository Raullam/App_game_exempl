import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:flutter_loggin/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class PerfilUsuari extends StatelessWidget {
  const PerfilUsuari({super.key});

  @override
  Widget build(BuildContext context) {
    final Usuari? usuari =
        ModalRoute.of(context)?.settings.arguments as Usuari?;

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Página d\'usuari',
              style:
                  TextStyle(color: Colors.black, fontFamily: 'RiverAdventurer'),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFF00C4B4),
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              // Menú desplegable con imagen de usuario
              PopupMenuButton<int>(
                icon: usuari?.imatgePerfil != null &&
                        usuari!.imatgePerfil.isNotEmpty
                    ? CircleAvatar(
                        backgroundImage: usuari.imatgePerfil.startsWith('http')
                            ? NetworkImage(usuari.imatgePerfil)
                            : FileImage(File(usuari.imatgePerfil))
                                as ImageProvider,
                        onBackgroundImageError: (exception, stackTrace) {
                          print('Error cargant l\'imatge: $exception');
                        },
                      )
                    : const CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/exempleDefault.jpg'),
                      ),
                onSelected: (int selectedValue) {
                  if (selectedValue == 0) {
                    Rutes.navegarPerfilUsuari(context, usuari!);
                  } else if (selectedValue == 1) {
                    Rutes.navegarGame(context, usuari!);
                  } else if (selectedValue == 2) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/', (route) => false);
                  } else if (selectedValue == 3) {
                    // Cambiar entre modo noche y día
                    themeProvider.toggleTheme();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text('Perfil'),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Text('Game'),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Text('Cerrar sesión'),
                  ),
                  PopupMenuItem<int>(
                    value: 3,
                    child: Text(
                      themeProvider.isDarkMode ? 'Modo Día' : 'Modo Noche',
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: Container(
            color: themeProvider.isDarkMode
                ? Colors.black // Fondo oscuro
                : Colors.white, // Fondo claro
            child: Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 80.0),
                        child: CircleAvatar(
                          radius: 140,
                          backgroundImage: usuari != null &&
                                  usuari.imatgePerfil != null &&
                                  usuari.imatgePerfil.isNotEmpty
                              ? (usuari.imatgePerfil.startsWith('http')
                                  ? NetworkImage(usuari.imatgePerfil)
                                  : FileImage(File(usuari.imatgePerfil))
                                      as ImageProvider)
                              : const AssetImage('assets/exempleDefault.jpg'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Text('Id: ${usuari?.id ?? 'Desconocido'}',
                            style: TextStyle(
                                fontSize: 18,
                                color: themeProvider.isDarkMode
                                    ? Colors.white
                                    : Colors.black)),
                      ),
                      Text('Nom: ${usuari?.nom ?? 'Desconocido'}',
                          style: TextStyle(
                              fontSize: 18,
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black)),
                      Text(
                        'Correu : ${usuari?.correu ?? 'Desconocido'}',
                        style: TextStyle(
                            fontSize: 18,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black),
                      ),
                      Text(
                        'Edad: ${usuari?.edat ?? 'Desconocida'}',
                        style: TextStyle(
                          fontSize: 18,
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: -5, // Pegado a la parte inferior
                    right: -85, // Margen a la derecha
                    child: Container(
                      height: screenHeight *
                          0.15, // 15% de la altura de la pantalla
                      width: screenWidth * 0.4, // Ajusta el ancho como desees
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/planta2.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -6, // Pegado a la parte inferior
                    right: 185, // Margen a la derecha
                    child: Container(
                      height: screenHeight *
                          0.15, // 15% de la altura de la pantalla
                      width: screenWidth * 0.4, // Ajusta el ancho como desees
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/planta4.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
