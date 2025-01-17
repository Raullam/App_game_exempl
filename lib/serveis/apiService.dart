import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://10.0.2.2:3000';

  //////////////////////////////////

/////////////////////////////////////
  // Métodos para gestionar usuarios

  Future<List<dynamic>> fetchUsuarios() async {
    final resposta = await http.get(Uri.parse('$baseUrl/usuaris'));
    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Error al obtener usuarios');
    }
  }

  Future<void> createUsuario(Map<dynamic, dynamic> usuari) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/usuaris'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuari),
    );
    if (resposta.statusCode != 201) {
      throw Exception('Error al crear l\'usuari');
    }
  }

  Future<void> deleteUsuario(int id) async {
    final resposta = await http.delete(Uri.parse('$baseUrl/usuaris/$id'));
    if (resposta.statusCode != 200) {
      throw Exception('Error al eliminar l\'usuari');
    }
  }

  Future<void> updateUsuario(int id, Map<dynamic, dynamic> usuari) async {
    final resposta = await http.put(
      Uri.parse('$baseUrl/usuaris/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuari),
    );
    if (resposta.statusCode != 200) {
      throw Exception('Error al actualizar usuario');
    }
  }

  // Métodos para gestionar plantas

  // Obtener todas las plantas
  Future<List<dynamic>> fetchPlantas() async {
    final resposta = await http.get(Uri.parse('$baseUrl/plantas'));
    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Error al obtener plantas');
    }
  }

  // Obtener plantas de un usuario específico
  Future<List<dynamic>> fetchPlantasByUsuario(int usuarioId) async {
    final resposta =
        await http.get(Uri.parse('$baseUrl/usuaris/$usuarioId/plantas'));
    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body);
    } else {
      throw Exception('Error al obtener plantas del usuario');
    }
  }

  // Crear una nueva planta
  Future<void> createPlanta(Map<String, dynamic> planta) async {
    final resposta = await http.post(
      Uri.parse('$baseUrl/plantas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(planta),
    );
    if (resposta.statusCode != 201) {
      throw Exception('Error al crear la planta');
    }
  }

  // Eliminar una planta
  Future<void> deletePlanta(int id) async {
    final resposta = await http.delete(Uri.parse('$baseUrl/plantas/$id'));
    if (resposta.statusCode != 200) {
      throw Exception('Error al eliminar la planta');
    }
  }

  // Actualizar una planta
  Future<void> updatePlanta(int id, Map<String, dynamic> planta) async {
    final resposta = await http.put(
      Uri.parse('$baseUrl/plantas/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(planta),
    );
    if (resposta.statusCode != 200) {
      throw Exception('Error al actualizar la planta');
    }
  }
}
