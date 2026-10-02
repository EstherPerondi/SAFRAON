// lib/services/colheita_service.dart  (versão offline-first com PowerSync)
// Mesma API pública de antes; agora lê e grava no SQLite local.
import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';

import '../models/colheita_model.dart';
import '../powersync/db_helpers.dart';
import '../powersync/powersync_service.dart';
import 'supabase_service.dart';
import 'delete_helper.dart';

class ColheitaService {
  final SupabaseClient _client = SupabaseService().client;
  PowerSyncDatabase get _db => PowerSyncService().db;
  final String _table = 'colheita';
  static const _selectComNome = '''
    *,
    cultura ( plantacultivada ),
    talhao ( nome, fazenda ( nome ) )
  ''';

  static const _select = '''
    SELECT h.*, c.plantacultivada AS cultura_nome
    FROM colheita h
    LEFT JOIN cultura c ON c.id = h.cultura_id
  ''';

  ColheitaModel _fromRow(Map<String, Object?> r) {
    return ColheitaModel.fromJson({
      ...r,
      'cultura': {'plantacultivada': r['cultura_nome']},
    });
  }

  Future<ColheitaModel?> _getById(String id) async {
    final rows = await _db.getAll('$_select WHERE h.id = ?', [id]);
    return rows.isEmpty ? null : _fromRow(rows.first);
  }

  Future<List<ColheitaModel>> getByTalhaoId(String talhaoId) async {
    try {
      final rows = await _db.getAll(
        '$_select WHERE h.talhao_id = ? ORDER BY h.datadacolheita DESC',
        [talhaoId],
      );
      return rows.map<ColheitaModel>(_fromRow).toList();
    } catch (e) {
      debugPrint('Erro ao buscar colheitas: $e');
      return [];
    }
  }

  Future<List<ColheitaModel>> getAllForUser() async {
    try {
      final rows = await _db.getAll(
        '$_select WHERE h.talhao_id IN ($talhoesDoUsuarioSql) '
        'ORDER BY h.datadacolheita DESC',
        [SupabaseService().currentUserId],
      );
      return rows.map<ColheitaModel>(_fromRow).toList();
    } catch (e) {
      debugPrint('Erro ao buscar colheitas: $e');
      return [];
    }
  }

  Future<ColheitaModel?> create(ColheitaModel colheita) async {
    try {
      final id = await insertRow(_db, 'colheita', colheita.toJson());
      return _getById(id);
    } catch (e) {
      debugPrint('Erro ao criar colheita: $e');
      return null;
    }
  }

  Future<ColheitaModel?> update(ColheitaModel colheita) async {
    try {
      await updateRow(_db, 'colheita', colheita.id, colheita.toJson());
      return _getById(colheita.id);
    } catch (e) {
      debugPrint('Erro ao atualizar colheita: $e');
      return null;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _db.execute('DELETE FROM colheita WHERE id = ?', [id]);
      return true;
    } catch (e) {
      debugPrint('Erro ao deletar colheita: $e');
      return false;
    }
  }
}