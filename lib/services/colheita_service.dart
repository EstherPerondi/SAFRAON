import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/colheita_model.dart';
import 'supabase_service.dart';

class ColheitaService {
  final SupabaseClient _client = SupabaseService().client;
  final String _table = 'colheita';

  Future<List<ColheitaModel>> getByTalhaoId(String talhaoId) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('talhao_id', talhaoId)
          .order('datacolheita', ascending: false);

      return response.map<ColheitaModel>((json) {
        return ColheitaModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Erro ao buscar colheitas: $e');
      return [];
    }
  }

  Future<List<ColheitaModel>> getAllForUser() async {
    try {
      final response = await _client
          .from(_table)
          .select('''
            *,
            talhao!inner (
              fazenda_id,
              fazenda!inner (
                usuario_id
              )
            )
          ''')
          .eq('talhao.fazenda.usuario_id', SupabaseService().currentUserId)
          .order('datacolheita', ascending: false);

      return response.map<ColheitaModel>((json) {
        return ColheitaModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Erro ao buscar colheitas: $e');
      return [];
    }
  }

  Future<ColheitaModel?> create(ColheitaModel colheita) async {
    try {
      final response = await _client
          .from(_table)
          .insert(colheita.toJson())
          .select()
          .single();

      return ColheitaModel.fromJson(response);
    } catch (e) {
      print('Erro ao criar colheita: $e');
      return null;
    }
  }

  Future<ColheitaModel?> update(ColheitaModel colheita) async {
    try {
      final response = await _client
          .from(_table)
          .update(colheita.toJson())
          .eq('id', colheita.id)
          .select()
          .single();

      return ColheitaModel.fromJson(response);
    } catch (e) {
      print('Erro ao atualizar colheita: $e');
      return null;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
      return true;
    } catch (e) {
      print('Erro ao deletar colheita: $e');
      return false;
    }
  }
}