import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/provider/crypto_provider.dart';
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:flutter_loggin/widgets/card_swiper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_loggin/provider/theme_provider.dart'; // Importamos el ThemeProvider

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el usuario de los argumentos
    final Usuari? usuari =
        ModalRoute.of(context)?.settings.arguments as Usuari?;
    final provider = Provider.of<CryptoProvider>(context);

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false, // Oculta la flecha de "atrás"
            title: const Text(
              'Home',
              style:
                  TextStyle(color: Colors.black, fontFamily: 'RiverAdventurer'),
            ),
            centerTitle: true,
            backgroundColor: const Color(0xFF00C4B4),
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
          body: Center(
            child: usuari == null
                ? Text(
                    'No se encontró el usuario',
                    style: TextStyle(
                      color: themeProvider
                          .textColor, // Usamos el color de texto dinámico
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CardSwiper(cryptos: provider.cryptos),
                    ],
                  ),
          ),
          backgroundColor: themeProvider
              .backgroundColor, // Usamos el color de fondo dinámico
        );
      },
    );
  }
}
