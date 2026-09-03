import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/plantio_model.dart';
import 'supabase_service.dart';

class PlantioService {
  final SupabaseClient _client = SupabaseService().client;
  final String _table = 'plantios';

  Future<List<PlantioModel>> getByTalhaoId(String talhaoId) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('talhao_id', talhaoId)
          .order('data', ascending: false);

      return response.map<PlantioModel>((json) {
        return PlantioModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Erro ao buscar plantios: $e');
      return [];
    }
  }

  Future<List<PlantioModel>> getAllForUser() async {
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

      return response.map<PlantioModel>((json) {
        return PlantioModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('Erro ao buscar plantios: $e');
      return [];
    }
  }

  Future<PlantioModel?> create(PlantioModel plantio) async {
    try {
      final response = await _client
          .from(_table)
          .insert(plantio.toJson())
          .select()
          .single();

      return PlantioModel.fromJson(response);
    } catch (e) {
      print('Erro ao criar plantio: $e');
      return null;
    }
  }

  Future<PlantioModel?> update(PlantioModel plantio) async {
    try {
      final response = await _client
          .from(_table)
          .update(plantio.toJson())
          .eq('id', plantio.id)
          .select()
          .single();

      return PlantioModel.fromJson(response);
    } catch (e) {
      print('Erro ao atualizar plantio: $e');
      return null;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _client.from(_table).delete().eq('id', id);
      return true;
    } catch (e) {
      print('Erro ao deletar plantio: $e');
      return false;
    }
  }
}