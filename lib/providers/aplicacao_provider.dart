import 'package:flutter/material.dart';
import '../models/aplicacao_model.dart';
import '../services/aplicacao_service.dart';

class AplicacaoProvider extends ChangeNotifier {
  final AplicacaoService _service = AplicacaoService();
  List<AplicacaoModel> _aplicacoes = [];
  bool _isLoading = false;
  String? _error;

  List<AplicacaoModel> get aplicacoes => _aplicacoes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Carregar aplicações de um talhão
  Future<void> loadByTalhaoId(String talhaoId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _aplicacoes = await _service.getByTalhaoId(talhaoId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Carregar todas as aplicações do usuário
  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _aplicacoes = await _service.getAllForUser();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Criar aplicação
  Future<bool> create(AplicacaoModel aplicacao) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.create(aplicacao);
      if (result != null) {
        _aplicacoes.insert(0, result);
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

  // Atualizar aplicação
  Future<bool> update(AplicacaoModel aplicacao) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.update(aplicacao);
      if (result != null) {
        final index = _aplicacoes.indexWhere((a) => a.id == aplicacao.id);
        if (index != -1) {
          _aplicacoes[index] = result;
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

  // Deletar aplicação
  Future<bool> delete(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.delete(id);
      if (result) {
        _aplicacoes.removeWhere((a) => a.id == id);
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
    _aplicacoes = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}