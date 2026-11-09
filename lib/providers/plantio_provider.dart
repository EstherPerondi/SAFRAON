import 'package:flutter/material.dart';
import '../models/plantio_model.dart';
import '../services/plantio_service.dart';

class PlantioProvider extends ChangeNotifier {
  final PlantioService _service = PlantioService();
  List<PlantioModel> _plantios = [];
  bool _isLoading = false;
  String? _error;

  List<PlantioModel> get plantios => _plantios;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadByTalhaoId(String talhaoId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _plantios = await _service.getByTalhaoId(talhaoId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _plantios = await _service.getAllForUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create(PlantioModel plantio) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.create(plantio);
      if (result != null) {
        _plantios.insert(0, result);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> update(PlantioModel plantio) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.update(plantio);
      if (result != null) {
        final index = _plantios.indexWhere((p) => p.id == plantio.id);
        if (index != -1) {
          _plantios[index] = result;
        }
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> delete(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.delete(id);
      if (result) {
        _plantios.removeWhere((p) => p.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clear() {
    _plantios = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}