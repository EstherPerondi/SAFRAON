// lib/services/clima_service.dart  (versão offline-first com PowerSync)
// Mesma API pública de antes. Lê o clima do SQLite local; os dados chegam
// do servidor (Edge Functions) pelo PowerSync, então o último clima
// sincronizado continua visível sem internet.
import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';

import '../powersync/powersync_service.dart';

class ClimaDiaInfo {
  final DateTime data;
  final double precipitacao;
  final String? condicaoNome;

  ClimaDiaInfo({required this.data, required this.precipitacao, this.condicaoNome});

  factory ClimaDiaInfo.fromJson(Map<String, dynamic> json) {
    return ClimaDiaInfo(
      data: DateTime.parse(json['data']),
      precipitacao: (json['precipitacao_dia'] ?? 0).toDouble(),
      condicaoNome: json['condicao_climatica_previsao'] is Map
          ? json['condicao_climatica_previsao']['nome']?.toString()
          : null,
    );
  }
}

class MetricasDiaInfo {
  final DateTime data;
  final double? temperaturaMin;
  final double? temperaturaMax;
  final double? umidadeMedia;
  final double? velocidadeVento;

  MetricasDiaInfo({
    required this.data,
    this.temperaturaMin,
    this.temperaturaMax,
    this.umidadeMedia,
    this.velocidadeVento,
  });

  factory MetricasDiaInfo.fromJson(Map<String, dynamic> json) {
    return MetricasDiaInfo(
      data: DateTime.parse(json['data']),
      temperaturaMin: (json['temperatura_min'] as num?)?.toDouble(),
      temperaturaMax: (json['temperatura_max'] as num?)?.toDouble(),
      umidadeMedia: (json['umidade_media'] as num?)?.toDouble(),
      velocidadeVento: (json['velocidade_vento'] as num?)?.toDouble(),
    );
  }
}

class PrevisaoDiaInfo {
  final DateTime data;
  final double? temperaturaMin;
  final double? temperaturaMax;
  final String? condicaoNome;

  PrevisaoDiaInfo({
    required this.data,
    this.temperaturaMin,
    this.temperaturaMax,
    this.condicaoNome,
  });

  factory PrevisaoDiaInfo.fromJson(Map<String, dynamic> json) {
    return PrevisaoDiaInfo(
      data: DateTime.parse(json['data']),
      temperaturaMin: (json['temperatura_min'] as num?)?.toDouble(),
      temperaturaMax: (json['temperatura_max'] as num?)?.toDouble(),
      condicaoNome: json['condicao_climatica_previsao'] is Map
          ? json['condicao_climatica_previsao']['nome']?.toString()
          : null,
    );
  }
}

class ClimaService {
  PowerSyncDatabase get _db => PowerSyncService().db;

  // Data "YYYY-MM-DD" (formato usado na coluna "data").
  String _dia(DateTime d) => d.toIso8601String().split('T').first;

  Future<MetricasDiaInfo?> getUltimasMetricas(String talhaoId) async {
    try {
      final rows = await _db.getAll(
        'SELECT * FROM metricas_dia WHERE talhao_id = ? '
        'ORDER BY data DESC LIMIT 1',
        [talhaoId],
      );
      return rows.isEmpty ? null : MetricasDiaInfo.fromJson(rows.first);
    } catch (e) {
      debugPrint('Erro ao buscar métricas do dia: $e');
      return null;
    }
  }

  Future<ClimaDiaInfo?> getUltimoClima(String talhaoId) async {
    try {
      final rows = await _db.getAll(
        'SELECT c.*, cc.nome AS condicao_nome FROM clima_dia c '
        'LEFT JOIN condicao_climatica_previsao cc '
        'ON cc.id = c.condicao_climatica_id '
        'WHERE c.talhao_id = ? ORDER BY c.data DESC LIMIT 1',
        [talhaoId],
      );
      if (rows.isEmpty) return null;
      final r = rows.first;
      return ClimaDiaInfo.fromJson({
        ...r,
        'condicao_climatica_previsao': {'nome': r['condicao_nome']},
      });
    } catch (e) {
      debugPrint('Erro ao buscar clima do dia: $e');
      return null;
    }
  }

  Future<List<ClimaDiaInfo>> getPrecipitacaoUltimos7Dias(
    String talhaoId,
  ) async {
    try {
      final desde = _dia(DateTime.now().subtract(const Duration(days: 6)));
      final rows = await _db.getAll(
        'SELECT * FROM clima_dia WHERE talhao_id = ? AND data >= ? '
        'ORDER BY data ASC',
        [talhaoId, desde],
      );
      return rows.map<ClimaDiaInfo>(ClimaDiaInfo.fromJson).toList();
    } catch (e) {
      debugPrint('Erro ao buscar precipitação dos últimos 7 dias: $e');
      return [];
    }
  }

  Future<List<PrevisaoDiaInfo>> getPrevisao(
    String talhaoId, {
    int dias = 5,
  }) async {
    try {
      final rows = await _db.getAll(
        'SELECT p.*, cc.nome AS condicao_nome FROM previsao_clima p '
        'LEFT JOIN condicao_climatica_previsao cc '
        'ON cc.id = p.condicao_climatica_id '
        'WHERE p.talhao_id = ? AND p.data >= ? ORDER BY p.data ASC LIMIT ?',
        [talhaoId, _dia(DateTime.now()), dias],
      );
      return rows.map<PrevisaoDiaInfo>((r) {
        return PrevisaoDiaInfo.fromJson({
          ...r,
          'condicao_climatica_previsao': {'nome': r['condicao_nome']},
        });
      }).toList();
    } catch (e) {
      debugPrint('Erro ao buscar previsão: $e');
      return [];
    }
  }
}