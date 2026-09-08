// lib/providers/fazenda_provider.dart
import 'package:flutter/material.dart';
import '../models/fazenda_model.dart';
import '../services/fazenda_service.dart';
import '../services/supabase_service.dart';

class FazendaProvider extends ChangeNotifier {
  final FazendaService _service = FazendaService();
  
  List<FazendaModel> _fazendas = [];
  bool _isLoading = false;
  String? _error;
  String? _successMessage;

  // Getters
  List<FazendaModel> get fazendas => _fazendas;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get successMessage => _successMessage;
  bool get hasFazendas => _fazendas.isNotEmpty;

  // Carregar fazendas do usuário
  Future<void> loadUserFazendas() async {
    if (_isLoading) return;

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      _fazendas = await _service.getAll();
      print('✅ ${_fazendas.length} fazendas carregadas');
      _successMessage = 'Fazendas carregadas com sucesso';
    } catch (e) {
      _error = e.toString();
      print('❌ Erro ao carregar fazendas: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Criar fazenda
  Future<bool> create(FazendaModel fazenda) async {
    if (_isLoading) return false;

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      // Verificar se já existe fazenda com mesmo nome
      final exists = await _service.existsWithName(fazenda.nome);
      if (exists) {
        _error = 'Já existe uma fazenda com este nome';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final novaFazenda = await _service.create(fazenda);
      
      if (novaFazenda == null) {
        _error = 'Erro ao criar fazenda. Tente novamente.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      _fazendas.insert(0, novaFazenda);
      _successMessage = 'Fazenda "${novaFazenda.nome}" criada com sucesso!';
      
      _isLoading = false;
      notifyListeners();
      return true;
      
    } catch (e) {
      _error = e.toString();
      print('❌ Erro ao criar fazenda: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Atualizar fazenda
  Future<bool> update(FazendaModel fazenda) async {
    if (_isLoading) return false;

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final updatedFazenda = await _service.update(fazenda);
      
      if (updatedFazenda == null) {
        _error = 'Erro ao atualizar fazenda. Tente novamente.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      final index = _fazendas.indexWhere((f) => f.id == fazenda.id);
      if (index != -1) {
        _fazendas[index] = updatedFazenda;
      }
      
      _successMessage = 'Fazenda "${updatedFazenda.nome}" atualizada com sucesso!';
      
      _isLoading = false;
      notifyListeners();
      return true;
      
    } catch (e) {
      _error = e.toString();
      print('❌ Erro ao atualizar fazenda: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Deletar fazenda
  Future<bool> delete(String id) async {
    if (_isLoading) return false;

    _isLoading = true;
    _error = null;
    _successMessage = null;
    notifyListeners();

    try {
      final fazendaNome = _fazendas.firstWhere((f) => f.id == id).nome;
      
      final success = await _service.delete(id);
      
      if (!success) {
        _error = 'Erro ao deletar fazenda. Tente novamente.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      
      _fazendas.removeWhere((f) => f.id == id);
      _successMessage = 'Fazenda "$fazendaNome" excluída com sucesso!';
      
      _isLoading = false;
      notifyListeners();
      return true;
      
    } catch (e) {
      _error = e.toString();
      print('❌ Erro ao deletar fazenda: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Limpar estado
  void clear() {
    _fazendas = [];
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