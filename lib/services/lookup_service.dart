// lib/services/lookup_service.dart  (versão offline-first com PowerSync)
//
// Mesma API pública de antes (getCulturas, getVariedades, createCultura...),
// então as telas e dialogs não mudam. Agora tudo lê e grava no SQLite
// local; o PowerSync baixa as listas do Supabase quando há rede e envia
// os itens criados offline ("+ Adicionar novo...") quando a rede volta.
//
// Observação: as listas só aparecem offline DEPOIS que o app sincronizou
// pelo menos uma vez com internet (primeiro login).
import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';

import '../powersync/powersync_service.dart';

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
  PowerSyncDatabase get _db => PowerSyncService().db;

  // Texto vazio vira null (o banco guarda NULL, não "").
  String? _opt(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  double? _num(dynamic v) => v == null ? null : double.tryParse(v.toString());

  // ============================================
  // LEITURA
  // ============================================

  Future<List<LookupItem>> getCulturas() async {
    try {
      final rows = await _db.getAll(
        'SELECT id, plantacultivada FROM cultura '
        'ORDER BY plantacultivada COLLATE NOCASE',
      );
      return rows
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['plantacultivada']?.toString() ?? '',
              ))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar culturas: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getVariedades({String? culturaId}) async {
    try {
      final rows = culturaId != null
          ? await _db.getAll(
              'SELECT id, nomedavariedade, cultura_id, fabricante '
              'FROM variedade WHERE cultura_id = ? '
              'ORDER BY nomedavariedade COLLATE NOCASE',
              [culturaId],
            )
          : await _db.getAll(
              'SELECT id, nomedavariedade, cultura_id, fabricante '
              'FROM variedade ORDER BY nomedavariedade COLLATE NOCASE',
            );
      return rows
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nomedavariedade']?.toString() ?? '',
                culturaId: j['cultura_id']?.toString(),
                fabricante: j['fabricante']?.toString(),
              ))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar variedades: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getAdubos() async {
    try {
      final rows = await _db.getAll(
        'SELECT id, nomedoadubo, fabricante FROM adubo '
        'ORDER BY nomedoadubo COLLATE NOCASE',
      );
      return rows
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nomedoadubo']?.toString() ?? '',
                fabricante: j['fabricante']?.toString(),
              ))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar adubos: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getInoculantes() async {
    try {
      final rows = await _db.getAll(
        'SELECT id, nomedoinoculante, dosagemrecomendada, fabricante '
        'FROM inoculante ORDER BY nomedoinoculante COLLATE NOCASE',
      );
      return rows
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nomedoinoculante']?.toString() ?? '',
                fabricante: j['fabricante']?.toString(),
                dosagemRecomendada: _num(j['dosagemrecomendada']),
              ))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar inoculantes: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getDefensivos() async {
    try {
      final rows = await _db.getAll(
        'SELECT id, nome, principioativo, fabricante, utilidade '
        'FROM defensivo ORDER BY nome COLLATE NOCASE',
      );
      return rows
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nome']?.toString() ?? '',
                principioAtivo: j['principioativo']?.toString(),
                fabricante: j['fabricante']?.toString(),
                utilidade: j['utilidade']?.toString(),
              ))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar defensivos: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getEstados() async {
    try {
      final rows = await _db.getAll(
        'SELECT id, nome FROM estados ORDER BY nome COLLATE NOCASE',
      );
      return rows
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['nome']?.toString() ?? '',
              ))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar estados: $e');
      return [];
    }
  }

  Future<List<LookupItem>> getTiposManejo() async {
    try {
      final rows = await _db.getAll(
        'SELECT id, tipo_de_manejo FROM tipo_manejo '
        'ORDER BY tipo_de_manejo COLLATE NOCASE',
      );
      return rows
          .map<LookupItem>((j) => LookupItem(
                id: j['id'].toString(),
                nome: j['tipo_de_manejo']?.toString() ?? '',
              ))
          .toList();
    } catch (e) {
      debugPrint('Erro ao buscar tipos de manejo: $e');
      return [];
    }
  }

  // ============================================
  // CRIAÇÃO RÁPIDA DE ITENS ("+ Adicionar novo...")
  //
  // O id é gerado no aparelho (uuid()), então funciona sem internet.
  // O item já aparece no dropdown na hora e sobe ao Supabase depois.
  // ============================================

  Future<String> _inserir(String sql, List<Object?> args) async {
    final res = await _db.execute(sql, args);
    return res.first['id'] as String;
  }

  Future<LookupItem> createCultura(String nome) async {
    try {
      final nomeLimpo = nome.trim();
      final id = await _inserir(
        'INSERT INTO cultura(id, plantacultivada) VALUES(uuid(), ?) '
        'RETURNING id',
        [nomeLimpo],
      );
      return LookupItem(id: id, nome: nomeLimpo);
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
      final nomeLimpo = nome.trim();
      final fab = _opt(fabricante);
      final id = await _inserir(
        'INSERT INTO variedade(id, nomedavariedade, cultura_id, fabricante) '
        'VALUES(uuid(), ?, ?, ?) RETURNING id',
        [nomeLimpo, culturaId, fab],
      );
      return LookupItem(
        id: id,
        nome: nomeLimpo,
        culturaId: culturaId,
        fabricante: fab,
      );
    } catch (e) {
      throw Exception('Erro ao criar variedade: $e');
    }
  }

  Future<LookupItem> createAdubo(String nome, {String? fabricante}) async {
    try {
      final nomeLimpo = nome.trim();
      final fab = _opt(fabricante);
      final id = await _inserir(
        'INSERT INTO adubo(id, nomedoadubo, fabricante) '
        'VALUES(uuid(), ?, ?) RETURNING id',
        [nomeLimpo, fab],
      );
      return LookupItem(id: id, nome: nomeLimpo, fabricante: fab);
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
      final nomeLimpo = nome.trim();
      final fab = _opt(fabricante);
      final id = await _inserir(
        'INSERT INTO inoculante(id, nomedoinoculante, fabricante, '
        'dosagemrecomendada) VALUES(uuid(), ?, ?, ?) RETURNING id',
        [nomeLimpo, fab, dosagemRecomendada],
      );
      return LookupItem(
        id: id,
        nome: nomeLimpo,
        fabricante: fab,
        dosagemRecomendada: dosagemRecomendada,
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
      final nomeLimpo = nome.trim();
      final pa = _opt(principioAtivo);
      final fab = _opt(fabricante);
      final util = _opt(utilidade);
      final id = await _inserir(
        'INSERT INTO defensivo(id, nome, principioativo, fabricante, '
        'utilidade) VALUES(uuid(), ?, ?, ?, ?) RETURNING id',
        [nomeLimpo, pa, fab, util],
      );
      return LookupItem(
        id: id,
        nome: nomeLimpo,
        principioAtivo: pa,
        fabricante: fab,
        utilidade: util,
      );
    } catch (e) {
      throw Exception('Erro ao criar defensivo: $e');
    }
  }

  Future<LookupItem> createEstado(String nome) async {
    try {
      final nomeLimpo = nome.trim();
      final id = await _inserir(
        'INSERT INTO estados(id, nome) VALUES(uuid(), ?) RETURNING id',
        [nomeLimpo],
      );
      return LookupItem(id: id, nome: nomeLimpo);
    } catch (e) {
      throw Exception('Erro ao criar estado: $e');
    }
  }

  Future<LookupItem> createTipoManejo(String nome) async {
    try {
      final nomeLimpo = nome.trim();
      final id = await _inserir(
        'INSERT INTO tipo_manejo(id, tipo_de_manejo) VALUES(uuid(), ?) '
        'RETURNING id',
        [nomeLimpo],
      );
      return LookupItem(id: id, nome: nomeLimpo);
    } catch (e) {
      throw Exception('Erro ao criar tipo de manejo: $e');
    }
  }
}