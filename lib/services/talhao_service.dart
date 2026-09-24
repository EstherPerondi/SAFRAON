// lib/services/talhao_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/talhao_model.dart';
import 'supabase_service.dart';
import 'delete_helper.dart';

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

      final talhaoCriado = TalhaoModel.fromJson(response);

      // Geocodifica a cidade em segundo plano (não bloqueia o cadastro
      // caso a function/API falhe)
      return await _geocodificarEBuscar(talhaoCriado);
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

      final talhaoAtualizado = TalhaoModel.fromJson(response);

      return await _geocodificarEBuscar(talhaoAtualizado);
    } catch (e) {
      print('❌ Erro ao atualizar talhão: $e');
      return null;
    }
  }

  // Chama a Edge Function 'geocodificar-talhao' (que usa a API do
  // OpenWeather para converter a cidade em latitude/longitude e já
  // salva isso no banco) e retorna o talhão atualizado com as
  // coordenadas novas. Se a geocodificação falhar, não quebra o
  // fluxo — apenas retorna o talhão como estava antes.
  Future<TalhaoModel?> _geocodificarEBuscar(TalhaoModel talhao) async {
    try {
      print('🌍 Geocodificando talhão ${talhao.id} (${talhao.cidade})...');

      final result = await _client.functions.invoke(
        'geocodificar-talhao',
        body: {'talhao_id': talhao.id},
      );

      if (result.status != 200) {
        print('⚠️ Geocodificação retornou status ${result.status}: ${result.data}');
        return talhao;
      }

      print('✅ Geocodificação concluída: ${result.data}');

      // Dispara a atualização do clima/previsão em segundo plano, sem
      // aguardar (não bloqueia o cadastro). A atualização diária continua
      // acontecendo sozinha via pg_cron; isso aqui só serve para o talhão
      // recém-criado já aparecer com dados na hora, sem precisar esperar
      // o próximo agendamento.
      _atualizarClimaEmSegundoPlano();

      // Busca o talhão de novo para trazer lat/lon já atualizados
      return await getById(talhao.id) ?? talhao;
    } catch (e) {
      print('⚠️ Não foi possível geocodificar o talhão (seguindo sem coordenadas): $e');
      return talhao;
    }
  }

  // Dispara a atualização de clima e previsão sem aguardar o resultado
  // (fire-and-forget). Erros aqui não devem quebrar o fluxo de
  // cadastro/edição do talhão — por isso só logamos, sem lançar exceção.
  void _atualizarClimaEmSegundoPlano() {
    _client.functions.invoke('atualizar-clima').catchError((e) {
      print('⚠️ Falha ao atualizar clima em segundo plano: $e');
      return null;
    });
    _client.functions.invoke('atualizar-previsao').catchError((e) {
      print('⚠️ Falha ao atualizar previsão em segundo plano: $e');
      return null;
    });
  }

  // Deletar talhão
  Future<bool> delete(String id) async {
    if (id.isEmpty) {
      throw Exception('ID do talhão não informado');
    }

    print('🗑️ Deletando talhão: $id');

    // Remove os registros vinculados (aplicações, plantios, etc.)
    await deletarFilhosDosTalhoes(_client, [id]);
    await deletarPorId(_client, _table, id, nomeItem: 'talhão');

    print('✅ Talhão deletado com sucesso!');
    return true;
  }
}