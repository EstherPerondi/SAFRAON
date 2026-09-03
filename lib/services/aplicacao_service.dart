import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/aplicacao_model.dart';
import 'supabase_service.dart';

class AplicacaoService {
  final SupabaseClient _client = SupabaseService().client;
  final String _table = 'aplicacoes';

  // Buscar aplicações de um talhão
  Future<List<AplicacaoModel>> getByTalhaoId(String talhaoId) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('talhao_id', talhaoId)
          .order('data', ascending: false);

      return response.map<AplicacaoModel>((json) {
        return AplicacaoModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Erro ao buscar aplicações: $e');
      return [];
    }
  }

  // Buscar todas as aplicações do usuário
  Future<List<AplicacaoModel>> getAllForUser() async {
    try {
      final response = await _client
          .from(_table)
          .select('''
            *,
            talhoes!inner (
              fazenda_id,
              fazendas!inner (
                user_id
              )
            )
          ''')
          .eq('talhoes.fazendas.user_id', SupabaseService().currentUserId)
          .order('data', ascending: false);

      return response.map<AplicacaoModel>((json) {
        return AplicacaoModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Erro ao buscar aplicações: $e');
      return [];
    }
  }

  // Criar aplicação
  Future<AplicacaoModel?> create(AplicacaoModel aplicacao) async {
    try {
      final response = await _client
          .from(_table)
          .insert(aplicacao.toJson())
          .select()
          .single();

      return AplicacaoModel.fromJson(response);
    } catch (e) {
      print('Erro ao criar aplicação: $e');
      return null;
    }
  }

  // Atualizar aplicação
  Future<AplicacaoModel?> update(AplicacaoModel aplicacao) async {
    try {
      final response = await _client
          .from(_table)
          .update(aplicacao.toJson())
          .eq('id', aplicacao.id)
          .select()
          .single();

      return AplicacaoModel.fromJson(response);
    } catch (e) {
      print('Erro ao atualizar aplicação: $e');
      return null;
    }
  }

  // Deletar aplicação
  Future<bool> delete(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
      return true;
    } catch (e) {
      print('Erro ao deletar aplicação: $e');
      return false;
    }
  }
}