// lib/services/precipitacao_service.dart  (versão offline-first com PowerSync)
// Mesma API pública de antes; agora lê e grava no SQLite local.
//
// Atenção: 'clima_dia' tem chave única (talhao_id, data) no servidor
// (a Edge Function usa onConflict "talhao_id,data"). Se já existir um
// registro do dia, o servidor recusaria o novo e o item sumiria após o
// sync. Por isso checamos AQUI e recusamos (retorna null), igual ao
// comportamento online de antes.
import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';

import '../models/precipitacao_model.dart';
import '../powersync/db_helpers.dart';
import '../powersync/powersync_service.dart';
import 'supabase_service.dart';
import 'delete_helper.dart';

class PrecipitacaoService {
  final SupabaseClient _client = SupabaseService().client;
  PowerSyncDatabase get _db => PowerSyncService().db;
  final String _table = 'clima_dia';
  static const _selectComNome = '''
    *,
    talhao ( nome, fazenda ( nome ) )
  ''';

  Future<PrecipitacaoModel?> _getById(String id) async {
    final rows = await _db.getAll('SELECT * FROM clima_dia WHERE id = ?', [id]);
    return rows.isEmpty ? null : PrecipitacaoModel.fromJson(rows.first);
  }

  Future<bool> _existeNoDia(
    String talhaoId,
    String data, {
    String? ignorarId,
  }) async {
    final rows = await _db.getAll(
      'SELECT id FROM clima_dia '
      'WHERE talhao_id = ? AND substr(data, 1, 10) = ? AND id != ? LIMIT 1',
      [talhaoId, data, ignorarId ?? ''],
    );
    return rows.isNotEmpty;
  }
    } catch (e) {
      debugPrint('Erro ao buscar precipitações: $e');
      return [];
    }
  }

  Future<List<PrecipitacaoModel>> getAllForUser() async {
    try {
      final rows = await _db.getAll(
        "SELECT * FROM clima_dia WHERE fonte = 'manual' "
        'AND talhao_id IN ($talhoesDoUsuarioSql) ORDER BY data DESC',
        [SupabaseService().currentUserId],
      );
      return rows.map<PrecipitacaoModel>(PrecipitacaoModel.fromJson).toList();
    } catch (e) {
      debugPrint('Erro ao buscar precipitações: $e');
      return [];
    }
  }

  Future<PrecipitacaoModel?> create(PrecipitacaoModel precipitacao) async {
    try {
      final json = precipitacao.toJson();
      if (await _existeNoDia(precipitacao.talhaoId, json['data'] as String)) {
        debugPrint('Já existe registro de chuva para este talhão nesta data.');
        return null;
      }
      final id = await insertRow(_db, 'clima_dia', json);
      return _getById(id);
    } catch (e) {
      debugPrint('Erro ao criar precipitação: $e');
      return null;
    }
  }

  Future<PrecipitacaoModel?> update(PrecipitacaoModel precipitacao) async {
    try {
      final json = precipitacao.toJson();
      if (await _existeNoDia(
        precipitacao.talhaoId,
        json['data'] as String,
        ignorarId: precipitacao.id,
      )) {
        debugPrint('Já existe registro de chuva para este talhão nesta data.');
        return null;
      }
      await updateRow(_db, 'clima_dia', precipitacao.id, json);
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