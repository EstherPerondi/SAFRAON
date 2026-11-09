import 'package:flutter/material.dart';
import '../models/colheita_model.dart';
import '../services/colheita_service.dart';

class ColheitaProvider extends ChangeNotifier {
  final ColheitaService _service = ColheitaService();
  List<ColheitaModel> _colheitas = [];
  bool _isLoading = false;
  String? _error;

  List<ColheitaModel> get colheitas => _colheitas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadByTalhaoId(String talhaoId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _colheitas = await _service.getByTalhaoId(talhaoId);
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
      _colheitas = await _service.getAllForUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create(ColheitaModel colheita) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.create(colheita);
      if (result != null) {
        _colheitas.insert(0, result);
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

  Future<bool> update(ColheitaModel colheita) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.update(colheita);
      if (result != null) {
        final index = _colheitas.indexWhere((c) => c.id == colheita.id);
        if (index != -1) {
          _colheitas[index] = result;
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
        _colheitas.removeWhere((c) => c.id == id);
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
    _colheitas = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}