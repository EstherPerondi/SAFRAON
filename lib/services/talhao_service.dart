// lib/services/talhao_service.dart  (versão offline-first com PowerSync)
//
// Diferença importante: a geocodificação (Edge Function) NÃO é mais
// chamada aqui. Offline o talhão ainda não existe no Postgres, então a
// função não o encontraria. Agora o SupabaseConnector chama
// 'geocodificar-talhao' logo DEPOIS que o talhão sobe; a função grava
// latitude/longitude no servidor e o PowerSync devolve ao aparelho.
// Até lá, latitude/longitude ficam como vieram (0 se nunca preenchidas).
import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';

import '../models/talhao_model.dart';
import '../powersync/powersync_service.dart';

class TalhaoService {
  PowerSyncDatabase get _db => PowerSyncService().db;

  static const _ordem = "ORDER BY COALESCE(created_at, '9999') DESC";

  // O sync config já entrega só os talhões das fazendas do usuário,
  // então não precisa mais do join com fazenda.usuario_id.
  Future<List<TalhaoModel>> getAll() async {
    try {
      final rows = await _db.getAll('SELECT * FROM talhao $_ordem');
      return rows.map<TalhaoModel>(TalhaoModel.fromJson).toList();
    } catch (e) {
      debugPrint('❌ Erro ao buscar talhões: $e');
      return [];
    }
  }

  Future<List<TalhaoModel>> getByFazenda(String fazendaId) async {
    try {
      final rows = await _db.getAll(
        'SELECT * FROM talhao WHERE fazenda_id = ? $_ordem',
        [fazendaId],
      );
      return rows.map<TalhaoModel>(TalhaoModel.fromJson).toList();
    } catch (e) {
      debugPrint('❌ Erro ao buscar talhões: $e');
      return [];
    }
  }

  Future<TalhaoModel?> getById(String id) async {
    try {
      final rows = await _db.getAll('SELECT * FROM talhao WHERE id = ?', [id]);
      return rows.isEmpty ? null : TalhaoModel.fromJson(rows.first);
    } catch (e) {
      debugPrint('❌ Erro ao buscar talhão: $e');
      return null;
    }
  }

  Future<TalhaoModel?> create(TalhaoModel talhao) async {
    try {
      final res = await _db.execute(
        'INSERT INTO talhao(id, nome, cidade, fazenda_id, latitude, longitude) '
        'VALUES(uuid(), ?, ?, ?, ?, ?) RETURNING id',
        [
          talhao.nome.trim(),
          talhao.cidade.trim(),
          talhao.fazendaId,
          talhao.latitude,
          talhao.longitude,
        ],
      );
      return getById(res.first['id'] as String);
    } catch (e) {
      debugPrint('❌ Erro ao criar talhão: $e');
      return null;
    }
  }

  Future<TalhaoModel?> update(TalhaoModel talhao) async {
    try {
      if (talhao.id.isEmpty) throw Exception('ID do talhão não informado');

      await _db.execute(
        'UPDATE talhao SET nome = ?, cidade = ?, latitude = ?, longitude = ? '
        'WHERE id = ?',
        [
          talhao.nome.trim(),
          talhao.cidade.trim(),
          talhao.latitude,
          talhao.longitude,
          talhao.id,
        ],
      );
      return getById(talhao.id);
    } catch (e) {
      debugPrint('❌ Erro ao atualizar talhão: $e');
      return null;
    }
  }

  Future<bool> delete(String id) async {
    try {
      if (id.isEmpty) throw Exception('ID do talhão não informado');

      // Sem CASCADE local: remove os registros do talhão na mesma transação.
      await _db.writeTransaction((tx) async {
        const filhos = [
          'plantio',
          'aplicacao',
          'manejo',
          'colheita',
          'clima_dia',
          'metricas_dia',
          'previsao_clima',
        ];
        for (final tabela in filhos) {
          await tx.execute('DELETE FROM $tabela WHERE talhao_id = ?', [id]);
        }
        await tx.execute('DELETE FROM talhao WHERE id = ?', [id]);
      });
      return true;
    } catch (e) {
      debugPrint('❌ Erro ao deletar talhão: $e');
      return false;
    }
  }
}