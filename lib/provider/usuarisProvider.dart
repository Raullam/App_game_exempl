import 'package:flutter/material.dart';
import 'package:flutter_loggin/models/usuari.dart';
import 'package:flutter_loggin/serveis/apiService.dart';

class UsuarisProvider extends ChangeNotifier {
  // Lista de usuarios
  List<Usuari> usuaris = [];
  final ApiService apiService = ApiService();

  // Getter para acceder a la lista de usuarios
  List<Usuari> get getUsuaris => usuaris;

  // Cargar usuarios desde la API
  Future<void> fetchUsuaris() async {
    try {
      final usuariosData = await apiService.fetchUsuarios();

      // Mapea los datos de la API al modelo Usuari
      usuaris =
          usuariosData.map((usuario) => Usuari.fromJson(usuario)).toList();
      notifyListeners();
    } catch (e) {
      throw Exception('Error al cargar usuarios: $e');
    }
  }

  Future<void> addUsuari(Usuari usuari) async {
    try {
      final nuevoUsuario = {
        'nom': usuari.nom,
        'correu': usuari.correu,
        'contrasenya': usuari.contrasenya,
        'edat': usuari.edat,
        'nacionalitat': usuari.nacionalitat,
        'codiPostal': usuari.codiPostal,
        'imatgePerfil': usuari.imatgePerfil,
      };

      // Imprimir datos enviados
      //print('Datos enviados a la API: $nuevoUsuario');

      // Llamada a la API
      await apiService.createUsuario(nuevoUsuario);

      await fetchUsuaris(); // Recargar la lista desde la API
    } catch (e) {
      // Imprimir error desde la API o local
      print('Error al añadir usuario: $e');
      throw Exception('Error al añadir usuario: $e');
    }
  }

  // Eliminar un usuario por ID usando la API
  Future<void> removeUsuari(int id) async {
    try {
      await apiService.deleteUsuario(id);
      await fetchUsuaris(); // Recargar la lista desde la API
    } catch (e) {
      throw Exception('Error al eliminar usuario: $e');
    }
  }

  // Actualizar un usuario usando la API
  Future<void> updateUsuari(int id, Usuari usuariActualitzat) async {
    try {
      final usuarioActualizado = {
        'name': usuariActualitzat.nom,
        'email': usuariActualitzat.correu,
        'password': usuariActualitzat.contrasenya,
        'age': usuariActualitzat.edat,
        'nationality': usuariActualitzat.nacionalitat,
        'codi_postal': usuariActualitzat.codiPostal, // Nuevo campo
        'imatge_perfil': usuariActualitzat.imatgePerfil, // Nuevo campo
      };

      await apiService.updateUsuario(id, usuarioActualizado);
      await fetchUsuaris(); // Recargar la lista desde la API
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  Future<Usuari?> buscarUsuari(String correu, String contrasenya) async {
    try {
      // Asegurarte de que la lista de usuarios se cargue antes de buscar
      await fetchUsuaris();

      // Buscar en la lista ya cargada
      final usuarioEncontrado = usuaris.firstWhere(
        (u) => u.correu == correu && u.contrasenya == contrasenya,
      );

      // Imprimir el usuario encontrado
      print('Usuario encontrado: ${usuarioEncontrado.toJson()}');

      return usuarioEncontrado;
    } catch (e) {
      // Imprimir mensaje si no se encuentra el usuario
      print(
          'No se encontró ningún usuario con el correo $correu y contraseña proporcionada.');
      return null;
    }
  }

  // Nuevo método: Buscar usuario por correo
  Future<Usuari?> buscarUsuariPerCorreu(String correu) async {
    try {
      // Asegúrate de que la lista de usuarios esté cargada antes de buscar
      await fetchUsuaris();

      // Buscar el usuario por correo
      final usuarioEncontrado = usuaris.firstWhere((u) => u.correu == correu,
          orElse: () => null as Usuari);

      if (usuarioEncontrado != null) {
        print(
            'Usuario encontrado con correo $correu: ${usuarioEncontrado.toJson()}');
      } else {
        print('No se encontró ningún usuario con el correo $correu.');
      }

      return usuarioEncontrado;
    } catch (e) {
      print('Error al buscar usuario por correo: $e');
      return null;
    }
  }
}
