// lib/models/precipitacao_model.dart
//
// Representa uma linha da tabela 'clima_dia' focada em precipitação.
// A mesma tabela também recebe registros automáticos da Edge Function
// 'atualizar-clima' (fonte: 'openweathermap'); quando o cadastro é
// feito manualmente pelo app, gravamos fonte: 'manual'.
class PrecipitacaoModel {
  final String id;
  final String talhaoId;
  final double quantidade; // coluna: precipitacao_dia
  final DateTime data;
  final String fonte;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PrecipitacaoModel({
    required this.id,
    required this.talhaoId,
    required this.quantidade,
    required this.data,
    this.fonte = 'manual',
    this.createdAt,
    this.updatedAt,
  });

  // Converter JSON para objeto
  factory PrecipitacaoModel.fromJson(Map<String, dynamic> json) {
    return PrecipitacaoModel(
      id: json['id']?.toString() ?? '',
      talhaoId: json['talhao_id']?.toString() ?? '',
      quantidade: (json['precipitacao_dia'] ?? 0).toDouble(),
      data: json['data'] != null
          ? DateTime.parse(json['data'])
          : DateTime.now(),
      fonte: json['fonte']?.toString() ?? 'manual',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Converter objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'talhao_id': talhaoId,
      'precipitacao_dia': quantidade,
      'data': data.toIso8601String().split('T').first,
      'fonte': fonte,
    };
  }

  // Validação
  bool get isValid {
    return talhaoId.trim().isNotEmpty && quantidade >= 0;
  }

  // Criar cópia com novos valores
  PrecipitacaoModel copyWith({
    String? id,
    String? talhaoId,
    double? quantidade,
    DateTime? data,
    String? fonte,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PrecipitacaoModel(
      id: id ?? this.id,
      talhaoId: talhaoId ?? this.talhaoId,
      quantidade: quantidade ?? this.quantidade,
      data: data ?? this.data,
      fonte: fonte ?? this.fonte,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get formattedDate {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year}';
  }

  String get formattedQuantidade {
    return '${quantidade.toStringAsFixed(1)} mm';
  }

  @override
  String toString() {
    return 'PrecipitacaoModel(id: $id, talhaoId: $talhaoId, quantidade: $quantidade, data: $data)';
  }
}