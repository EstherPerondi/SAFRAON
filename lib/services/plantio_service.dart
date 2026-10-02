// lib/services/plantio_service.dart  (versão offline-first com PowerSync)
// Mesma API pública de antes; agora lê e grava no SQLite local.
import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';

import '../models/plantio_model.dart';
import '../powersync/db_helpers.dart';
import '../powersync/powersync_service.dart';
import 'supabase_service.dart';

class PlantioService {
  PowerSyncDatabase get _db => PowerSyncService().db;

  // Os joins que o Supabase fazia ("cultura ( plantacultivada )", ...)
  // viraram LEFT JOINs locais.
  static const _select = '''
    SELECT p.*,
           c.plantacultivada AS cultura_nome,
           v.nomedavariedade AS variedade_nome,
           a.nomedoadubo     AS adubo_nome,
           i.nomedoinoculante AS inoculante_nome
    FROM plantio p
    LEFT JOIN cultura    c ON c.id = p.cultura_id
    LEFT JOIN variedade  v ON v.id = p.variedade_id
    LEFT JOIN adubo      a ON a.id = p.adubo_id
    LEFT JOIN inoculante i ON i.id = p.inoculante_id
  ''';

  // Remonta no formato aninhado que PlantioModel.fromJson espera.
  PlantioModel _fromRow(Map<String, Object?> r) {
    return PlantioModel.fromJson({
      ...r,
      'cultura': {'plantacultivada': r['cultura_nome']},
      'variedade': {'nomedavariedade': r['variedade_nome']},
      'adubo': {'nomedoadubo': r['adubo_nome']},
      'inoculante': {'nomedoinoculante': r['inoculante_nome']},
    });
  }

  Future<PlantioModel?> _getById(String id) async {
    final rows = await _db.getAll('$_select WHERE p.id = ?', [id]);
    return rows.isEmpty ? null : _fromRow(rows.first);
  }

  Future<List<PlantioModel>> getByTalhaoId(String talhaoId) async {
    try {
      final rows = await _db.getAll(
        '$_select WHERE p.talhao_id = ? ORDER BY p.dataplantio DESC',
        [talhaoId],
      );
      return rows.map<PlantioModel>(_fromRow).toList();
    } catch (e) {
      debugPrint('Erro ao buscar plantios: $e');
      return [];
    }
  }

  Future<List<PlantioModel>> getAllForUser() async {
    try {
      final rows = await _db.getAll(
        '$_select WHERE p.talhao_id IN ($talhoesDoUsuarioSql) '
        'ORDER BY p.dataplantio DESC',
        [SupabaseService().currentUserId],
      );
      return rows.map<PlantioModel>(_fromRow).toList();
    } catch (e) {
      debugPrint('Erro ao buscar plantios: $e');
      return [];
    }
  }

  Future<PlantioModel?> create(PlantioModel plantio) async {
    try {
      final id = await insertRow(_db, 'plantio', plantio.toJson());
      return _getById(id);
    } catch (e) {
      debugPrint('Erro ao criar plantio: $e');
      return null;
    }
  }

  Future<PlantioModel?> update(PlantioModel plantio) async {
    try {
      await updateRow(_db, 'plantio', plantio.id, plantio.toJson());
      return _getById(plantio.id);
    } catch (e) {
      debugPrint('Erro ao atualizar plantio: $e');
      return null;
    }
  }

  Future<bool> delete(String id) async {
    try {
      await _db.execute('DELETE FROM plantio WHERE id = ?', [id]);
      return true;
    } catch (e) {
      debugPrint('Erro ao deletar plantio: $e');
      return false;
    }
  }
}