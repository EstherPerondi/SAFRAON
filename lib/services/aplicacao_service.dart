// lib/services/aplicacao_service.dart  (versão offline-first com PowerSync)
// Mesma API pública de antes; agora lê e grava no SQLite local.
import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';

import '../models/aplicacao_model.dart';
import '../powersync/db_helpers.dart';
import '../powersync/powersync_service.dart';
import 'supabase_service.dart';
import 'delete_helper.dart';

class AplicacaoService {
  final SupabaseClient _client = SupabaseService().client;
  PowerSyncDatabase get _db => PowerSyncService().db;
  final String _table = 'aplicacao';
  static const _selectComNome = '''
    *,
    defensivo ( nome, principioativo, fabricante, utilidade ),
    talhao ( nome, fazenda ( nome ) )
  ''';

  static const _select = '''
    SELECT a.*, d.nome AS defensivo_nome
    FROM aplicacao a
    LEFT JOIN defensivo d ON d.id = a.defensivo_id
  ''';

  AplicacaoModel _fromRow(Map<String, Object?> r) {
    return AplicacaoModel.fromJson({
      ...r,
      'defensivo': {'nome': r['defensivo_nome']},
    });
  }

  Future<AplicacaoModel?> _getById(String id) async {
    final rows = await _db.getAll('$_select WHERE a.id = ?', [id]);
    return rows.isEmpty ? null : _fromRow(rows.first);
  }

  Future<List<AplicacaoModel>> getByTalhaoId(String talhaoId) async {
    try {
      final rows = await _db.getAll(
        '$_select WHERE a.talhao_id = ? ORDER BY a.dataaplicacao DESC',
        [talhaoId],
      );
      return rows.map<AplicacaoModel>(_fromRow).toList();
    } catch (e) {
      debugPrint('Erro ao buscar aplicações: $e');
      return [];
    }
  }

  Future<List<AplicacaoModel>> getAllForUser() async {
    try {
      final rows = await _db.getAll(
        '$_select WHERE a.talhao_id IN ($talhoesDoUsuarioSql) '
        'ORDER BY a.dataaplicacao DESC',
        [SupabaseService().currentUserId],
      );
      return rows.map<AplicacaoModel>(_fromRow).toList();
    } catch (e) {
      debugPrint('Erro ao buscar aplicações: $e');
      return [];
    }
  }

  Future<AplicacaoModel?> create(AplicacaoModel aplicacao) async {
    try {
      final id = await insertRow(_db, 'aplicacao', aplicacao.toJson());
      return _getById(id);
    } catch (e) {
      debugPrint('Erro ao criar aplicação: $e');
      return null;
    }
  }

  Future<AplicacaoModel?> update(AplicacaoModel aplicacao) async {
    try {
      await updateRow(_db, 'aplicacao', aplicacao.id, aplicacao.toJson());
      return _getById(aplicacao.id);
    } catch (e) {
      debugPrint('Erro ao atualizar aplicação: $e');
      return null;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _db.execute('DELETE FROM aplicacao WHERE id = ?', [id]);
      return true;
    } catch (e) {
      debugPrint('Erro ao deletar aplicação: $e');
      return false;
    }
  }
}