import 'package:flutter/material.dart';
import '../models/precipitacao_model.dart';
import '../services/precipitacao_service.dart';

class PrecipitacaoProvider extends ChangeNotifier {
  final PrecipitacaoService _service = PrecipitacaoService();
  List<PrecipitacaoModel> _precipitacoes = [];
  bool _isLoading = false;
  String? _error;

  List<PrecipitacaoModel> get precipitacoes => _precipitacoes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadByTalhaoId(String talhaoId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _precipitacoes = await _service.getByTalhaoId(talhaoId);
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
      _precipitacoes = await _service.getAllForUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> create(PrecipitacaoModel precipitacao) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.create(precipitacao);
      if (result != null) {
        _precipitacoes.insert(0, result);
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

  Future<bool> update(PrecipitacaoModel precipitacao) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.update(precipitacao);
      if (result != null) {
        final index = _precipitacoes.indexWhere((p) => p.id == precipitacao.id);
        if (index != -1) {
          _precipitacoes[index] = result;
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
        _precipitacoes.removeWhere((p) => p.id == id);
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
    _precipitacoes = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}