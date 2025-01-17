import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/provider/usuarisProvider.dart';
import 'package:flutter_loggin/rutes/rutes.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:flutter_loggin/provider/theme_provider.dart'; // Importamos ThemeProvider

class Loggin extends StatelessWidget {
  // Crea una instància de GoogleSignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Declara els controladors com a variables de la classe
  final TextEditingController correuController = TextEditingController();
  final TextEditingController contrasenyaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final providerUsuaris =
        Provider.of<UsuarisProvider>(context, listen: false);
    final double screenHeight = MediaQuery.of(context).size.height;

    return Consumer<ThemeProvider>(
      // Consumer para obtener el tema
      builder: (context, themeProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Image.asset(
              'assets/letreroMadera.webp', // Ruta de la imagen
              height: 80, // Ajusta el tamaño de la imagen
            ),
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 105, 198, 130),
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(70.0),
                  child: Text(
                    'Inicia sessió',
                    style: TextStyle(
                      color: themeProvider
                          .textColor, // Aplicar color de texto dinámico
                      fontFamily: 'RiverAdventurer',
                      fontSize: screenWidth * 0.10,
                    ),
                  ),
                ),
                Container(
                  height:
                      screenHeight * 0.15, // 15% de la altura de la pantalla
                  width: screenWidth * 0.85, // 85% del ancho de la pantalla
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/planta1.png'),
                      fit: BoxFit.contain, // Ajusta la imagen al contenedor
                    ),
                  ),
                ),
                // TextField per correu i contrasenya
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
                  child: TextField(
                    controller: correuController,
                    style: TextStyle(
                        color: themeProvider.textColor), // Usar color dinámico
                    decoration: InputDecoration(
                      labelText: 'Correu',
                      labelStyle: TextStyle(
                          color: themeProvider
                              .textColor), // Etiqueta con color dinámico
                      hintText: 'Introdueix el teu correu',
                      hintStyle: TextStyle(
                          color: themeProvider
                              .textColor), // Hint con color dinámico
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: contrasenyaController,
                    style: TextStyle(
                        color: themeProvider.textColor), // Usar color dinámico
                    decoration: InputDecoration(
                      labelText: 'Contrasenya',
                      labelStyle: TextStyle(
                          color: themeProvider
                              .textColor), // Etiqueta con color dinámico
                      hintText: 'Introdueix la contrasenya',
                      hintStyle: TextStyle(
                          color: themeProvider
                              .textColor), // Hint con color dinámico
                    ),
                    obscureText: true,
                  ),
                ),
                // Botó d'accés tradicional
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: ElevatedButton(
                    onPressed: () async {
                      String correu = correuController.text;
                      String contrasenya = contrasenyaController.text;
                      Usuari? usuariEncontrado = await providerUsuaris
                          .buscarUsuari(correu, contrasenya);

                      if (usuariEncontrado != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Benvingut, ${usuariEncontrado.nom}!',
                            style: TextStyle(fontFamily: 'RiverAdventurer'),
                          ),
                        ));
                        Rutes.navegarHome(context, usuariEncontrado);
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                            'Correu o contrasenya incorrectes.',
                            style: TextStyle(fontFamily: 'RiverAdventurer'),
                          ),
                        ));
                      }
                    },
                    child: Text(
                      'Accedir',
                      style: TextStyle(fontFamily: 'RiverAdventurer'),
                    ),
                  ),
                ),
                // Botó d'accés amb Google
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton.icon(
                    icon: Image.asset(
                      'assets/google_icon.png',
                      height: 24,
                      width: 24,
                    ),
                    label: Text(
                      'Accedir amb Google',
                      style: TextStyle(fontFamily: 'RiverAdventurer'),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          themeProvider.backgroundColor, // Fondo dinámico
                      foregroundColor:
                          themeProvider.textColor, // Color de texto dinámico
                    ),
                    onPressed: () async {
                      try {
                        // Inicia la sessió amb Google
                        final GoogleSignInAccount? account =
                            await _googleSignIn.signIn();

                        if (account != null) {
                          // Obté informació bàsica de l'usuari de Google
                          final String email = account.email;
                          final String nom =
                              account.displayName ?? "Creat per Google";

                          // Comprova si l'usuari ja existeix
                          Usuari? usuariExist = await providerUsuaris
                              .buscarUsuariPerCorreu(email);

                          if (usuariExist == null) {
                            // Si no existeix, crea un nou usuari amb informació predeterminada
                            Usuari nouUsuari = Usuari(
                              id: DateTime.now()
                                  .millisecondsSinceEpoch, // Genera un ID únic
                              nom: nom,
                              correu: email,
                              contrasenya:
                                  "", // No hi ha contrasenya per a usuaris de Google
                              edat: 0, // Valors predeterminats
                              nacionalitat: "Desconeguda",
                              codiPostal: "00000",
                              imatgePerfil: account.photoUrl ?? "",
                            );

                            await providerUsuaris.addUsuari(nouUsuari);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Nou usuari creat: $nom!',
                                style: TextStyle(fontFamily: 'RiverAdventurer'),
                              ),
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                'Benvingut de nou, ${usuariExist.nom}!',
                                style: TextStyle(fontFamily: 'RiverAdventurer'),
                              ),
                            ));
                          }

                          // Navega a la pàgina principal
                          var nouUsuari;
                          Rutes.navegarHome(context, usuariExist ?? nouUsuari);
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'Accés cancel·lat.',
                              style: TextStyle(fontFamily: 'RiverAdventurer'),
                            ),
                          ));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            'Error en iniciar sessió amb Google: $e',
                            style: TextStyle(fontFamily: 'RiverAdventurer'),
                          ),
                        ));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: themeProvider.backgroundColor, // Fondo dinámico
        );
      },
    );
  }
}
