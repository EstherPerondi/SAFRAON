// lib/services/fazenda_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/fazenda_model.dart';
import 'supabase_service.dart';

class FazendaService {
  final SupabaseClient _client = SupabaseService().client;
  final String _table = 'fazenda';

  // Buscar todas as fazendas do usuário
  Future<List<FazendaModel>> getAll() async {
    try {
      final userId = SupabaseService().currentUserId;
      print('📊 Buscando fazendas para usuario_id: $userId');

      final response = await _client
          .from(_table)
          .select()
          .eq('usuario_id', userId)
          .order('created_at', ascending: false);

      print('✅ ${response.length} fazendas encontradas');

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

  // Criar nova fazenda - COM LOGS DETALHADOS
  Future<FazendaModel?> create(FazendaModel fazenda) async {
    try {
      print('========================================');
      print('🚀 INICIANDO CRIAÇÃO DE FAZENDA');
      print('========================================');

      final supabase = SupabaseService();
      print('🔐 Usuário logado: ${supabase.isAuthenticated}');

      final usuarioId = supabase.currentUserId;
      print('🆔 usuario_id obtido: "$usuarioId"');

      if (usuarioId.isEmpty) {
        print('❌ ERRO: usuario_id está vazio!');
        throw Exception('Usuário não autenticado. Faça login primeiro.');
      }

      print('📝 Validando dados...');
      print('📝 Nome: "${fazenda.nome}"');
      print('📝 estado_id: "${fazenda.estadoId}"');

      if (fazenda.nome.trim().isEmpty) {
        throw Exception('Nome da fazenda não pode estar vazio');
      }
      if (fazenda.estadoId.trim().isEmpty) {
        throw Exception('Estado da fazenda não pode estar vazio');
      }

      final data = {
        'nome': fazenda.nome.trim(),
        'estado_id': fazenda.estadoId.trim(),
        'usuario_id': usuarioId,
      };

      print('📤 Dados a serem enviados: $data');

      final response = await _client
          .from(_table)
          .insert(data)
          .select()
          .single();

      print('✅ SUCESSO! Fazenda criada: ${response['id']}');
      print('========================================');

      return FazendaModel.fromJson(response);
    } on PostgrestException catch (e) {
      print('❌ ERRO POSTGRESQL: ${e.code} | ${e.message} | ${e.details}');
      return null;
    } catch (e) {
      print('❌ ERRO GERAL: $e');
      return null;
    }
  }

  // Atualizar fazenda
  Future<FazendaModel?> update(FazendaModel fazenda) async {
    try {
      if (fazenda.id.isEmpty) {
        throw Exception('ID da fazenda não informado');
      }

      final data = {
        'nome': fazenda.nome.trim(),
        'estado_id': fazenda.estadoId.trim(),
      };

      print('📤 Atualizando fazenda: ${fazenda.id} -> $data');

      final response = await _client
          .from(_table)
          .update(data)
          .eq('id', fazenda.id)
          .select()
          .single();

      print('✅ Fazenda atualizada com sucesso!');

      return FazendaModel.fromJson(response);
    } catch (e) {
      print('❌ Erro ao atualizar fazenda: $e');
      return null;
    }
  }

  // Deletar fazenda
  Future<bool> delete(String id) async {
    try {
      if (id.isEmpty) {
        throw Exception('ID da fazenda não informado');
      }

      print('🗑️ Deletando fazenda: $id');

      await _client.from(_table).delete().eq('id', id);

      print('✅ Fazenda deletada com sucesso!');
      return true;
    } catch (e) {
      print('❌ Erro ao deletar fazenda: $e');
      return false;
    }
  }

  // Verificar se existe fazenda com mesmo nome (para o usuário atual)
  Future<bool> existsWithName(String nome) async {
    try {
      final usuarioId = SupabaseService().currentUserId;
      final response = await _client
          .from(_table)
          .select('id')
          .eq('nome', nome.trim())
          .eq('usuario_id', usuarioId);

      return response.isNotEmpty;
    } catch (e) {
      print('❌ Erro ao verificar nome: $e');
      return false;
    }
  }
}