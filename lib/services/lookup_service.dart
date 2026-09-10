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

  LookupItem({required this.id, required this.nome, this.culturaId});
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
      var query = _client.from('variedade').select('id, nomedavariedade, cultura_id');
      final res = culturaId != null
          ? await query.eq('cultura_id', culturaId).order('nomedavariedade')
          : await query.order('nomedavariedade');
      return res
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nomedavariedade']?.toString() ?? '',
                culturaId: j['cultura_id']?.toString(),
              ))
          .toList();
    } catch (e) {
      print('Erro ao buscar variedades: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getAdubos() async {
    try {
      final res = await _client.from('adubo').select('id, nomedoadubo').order('nomedoadubo');
      return res
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nomedoadubo']?.toString() ?? '',
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
          .select('id, nomedoinoculante')
          .order('nomedoinoculante');
      return res
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nomedoinoculante']?.toString() ?? '',
              ))
          .toList();
    } catch (e) {
      print('Erro ao buscar inoculantes: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getDefensivos() async {
    try {
      final res = await _client.from('defensivo').select('id, nome').order('nome');
      return res
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nome']?.toString() ?? '',
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
}