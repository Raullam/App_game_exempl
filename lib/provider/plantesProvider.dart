import 'package:flutter/material.dart';
import 'package:flutter_loggin/serveis/plantaService.dart';
import '../models/planta.dart';

class PlantaProvider with ChangeNotifier {
  final PlantaService _plantaService = PlantaService();
  List<Planta> _plantas = [];

  List<Planta> get plantas => [..._plantas];

  // Obtener todas las plantas
  Future<void> fetchPlantas() async {
    try {
      _plantas = await _plantaService.fetchPlantas();
      notifyListeners();
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  // Añadir una nueva planta
  Future<void> addPlanta(Planta planta) async {
    try {
      final newPlanta = await _plantaService.addPlanta(planta);
      _plantas.add(newPlanta);
      notifyListeners();
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  // Actualizar una planta existente
  Future<void> updatePlanta(Planta planta) async {
    try {
      // Pasamos el objeto Planta entero para actualizar
      await _plantaService.updatePlanta(planta);
      final index = _plantas.indexWhere((p) => p.id == planta.id);
      if (index >= 0) {
        _plantas[index] = planta;
        notifyListeners();
      }
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  // Eliminar una planta
  Future<void> deletePlanta(int id) async {
    try {
      await _plantaService.deletePlanta(id);
      _plantas.removeWhere((planta) => planta.id == id);
      notifyListeners();
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }
}
