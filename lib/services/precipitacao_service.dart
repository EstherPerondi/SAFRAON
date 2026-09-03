import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/precipitacao_model.dart';
import 'supabase_service.dart';

class PrecipitacaoService {
  final SupabaseClient _client = SupabaseService().client;
  final String _table = 'precipitacoes';

  Future<List<PrecipitacaoModel>> getByTalhaoId(String talhaoId) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('talhao_id', talhaoId)
          .order('data', ascending: false);

      return response.map<PrecipitacaoModel>((json) {
        return PrecipitacaoModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Erro ao buscar precipitações: $e');
      return [];
    }
  }

  Future<List<PrecipitacaoModel>> getAllForUser() async {
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

      return response.map<PrecipitacaoModel>((json) {
        return PrecipitacaoModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Erro ao buscar precipitações: $e');
      return [];
    }
  }

  Future<PrecipitacaoModel?> create(PrecipitacaoModel precipitacao) async {
    try {
      final response = await _client
          .from(_table)
          .insert(precipitacao.toJson())
          .select()
          .single();

      return PrecipitacaoModel.fromJson(response);
    } catch (e) {
      print('Erro ao criar precipitação: $e');
      return null;
    }
  }

  Future<PrecipitacaoModel?> update(PrecipitacaoModel precipitacao) async {
    try {
      final response = await _client
          .from(_table)
          .update(precipitacao.toJson())
          .eq('id', precipitacao.id)
          .select()
          .single();

      return PrecipitacaoModel.fromJson(response);
    } catch (e) {
      print('Erro ao atualizar precipitação: $e');
      return null;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
      return true;
    } catch (e) {
      print('Erro ao deletar precipitação: $e');
      return false;
    }
  }
}