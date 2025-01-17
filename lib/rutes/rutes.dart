import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/planta.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/pagines/game.dart';
import 'package:flutter_loggin/pagines/home.dart';
import 'package:flutter_loggin/pagines/loggings_logouts_register/login.dart';
import 'package:flutter_loggin/pagines/loggings_logouts_register/registre.dart';
import 'package:flutter_loggin/pagines/paginaPrincipal.dart';
import 'package:flutter_loggin/pagines/perfilUsuari.dart';
import 'package:flutter_loggin/widgets/plantaDetall.dart';

class Rutes {
  static const String paginaPrincipal = '/';
  static const String paginaLoggin = '/Loggin';
  static const String paginaRegistre = '/Registre';
  static const String home = '/Home';
  static const String perfilUsuari = '/Perfil';
  static const String game = '/Game';
  static const String plantaDetail = '/PlantaDetail'; // Nueva ruta

  // Definimos las rutas sin pasar parámetros aquí
  static Map<String, WidgetBuilder> obtenerRutas() {
    return {
      paginaPrincipal: (BuildContext context) => const Paginaprincipal(),
      paginaLoggin: (BuildContext context) => Loggin(),
      paginaRegistre: (BuildContext context) => const Registre(),
      home: (BuildContext context) => const Home(),
      perfilUsuari: (BuildContext context) => const PerfilUsuari(),
      game: (BuildContext context) => const Game(),
      plantaDetail: (BuildContext context) => Plantadetall(
          planta: ModalRoute.of(context)!.settings.arguments as Planta),
    };
  }

  // Definimos las rutas con parámetros aquí
  static void navegarHome(BuildContext context, Usuari usuari) {
    Navigator.pushNamed(
      context,
      home,
      arguments: usuari,
    );
  }

  static void navegarPerfilUsuari(BuildContext context, Usuari usuari) {
    Navigator.pushNamed(
      context,
      perfilUsuari,
      arguments: usuari,
    );
  }

  static void navegarGame(BuildContext context, Usuari usuari) {
    Navigator.pushNamed(
      context,
      game,
      arguments: usuari,
    );
  }

  // Nueva función para navegar a PlantaDetailPage
  static void navegarPlantaDetail(BuildContext context, Planta planta) {
    Navigator.pushNamed(
      context,
      plantaDetail,
      arguments: planta,
    );
  }
}
