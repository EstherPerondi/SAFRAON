// lib/services/lookup_service.dart
//
// Serviço genérico para buscar as tabelas de "lookup" (listas de opção)
// usadas nos dropdowns de Plantio, Manejo, Aplicação e Colheita:
// cultura, variedade, adubo, inoculante, defensivo e tipo_manejo.
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class LookupItem {
  final String id;
  final String nome;
  final String? culturaId; // usado só por variedade, pra filtrar pela cultura

  // Colunas nullable no banco (não exigidas no cadastro rápido, mas
  // mantidas no modelo para refletir o schema real de cada tabela).
  final String? fabricante; // adubo, variedade, inoculante, defensivo
  final String? principioAtivo; // defensivo
  final String? utilidade; // defensivo
  final double? dosagemRecomendada; // inoculante

  LookupItem({
    required this.id,
    required this.nome,
    this.culturaId,
    this.fabricante,
    this.principioAtivo,
    this.utilidade,
    this.dosagemRecomendada,
  });
}

class LookupService {
  final SupabaseClient _client = SupabaseService().client;

  Future<List<LookupItem>> getCulturas() async {
    try {
      final res = await _client
          .from('cultura')
          .select('id, plantacultivada')
          .order('plantacultivada');
      return res
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['plantacultivada']?.toString() ?? '',
              ))
          .toList();
    } catch (e) {
      print('Erro ao buscar culturas: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getVariedades({String? culturaId}) async {
    try {
      var query = _client
          .from('variedade')
          .select('id, nomedavariedade, cultura_id, fabricante');
      final res = culturaId != null
          ? await query.eq('cultura_id', culturaId).order('nomedavariedade')
          : await query.order('nomedavariedade');
      return res
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nomedavariedade']?.toString() ?? '',
                culturaId: j['cultura_id']?.toString(),
                fabricante: j['fabricante']?.toString(),
              ))
          .toList();
    } catch (e) {
      print('Erro ao buscar variedades: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getAdubos() async {
    try {
      final res = await _client
          .from('adubo')
          .select('id, nomedoadubo, fabricante')
          .order('nomedoadubo');
      return res
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nomedoadubo']?.toString() ?? '',
                fabricante: j['fabricante']?.toString(),
              ))
          .toList();
    } catch (e) {
      print('Erro ao buscar adubos: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getInoculantes() async {
    try {
      final res = await _client
          .from('inoculante')
          .select('id, nomedoinoculante, dosagemrecomendada, fabricante')
          .order('nomedoinoculante');
      return res
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nomedoinoculante']?.toString() ?? '',
                fabricante: j['fabricante']?.toString(),
                dosagemRecomendada: j['dosagemrecomendada'] == null
                    ? null
                    : double.tryParse(j['dosagemrecomendada'].toString()),
              ))
          .toList();
    } catch (e) {
      print('Erro ao buscar inoculantes: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getDefensivos() async {
    try {
      final res = await _client
          .from('defensivo')
          .select('id, nome, principioativo, fabricante, utilidade')
          .order('nome');
      return res
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nome']?.toString() ?? '',
                principioAtivo: j['principioativo']?.toString(),
                fabricante: j['fabricante']?.toString(),
                utilidade: j['utilidade']?.toString(),
              ))
          .toList();
    } catch (e) {
      print('Erro ao buscar defensivos: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getEstados() async {
    try {
      final res = await _client.from('estados').select('id, nome').order('nome');
      return res
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nome']?.toString() ?? '',
              ))
          .toList();
    } catch (e) {
      print('Erro ao buscar estados: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getTiposManejo() async {
    try {
      final res = await _client
          .from('tipo_manejo')
          .select('id, tipo_de_manejo')
          .order('tipo_de_manejo');
      return res
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['tipo_de_manejo']?.toString() ?? '',
              ))
          .toList();
    } catch (e) {
      print('Erro ao buscar tipos de manejo: $e');
      return [];
    }
  }

  // ============================================
  // CRIAÇÃO RÁPIDA DE ITENS ("+ Adicionar novo...")
  //
  // Usados pelos dropdowns das telas de Fazendas, Plantios, Manejos,
  // Aplicações e Colheitas para cadastrar um item de lookup sem sair
  // do formulário. Cada método insere o registro e devolve o
  // LookupItem já com o id gerado pelo banco.
  // ============================================

  Future<LookupItem> createCultura(String nome) async {
    try {
      final res = await _client
          .from('cultura')
          .insert({'plantacultivada': nome})
          .select('id, plantacultivada')
          .single();
      return LookupItem(
        id: res['id'].toString(),
        nome: res['plantacultivada']?.toString() ?? '',
      );
    } catch (e) {
      throw Exception('Erro ao criar cultura: $e');
    }
  }

  Future<LookupItem> createVariedade(
    String nome,
    String culturaId, {
    String? fabricante,
  }) async {
    try {
      final dados = <String, dynamic>{
        'nomedavariedade': nome,
        'cultura_id': culturaId,
      };
      if (fabricante != null && fabricante.trim().isNotEmpty) {
        dados['fabricante'] = fabricante.trim();
      }
      final res = await _client
          .from('variedade')
          .insert(dados)
          .select('id, nomedavariedade, cultura_id, fabricante')
          .single();
      return LookupItem(
        id: res['id'].toString(),
        nome: res['nomedavariedade']?.toString() ?? '',
        culturaId: res['cultura_id']?.toString(),
        fabricante: res['fabricante']?.toString(),
      );
    } catch (e) {
      throw Exception('Erro ao criar variedade: $e');
    }
  }

  Future<LookupItem> createAdubo(String nome, {String? fabricante}) async {
    try {
      final dados = <String, dynamic>{'nomedoadubo': nome};
      if (fabricante != null && fabricante.trim().isNotEmpty) {
        dados['fabricante'] = fabricante.trim();
      }
      final res = await _client
          .from('adubo')
          .insert(dados)
          .select('id, nomedoadubo, fabricante')
          .single();
      return LookupItem(
        id: res['id'].toString(),
        nome: res['nomedoadubo']?.toString() ?? '',
        fabricante: res['fabricante']?.toString(),
      );
    } catch (e) {
      throw Exception('Erro ao criar adubo: $e');
    }
  }

  Future<LookupItem> createInoculante(
    String nome, {
    String? fabricante,
    double? dosagemRecomendada,
  }) async {
    try {
      final dados = <String, dynamic>{'nomedoinoculante': nome};
      if (fabricante != null && fabricante.trim().isNotEmpty) {
        dados['fabricante'] = fabricante.trim();
      }
      if (dosagemRecomendada != null) {
        dados['dosagemrecomendada'] = dosagemRecomendada;
      }
      final res = await _client
          .from('inoculante')
          .insert(dados)
          .select('id, nomedoinoculante, dosagemrecomendada, fabricante')
          .single();
      return LookupItem(
        id: res['id'].toString(),
        nome: res['nomedoinoculante']?.toString() ?? '',
        fabricante: res['fabricante']?.toString(),
        dosagemRecomendada: res['dosagemrecomendada'] == null
            ? null
            : double.tryParse(res['dosagemrecomendada'].toString()),
      );
    } catch (e) {
      throw Exception('Erro ao criar inoculante: $e');
    }
  }

  Future<LookupItem> createDefensivo(
    String nome, {
    String? principioAtivo,
    String? fabricante,
    String? utilidade,
  }) async {
    try {
      final dados = <String, dynamic>{'nome': nome};
      if (principioAtivo != null && principioAtivo.trim().isNotEmpty) {
        dados['principioativo'] = principioAtivo.trim();
      }
      if (fabricante != null && fabricante.trim().isNotEmpty) {
        dados['fabricante'] = fabricante.trim();
      }
      if (utilidade != null && utilidade.trim().isNotEmpty) {
        dados['utilidade'] = utilidade.trim();
      }
      final res = await _client
          .from('defensivo')
          .insert(dados)
          .select('id, nome, principioativo, fabricante, utilidade')
          .single();
      return LookupItem(
        id: res['id'].toString(),
        nome: res['nome']?.toString() ?? '',
        principioAtivo: res['principioativo']?.toString(),
        fabricante: res['fabricante']?.toString(),
        utilidade: res['utilidade']?.toString(),
      );
    } catch (e) {
      throw Exception('Erro ao criar defensivo: $e');
    }
  }

  Future<LookupItem> createEstado(String nome) async {
    try {
      final res = await _client
          .from('estados')
          .insert({'nome': nome})
          .select('id, nome')
          .single();
      return LookupItem(
        id: res['id'].toString(),
        nome: res['nome']?.toString() ?? '',
      );
    } catch (e) {
      throw Exception('Erro ao criar estado: $e');
    }
  }

  Future<LookupItem> createTipoManejo(String nome) async {
    try {
      final res = await _client
          .from('tipo_manejo')
          .insert({'tipo_de_manejo': nome})
          .select('id, tipo_de_manejo')
          .single();
      return LookupItem(
        id: res['id'].toString(),
        nome: res['tipo_de_manejo']?.toString() ?? '',
      );
    } catch (e) {
      throw Exception('Erro ao criar tipo de manejo: $e');
    }
  }
}