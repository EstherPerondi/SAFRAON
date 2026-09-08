// lib/providers/talhao_provider.dart
import 'package:flutter/material.dart';
import '../models/talhao_model.dart';
import '../services/talhao_service.dart';

class TalhaoProvider extends ChangeNotifier {
  final TalhaoService _service = TalhaoService();
  
  List<TalhaoModel> _talhoes = [];
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  // Getters
  List<TalhaoModel> get talhoes => _talhoes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  bool get hasTalhoes => _talhoes.isNotEmpty;

  // ============================================
  // ✅ ADICIONAR ESTE MÉTODO
  // ============================================
  Future<void> loadAll() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      _talhoes = await _service.getAll();
      print('✅ ${_talhoes.length} talhões carregados');
    } catch (e) {
      _error = e.toString();
      print('❌ Erro ao carregar talhões: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Carregar talhões por fazenda
  Future<void> loadTalhoesByFazenda(String fazendaId) async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      _talhoes = await _service.getByFazenda(fazendaId);
      print('✅ ${_talhoes.length} talhões carregados para fazenda $fazendaId');
    } catch (e) {
      _error = e.toString();
      print('❌ Erro ao carregar talhões: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Criar talhão
  Future<bool> create(TalhaoModel talhao) async {
    if (_isLoading) return false;

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final novoTalhao = await _service.create(talhao);
      
      if (novoTalhao == null) {
        _error = 'Erro ao criar talhão. Tente novamente.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      _talhoes.insert(0, novoTalhao);
      _successMessage = 'Talhão "${novoTalhao.nome}" criado com sucesso!';
      
      _isLoading = false;
      notifyListeners();
      return true;
      
    } catch (e) {
      _error = e.toString();
      print('❌ Erro ao criar talhão: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Atualizar talhão
  Future<bool> update(TalhaoModel talhao) async {
    if (_isLoading) return false;

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final updatedTalhao = await _service.update(talhao);
      
      if (updatedTalhao == null) {
        _error = 'Erro ao atualizar talhão. Tente novamente.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      final index = _talhoes.indexWhere((t) => t.id == talhao.id);
      if (index != -1) {
        _talhoes[index] = updatedTalhao;
      }
      
      _successMessage = 'Talhão "${updatedTalhao.nome}" atualizado com sucesso!';
      
      _isLoading = false;
      notifyListeners();
      return true;
      
    } catch (e) {
      _error = e.toString();
      print('❌ Erro ao atualizar talhão: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Deletar talhão
  Future<bool> delete(String id) async {
    if (_isLoading) return false;

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final talhaoNome = _talhoes.firstWhere((t) => t.id == id).nome;
      
      final success = await _service.delete(id);
      
      if (!success) {
        _error = 'Erro ao deletar talhão. Tente novamente.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      _talhoes.removeWhere((t) => t.id == id);
      _successMessage = 'Talhão "$talhaoNome" excluído com sucesso!';
      
      _isLoading = false;
      notifyListeners();
      return true;
      
    } catch (e) {
      _error = e.toString();
      print('❌ Erro ao deletar talhão: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Limpar estado
  void clear() {
    _talhoes = [];
    _isLoading = false;
    _error = null;
    _successMessage = null;
    notifyListeners();
  }

  // Resetar mensagens
  void resetMessages() {
    _error = null;
    _successMessage = null;
    notifyListeners();
  }
}