import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/manejo_model.dart';
import 'supabase_service.dart';

class ManejoService {
  final SupabaseClient _client = SupabaseService().client;
  final String _table = 'manejos';

  Future<List<ManejoModel>> getByTalhaoId(String talhaoId) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('talhao_id', talhaoId)
          .order('data', ascending: false);

      return response.map<ManejoModel>((json) {
        return ManejoModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Erro ao buscar manejos: $e');
      return [];
    }
  }

  Future<List<ManejoModel>> getAllForUser() async {
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

      return response.map<ManejoModel>((json) {
        return ManejoModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Erro ao buscar manejos: $e');
      return [];
    }
  }

  Future<ManejoModel?> create(ManejoModel manejo) async {
    try {
      final response = await _client
          .from(_table)
          .insert(manejo.toJson())
          .select()
          .single();

      return ManejoModel.fromJson(response);
    } catch (e) {
      print('Erro ao criar manejo: $e');
      return null;
    }
  }

  Future<ManejoModel?> update(ManejoModel manejo) async {
    try {
      final response = await _client
          .from(_table)
          .update(manejo.toJson())
          .eq('id', manejo.id)
          .select()
          .single();

      return ManejoModel.fromJson(response);
    } catch (e) {
      print('Erro ao atualizar manejo: $e');
      return null;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
      return true;
    } catch (e) {
      print('Erro ao deletar manejo: $e');
      return false;
    }
  }
}