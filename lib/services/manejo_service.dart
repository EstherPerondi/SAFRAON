import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/manejo_model.dart';
import 'supabase_service.dart';

class ManejoService {
  final SupabaseClient _client = SupabaseService().client;
  final String _table = 'manejo';
  static const _selectComNome = '*, tipo_manejo ( tipo_de_manejo )';

  Future<List<ManejoModel>> getByTalhaoId(String talhaoId) async {
    try {
      final response = await _client
          .from(_table)
          .select(_selectComNome)
          .eq('talhao_id', talhaoId)
          .order('datadomanejo', ascending: false);

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
            tipo_manejo ( tipo_de_manejo ),
            talhao!inner (
              fazenda_id,
              fazenda!inner (
                usuario_id
              )
            )
          ''')
          .eq('talhao.fazenda.usuario_id', SupabaseService().currentUserId)
          .order('datadomanejo', ascending: false);

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
          .select(_selectComNome)
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
          .select(_selectComNome)
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