import 'package:flutter/material.dart';
import '../models/manejo_model.dart';
import '../services/manejo_service.dart';

class ManejoProvider extends ChangeNotifier {
  final ManejoService _service = ManejoService();
  List<ManejoModel> _manejos = [];
  bool _isLoading = false;
  String? _error;

  List<ManejoModel> get manejos => _manejos;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadByTalhaoId(String talhaoId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _manejos = await _service.getByTalhaoId(talhaoId);
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
      _manejos = await _service.getAllForUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create(ManejoModel manejo) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.create(manejo);
      if (result != null) {
        _manejos.insert(0, result);
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

  Future<bool> update(ManejoModel manejo) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.update(manejo);
      if (result != null) {
        final index = _manejos.indexWhere((m) => m.id == manejo.id);
        if (index != -1) {
          _manejos[index] = result;
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
        _manejos.removeWhere((m) => m.id == id);
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
    _manejos = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}