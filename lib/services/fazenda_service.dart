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
      print('📊 Buscando fazendas para user: $userId');

      final response = await _client
          .from(_table)
          .select()
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

      // 1. VERIFICAR AUTENTICAÇÃO
      final supabase = SupabaseService();
      print('🔐 Verificando autenticação...');
      print('🔐 Usuário logado: ${supabase.isAuthenticated}');
      
      // 2. OBTER USER ID
      final userId = supabase.currentUserId;
      print('🆔 User ID obtido: "$userId"');
      
      if (userId.isEmpty) {
        print('❌ ERRO: User ID está vazio!');
        throw Exception('Usuário não autenticado. Faça login primeiro.');
      }

      // 3. VALIDAR DADOS
      print('📝 Validando dados...');
      print('📝 Nome: "${fazenda.nome}"');
      
      if (fazenda.nome.trim().isEmpty) {
        throw Exception('Nome da fazenda não pode estar vazio');
      }

      // 4. PREPARAR DADOS PARA ENVIO
      final data = {
        'nome': fazenda.nome.trim(),
        'usuario_id': userId,
      };
      
      print('📤 Dados a serem enviados:');
      print('  - nome: ${data['nome']}');
      print('  - usuario_id: ${data['usuario_id']}');
      print('  - usuario_id type: ${data['usuario_id'].runtimeType}');

      // 5. TENTAR INSERIR
      print('📤 Enviando para Supabase...');
      
      final response = await _client
          .from(_table)
          .insert(data)
          .select()
          .single();

      print('✅ SUCESSO! Fazenda criada:');
      print('  - ID: ${response['id']}');
      print('  - Nome: ${response['nome']}');
      print('  - Resposta completa: $response');
      print('========================================');

      return FazendaModel.fromJson(response);
      
    } on PostgrestException catch (e) {
      print('========================================');
      print('❌ ERRO POSTGRESQL:');
      print('  - Código: ${e.code}');
      print('  - Mensagem: ${e.message}');
      print('  - Detalhes: ${e.details}');
      print('  - Dica: ${e.hint}');
      print('========================================');
      return null;
      
    } catch (e) {
      print('========================================');
      print('❌ ERRO GERAL:');
      print('  - Tipo: ${e.runtimeType}');
      print('  - Mensagem: $e');
      print('========================================');
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
      };

      print('📤 Atualizando fazenda: ${fazenda.id}');
      print('  - Nome: ${data['nome']}');

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

      await _client
          .from(_table)
          .delete()
          .eq('id', id);

      print('✅ Fazenda deletada com sucesso!');
      return true;
    } catch (e) {
      print('❌ Erro ao deletar fazenda: $e');
      return false;
    }
  }

  // Verificar se existe fazenda com mesmo nome
  Future<bool> existsWithName(String nome) async {
    try {
      final userId = SupabaseService().currentUserId;
      final response = await _client
          .from(_table)
          .select('id')
          .eq('nome', nome.trim())
          .eq('usuario_id', userId);

      return response.isNotEmpty;
    } catch (e) {
      print('❌ Erro ao verificar nome: $e');
      return false;
    }
  }
}