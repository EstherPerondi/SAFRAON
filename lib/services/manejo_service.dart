// lib/services/manejo_service.dart  (versão offline-first com PowerSync)
// Mesma API pública de antes; agora lê e grava no SQLite local.
import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';

import '../models/manejo_model.dart';
import '../powersync/db_helpers.dart';
import '../powersync/powersync_service.dart';
import 'supabase_service.dart';

class ManejoService {
  PowerSyncDatabase get _db => PowerSyncService().db;

  static const _select = '''
    SELECT m.*, t.tipo_de_manejo AS tipo_manejo_nome
    FROM manejo m
    LEFT JOIN tipo_manejo t ON t.id = m.tipo_manejo_id
  ''';

  ManejoModel _fromRow(Map<String, Object?> r) {
    return ManejoModel.fromJson({
      ...r,
      'tipo_manejo': {'tipo_de_manejo': r['tipo_manejo_nome']},
    });
  }

  Future<ManejoModel?> _getById(String id) async {
    final rows = await _db.getAll('$_select WHERE m.id = ?', [id]);
    return rows.isEmpty ? null : _fromRow(rows.first);
  }

  Future<List<ManejoModel>> getByTalhaoId(String talhaoId) async {
    try {
      final rows = await _db.getAll(
        '$_select WHERE m.talhao_id = ? ORDER BY m.datadomanejo DESC',
        [talhaoId],
      );
      return rows.map<ManejoModel>(_fromRow).toList();
    } catch (e) {
      debugPrint('Erro ao buscar manejos: $e');
      return [];
    }
  }

  Future<List<ManejoModel>> getAllForUser() async {
    try {
      final rows = await _db.getAll(
        '$_select WHERE m.talhao_id IN ($talhoesDoUsuarioSql) '
        'ORDER BY m.datadomanejo DESC',
        [SupabaseService().currentUserId],
      );
      return rows.map<ManejoModel>(_fromRow).toList();
    } catch (e) {
      debugPrint('Erro ao buscar manejos: $e');
      return [];
    }
  }

  Future<ManejoModel?> create(ManejoModel manejo) async {
    try {
      final id = await insertRow(_db, 'manejo', manejo.toJson());
      return _getById(id);
    } catch (e) {
      debugPrint('Erro ao criar manejo: $e');
      return null;
    }
  }

  Future<ManejoModel?> update(ManejoModel manejo) async {
    try {
      await updateRow(_db, 'manejo', manejo.id, manejo.toJson());
      return _getById(manejo.id);
    } catch (e) {
      debugPrint('Erro ao atualizar manejo: $e');
      return null;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _db.execute('DELETE FROM manejo WHERE id = ?', [id]);
      return true;
    } catch (e) {
      debugPrint('Erro ao deletar manejo: $e');
      return false;
    }
  }
}