import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/talhao_model.dart';
import 'supabase_service.dart';

class TalhaoService {
  final SupabaseClient _client = SupabaseService().client;
  final String _table = 'talhoes';

  // Buscar todos os talhões do usuário
  Future<List<TalhaoModel>> getAll() async {
    try {
      final response = await _client
          .from(_table)
          .select('''
            *,
            fazendas!inner (
              user_id
            )
          ''')
          .eq('fazendas.user_id', SupabaseService().currentUserId)
          .order('created_at', ascending: false);

      return response.map<TalhaoModel>((json) {
        return TalhaoModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Erro ao buscar talhões: $e');
      return [];
    }
  }

  // Buscar talhões de uma fazenda específica
  Future<List<TalhaoModel>> getByFazendaId(String fazendaId) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('fazenda_id', fazendaId)
          .order('created_at', ascending: false);

      return response.map<TalhaoModel>((json) {
        return TalhaoModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Erro ao buscar talhões da fazenda: $e');
      return [];
    }
  }

  // Buscar um talhão por ID
  Future<TalhaoModel?> getById(String id) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('id', id)
          .single();

      return TalhaoModel.fromJson(response);
    } catch (e) {
      print('Erro ao buscar talhão: $e');
      return null;
    }
  }

  // Criar novo talhão
  Future<TalhaoModel?> create(TalhaoModel talhao) async {
    try {
      final response = await _client
          .from(_table)
          .insert(talhao.toJson())
          .select()
          .single();

      return TalhaoModel.fromJson(response);
    } catch (e) {
      print('Erro ao criar talhão: $e');
      return null;
    }
  }

  // Atualizar talhão
  Future<TalhaoModel?> update(TalhaoModel talhao) async {
    try {
      final response = await _client
          .from(_table)
          .update(talhao.toJson())
          .eq('id', talhao.id)
          .select()
          .single();

      return TalhaoModel.fromJson(response);
    } catch (e) {
      print('Erro ao atualizar talhão: $e');
      return null;
    }
  }

  // Deletar talhão
  Future<bool> delete(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
      return true;
    } catch (e) {
      print('Erro ao deletar talhão: $e');
      return false;
    }
  }
}