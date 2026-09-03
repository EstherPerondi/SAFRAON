import 'package:flutter/material.dart';
import '../models/fazenda_model.dart';
import '../services/fazenda_service.dart';
import '../services/supabase_service.dart';

class FazendaProvider extends ChangeNotifier {
  final FazendaService _service = FazendaService();
  List<FazendaModel> _fazendas = [];
  bool _isLoading = false;
  String? _error;

  List<FazendaModel> get fazendas => _fazendas;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Carregar fazendas do usuário
  Future<void> loadUserFazendas() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _fazendas = await _service.getAll();
      print('✅ Fazendas carregadas: ${_fazendas.length}');
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
    _isLoading = true;
    notifyListeners();

    try {
      final userId = SupabaseService().currentUserId;
      print('📝 Criando fazenda: ${fazenda.nome}');
      print('📝 UserId: $userId');

      if (userId.isEmpty) {
        throw Exception('Usuário não está logado!');
      }

      final novaFazenda = FazendaModel(
        id: '',
        nome: fazenda.nome,
        area: fazenda.area,
        userId: userId,
      );

      final result = await _service.create(novaFazenda);

      if (result != null) {
        print('✅ Fazenda criada: ${result.id}');
        _fazendas.insert(0, result);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
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
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.update(fazenda);

      if (result != null) {
        final index = _fazendas.indexWhere((f) => f.id == fazenda.id);
        if (index != -1) {
          _fazendas[index] = result;
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
      print('❌ Erro ao atualizar fazenda: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Deletar fazenda
  Future<bool> delete(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      final result = await _service.delete(id);

      if (result) {
        _fazendas.removeWhere((f) => f.id == id);
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _error = e.toString();
      print('❌ Erro ao deletar fazenda: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clear() {
    _fazendas = [];
    _isLoading = false;
    _error = null;
    notifyListeners();
  }
}