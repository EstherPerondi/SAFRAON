import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/fazenda_model.dart';
import 'supabase_service.dart';

class FazendaService {
  final SupabaseClient _client = SupabaseService().client;
  final String _table = 'fazendas';

  // Buscar todas as fazendas do usuário
  Future<List<FazendaModel>> getAll() async {
    try {
      final userId = SupabaseService().currentUserId;
      print('📊 Buscando fazendas para user: $userId');

      final response = await _client
          .from(_table)
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      print('📊 Resposta: $response');

      return response.map<FazendaModel>((json) {
        return FazendaModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('❌ Erro ao buscar fazendas: $e');
      return [];
    }
  }

  // Buscar uma fazenda por ID
  Future<FazendaModel?> getById(String id) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('id', id)
          .single();

      return FazendaModel.fromJson(response);
    } catch (e) {
      print('❌ Erro ao buscar fazenda: $e');
      return null;
    }
  }

  // Criar nova fazenda
  Future<FazendaModel?> create(FazendaModel fazenda) async {
    try {
      print('📤 Enviando dados: ${fazenda.toJson()}');

      final response = await _client
          .from(_table)
          .insert(fazenda.toJson())
          .select()
          .single();

      print('📥 Resposta: $response');

      return FazendaModel.fromJson(response);
    } catch (e) {
      print('❌ Erro ao criar fazenda: $e');
      print('❌ Detalhes: ${e.toString()}');
      return null;
    }
  }

  // Atualizar fazenda
  Future<FazendaModel?> update(FazendaModel fazenda) async {
    try {
      final response = await _client
          .from(_table)
          .update(fazenda.toJson())
          .eq('id', fazenda.id)
          .select()
          .single();

      return FazendaModel.fromJson(response);
    } catch (e) {
      print('❌ Erro ao atualizar fazenda: $e');
      return null;
    }
  }

  // Deletar fazenda
  Future<bool> delete(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
      return true;
    } catch (e) {
      print('❌ Erro ao deletar fazenda: $e');
      return false;
    }
  }
}