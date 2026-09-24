import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/precipitacao_model.dart';
import 'supabase_service.dart';
import 'delete_helper.dart';

class PrecipitacaoService {
  final SupabaseClient _client = SupabaseService().client;
  final String _table = 'clima_dia';
  static const _selectComNome = '''
    *,
    talhao ( nome, fazenda ( nome ) )
  ''';

  Future<List<PrecipitacaoModel>> getByTalhaoId(String talhaoId) async {
    try {
      final response = await _client
          .from(_table)
          .select(_selectComNome)
          .eq('talhao_id', talhaoId)
          .eq('fonte', 'manual')
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
            talhao!inner (
              nome,
              fazenda_id,
              fazenda!inner (
                nome,
                usuario_id
              )
            )
          ''')
          .eq('talhao.fazenda.usuario_id', SupabaseService().currentUserId)
          .eq('fonte', 'manual')
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
          .select(_selectComNome)
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
          .select(_selectComNome)
          .single();

      return PrecipitacaoModel.fromJson(response);
    } catch (e) {
      print('Erro ao atualizar precipitação: $e');
      return null;
    }
  }

  Future<bool> delete(String id) async {
    await deletarPorId(_client, _table, id, nomeItem: 'registro de precipitação');
    return true;
  }
}