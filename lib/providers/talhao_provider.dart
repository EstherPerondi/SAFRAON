import 'package:flutter/material.dart';
import '../models/talhao_model.dart';
import '../services/talhao_service.dart';

class TalhaoProvider extends ChangeNotifier {
  final TalhaoService _service = TalhaoService();
  List<TalhaoModel> _talhoes = [];
  bool _isLoading = false;
  String? _error;

  List<TalhaoModel> get talhoes => _talhoes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Carregar todos os talhões
  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _talhoes = await _service.getAll();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Carregar talhões de uma fazenda
  Future<void> loadByFazendaId(String fazendaId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _talhoes = await _service.getByFazendaId(fazendaId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Criar talhão
  Future<bool> create(TalhaoModel talhao) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.create(talhao);
      if (result != null) {
        _talhoes.insert(0, result);
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

  // Atualizar talhão
  Future<bool> update(TalhaoModel talhao) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.update(talhao);
      if (result != null) {
        final index = _talhoes.indexWhere((t) => t.id == talhao.id);
        if (index != -1) {
          _talhoes[index] = result;
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

  // Deletar talhão
  Future<bool> delete(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.delete(id);
      if (result) {
        _talhoes.removeWhere((t) => t.id == id);
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

  // Buscar talhão por ID
  TalhaoModel? getById(String id) {
    try {
      return _talhoes.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }

  void clear() {
    _talhoes = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}