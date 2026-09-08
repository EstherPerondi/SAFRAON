// lib/services/talhao_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/talhao_model.dart';
import 'supabase_service.dart';

class TalhaoService {
  final SupabaseClient _client = SupabaseService().client;
  final String _table = 'talhao';

  // Buscar todos os talhões do usuário (via fazenda.usuario_id, pois
  // a tabela talhao não tem coluna de usuário própria)
  Future<List<TalhaoModel>> getAll() async {
    try {
      final userId = SupabaseService().currentUserId;
      print('📊 Buscando todos os talhões para usuario_id: $userId');

      final response = await _client
          .from(_table)
          .select('*, fazenda!inner(usuario_id)')
          .eq('fazenda.usuario_id', userId)
          .order('created_at', ascending: false);

      print('✅ ${response.length} talhões encontrados');

      return response.map<TalhaoModel>((json) {
        return TalhaoModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('❌ Erro ao buscar talhões: $e');
      return [];
    }
  }

  // Buscar talhões por fazenda
  Future<List<TalhaoModel>> getByFazenda(String fazendaId) async {
    try {
      print('📊 Buscando talhões para fazenda: $fazendaId');

      final response = await _client
          .from(_table)
          .select()
          .eq('fazenda_id', fazendaId)
          .order('created_at', ascending: false);

      print('✅ ${response.length} talhões encontrados');

      return response.map<TalhaoModel>((json) {
        return TalhaoModel.fromJson(json);
      }).toList();
    } catch (e) {
      print('❌ Erro ao buscar talhões: $e');
      return [];
    }
  }

  // Buscar talhão por ID
  Future<TalhaoModel?> getById(String id) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('id', id)
          .single();

      return TalhaoModel.fromJson(response);
    } catch (e) {
      print('❌ Erro ao buscar talhão: $e');
      return null;
    }
  }

  // Criar talhão
  Future<TalhaoModel?> create(TalhaoModel talhao) async {
    try {
      final data = {
        'nome': talhao.nome.trim(),
        'cidade': talhao.cidade.trim(),
        'fazenda_id': talhao.fazendaId,
        'latitude': talhao.latitude,
        'longitude': talhao.longitude,
      };

      print('📤 Criando talhão: $data');

      final response = await _client
          .from(_table)
          .insert(data)
          .select()
          .single();

      print('✅ Talhão criado com sucesso! ID: ${response['id']}');

      return TalhaoModel.fromJson(response);
    } catch (e) {
      print('❌ Erro ao criar talhão: $e');
      if (e is PostgrestException) {
        print('  - Código: ${e.code}');
        print('  - Mensagem: ${e.message}');
        print('  - Detalhes: ${e.details}');
      }
      return null;
    }
  }

  // Atualizar talhão
  Future<TalhaoModel?> update(TalhaoModel talhao) async {
    try {
      if (talhao.id.isEmpty) {
        throw Exception('ID do talhão não informado');
      }

      final data = {
        'nome': talhao.nome.trim(),
        'cidade': talhao.cidade.trim(),
        'latitude': talhao.latitude,
        'longitude': talhao.longitude,
      };

      print('📤 Atualizando talhão: ${talhao.id} -> $data');

      final response = await _client
          .from(_table)
          .update(data)
          .eq('id', talhao.id)
          .select()
          .single();

      print('✅ Talhão atualizado com sucesso!');

      return TalhaoModel.fromJson(response);
    } catch (e) {
      print('❌ Erro ao atualizar talhão: $e');
      return null;
    }
  }

  // Deletar talhão
  Future<bool> delete(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('ID do talhão não informado');
      }

      print('🗑️ Deletando talhão: $id');

      await _client.from(_table).delete().eq('id', id);

      print('✅ Talhão deletado com sucesso!');
      return true;
    } catch (e) {
      print('❌ Erro ao deletar talhão: $e');
      return false;
    }
  }
}