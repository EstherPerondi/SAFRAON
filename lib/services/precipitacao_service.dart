// lib/services/precipitacao_service.dart  (versão offline-first com PowerSync)
// Mesma API pública de antes; agora lê e grava no SQLite local.
//
// Podem existir VÁRIOS registros manuais no mesmo dia para o mesmo talhão
// (a chave única (talhao_id, data) foi removida do servidor; só os registros
// automáticos da Edge Function continuam únicos por talhão/dia).
import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';

import '../models/precipitacao_model.dart';
import '../powersync/db_helpers.dart';
import '../powersync/powersync_service.dart';
import 'supabase_service.dart';

class PrecipitacaoService {
  PowerSyncDatabase get _db => PowerSyncService().db;

  // Traz também o nome do talhão e da fazenda (para mostrar a localização)
  static const _select = '''
    SELECT c.*,
           tl.nome AS talhao_nome,
           fz.nome AS fazenda_nome
    FROM clima_dia c
    LEFT JOIN talhao  tl ON tl.id = c.talhao_id
    LEFT JOIN fazenda fz ON fz.id = tl.fazenda_id
  ''';

  PrecipitacaoModel _fromRow(Map<String, Object?> r) {
    return PrecipitacaoModel.fromJson({
      ...r,
      'talhao': {
        'nome': r['talhao_nome'],
        'fazenda': {'nome': r['fazenda_nome']},
      },
    });
  }

  Future<PrecipitacaoModel?> _getById(String id) async {
    final rows = await _db.getAll('$_select WHERE c.id = ?', [id]);
    return rows.isEmpty ? null : _fromRow(rows.first);
  }

  /// Mapa {id do talhão -> nome}, usado para rotular os registros na tela geral.
  /// Se a consulta falhar (ex.: nome de coluna diferente), devolve mapa vazio
  /// e a tela simplesmente não mostra o nome.
  Future<Map<String, String>> getNomesTalhoes() async {
    try {
      final rows = await _db.getAll('SELECT id, nome FROM talhao');
      return {
        for (final r in rows)
          r['id'].toString(): (r['nome'] ?? '').toString(),
      };
    } catch (e) {
      debugPrint('Erro ao buscar nomes dos talhões: $e');
      return {};
    }
  }

  Future<List<PrecipitacaoModel>> getByTalhaoId(String talhaoId) async {
    try {
      final rows = await _db.getAll(
        "$_select WHERE c.fonte = 'manual' "
        'AND c.talhao_id = ? ORDER BY c.data DESC',
        [talhaoId],
      );
      return rows.map<PrecipitacaoModel>(_fromRow).toList();
    } catch (e) {
      debugPrint('Erro ao buscar precipitações: $e');
      return [];
    }
  }

  Future<List<PrecipitacaoModel>> getAllForUser() async {
    try {
      final rows = await _db.getAll(
        "$_select WHERE c.fonte = 'manual' "
        'AND c.talhao_id IN ($talhoesDoUsuarioSql) ORDER BY c.data DESC',
        [SupabaseService().currentUserId],
      );
      return rows.map<PrecipitacaoModel>(_fromRow).toList();
    } catch (e) {
      debugPrint('Erro ao buscar precipitações: $e');
      return [];
    }
  }

  Future<PrecipitacaoModel?> create(PrecipitacaoModel precipitacao) async {
    try {
      final id = await insertRow(_db, 'clima_dia', precipitacao.toJson());
      return _getById(id);
    } catch (e) {
      debugPrint('Erro ao criar precipitação: $e');
      return null;
    }
  }

  Future<PrecipitacaoModel?> update(PrecipitacaoModel precipitacao) async {
    try {
      await updateRow(
        _db,
        'clima_dia',
        precipitacao.id,
        precipitacao.toJson(),
      );
      return _getById(precipitacao.id);
    } catch (e) {
      debugPrint('Erro ao atualizar precipitação: $e');
      return null;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _db.execute('DELETE FROM clima_dia WHERE id = ?', [id]);
      return true;
    } catch (e) {
      debugPrint('Erro ao deletar precipitação: $e');
      return false;
    }
  }
}