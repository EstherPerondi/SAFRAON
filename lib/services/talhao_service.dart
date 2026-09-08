// lib/services/talhao_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/talhao_model.dart';
import 'supabase_service.dart';

class TalhaoService {
  final SupabaseClient _client = SupabaseService().client;
  final String _table = 'talhoes';

  // ============================================
  // ✅ ADICIONAR ESTE MÉTODO
  // ============================================
  Future<List<TalhaoModel>> getAll() async {
    try {
      final userId = SupabaseService().currentUserId;
      print('📊 Buscando todos os talhões para user: $userId');

      final response = await _client
          .from(_table)
          .select()
          .eq('user_id', userId)
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
      final userId = SupabaseService().currentUserId;
      print('📊 Buscando talhões para fazenda: $fazendaId');

      final response = await _client
          .from(_table)
          .select()
          .eq('fazenda_id', fazendaId)
          .eq('user_id', userId)
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
      final userId = SupabaseService().currentUserId;
      
      if (userId.isEmpty) {
        throw Exception('Usuário não autenticado');
      }

      final data = {
        'nome': talhao.nome.trim(),
        'cidade': talhao.cidade.trim(),
        'fazenda_id': talhao.fazendaId,
        'user_id': userId,
      };

      print('📤 Criando talhão:');
      print('  - Nome: ${data['nome']}');
      print('  - Cidade: ${data['cidade']}');
      print('  - Fazenda ID: ${data['fazenda_id']}');

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
      };

      print('📤 Atualizando talhão: ${talhao.id}');
      print('  - Nome: ${data['nome']}');
      print('  - Cidade: ${data['cidade']}');

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

      await _client
          .from(_table)
          .delete()
          .eq('id', id);

      print('✅ Talhão deletado com sucesso!');
      return true;
    } catch (e) {
      print('❌ Erro ao deletar talhão: $e');
      return false;
    }
  }
}