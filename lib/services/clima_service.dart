// lib/services/clima_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

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
  final SupabaseClient _client = SupabaseService().client;

  Future<MetricasDiaInfo?> getUltimasMetricas(String talhaoId) async {
    try {
      final response = await _client
          .from('metricas_dia')
          .select()
          .eq('talhao_id', talhaoId)
          .order('data', ascending: false)
          .limit(1)
          .maybeSingle();
      return response != null ? MetricasDiaInfo.fromJson(response) : null;
    } catch (e) {
      print('Erro ao buscar métricas do dia: $e');
      return null;
    }
  }

  Future<ClimaDiaInfo?> getUltimoClima(String talhaoId) async {
    try {
      final response = await _client
          .from('clima_dia')
          .select('*, condicao_climatica_previsao ( nome )')
          .eq('talhao_id', talhaoId)
          .order('data', ascending: false)
          .limit(1)
          .maybeSingle();
      return response != null ? ClimaDiaInfo.fromJson(response) : null;
    } catch (e) {
      print('Erro ao buscar clima do dia: $e');
      return null;
    }
  }

  Future<List<ClimaDiaInfo>> getPrecipitacaoUltimos7Dias(String talhaoId) async {
    try {
      final desde = DateTime.now().subtract(const Duration(days: 6));
      final desdeStr = desde.toIso8601String().split('T').first;

      final response = await _client
          .from('clima_dia')
          .select()
          .eq('talhao_id', talhaoId)
          .gte('data', desdeStr)
          .order('data', ascending: true);

      return response.map<ClimaDiaInfo>((j) => ClimaDiaInfo.fromJson(j)).toList();
    } catch (e) {
      print('Erro ao buscar precipitação dos últimos 7 dias: $e');
      return [];
    }
  }

  Future<List<PrevisaoDiaInfo>> getPrevisao(String talhaoId, {int dias = 5}) async {
    try {
      final hoje = DateTime.now().toIso8601String().split('T').first;

      final response = await _client
          .from('previsao_clima')
          .select('*, condicao_climatica_previsao ( nome )')
          .eq('talhao_id', talhaoId)
          .gte('data', hoje)
          .order('data', ascending: true)
          .limit(dias);

      return response.map<PrevisaoDiaInfo>((j) => PrevisaoDiaInfo.fromJson(j)).toList();
    } catch (e) {
      print('Erro ao buscar previsão: $e');
      return [];
    }
  }
}