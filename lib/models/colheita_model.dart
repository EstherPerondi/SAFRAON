class ColheitaModel {
  final String id;
  final String talhaoId;
  final String culturaId;
  final DateTime data;
  final double producao;
  final double umidade;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ColheitaModel({
    required this.id,
    required this.talhaoId,
    required this.culturaId,
    required this.data,
    required this.producao,
    required this.umidade,
    this.createdAt,
    this.updatedAt,
  });

  factory ColheitaModel.fromJson(Map<String, dynamic> json) {
    return ColheitaModel(
      id: json['id'].toString(),
      talhaoId: json['talhao_id'].toString(),
      culturaId: json['cultura_id']?.toString() ?? '',
      data: json['datacolheita'] != null
          ? DateTime.parse(json['datacolheita'])
          : DateTime.now(),
      producao: (json['producao'] ?? 0).toDouble(),
      umidade: (json['umidade'] ?? 0).toDouble(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'talhao_id': talhaoId,
      'cultura_id': culturaId,
      'datacolheita': data.toIso8601String(),
      'producao': producao,
      'umidade': umidade,
    };
  }

  String get formattedDate {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year.toString().substring(2)}';
  }
}