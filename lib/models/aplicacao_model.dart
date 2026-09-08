class AplicacaoModel {
  final String id;
  final String talhaoId;
  final String defensivoId;
  final double doseporhectare;
  final DateTime data;
  final String motivo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AplicacaoModel({
    required this.id,
    required this.talhaoId,
    required this.defensivoId,
    required this.doseporhectare,
    required this.data,
    required this.motivo,
    this.createdAt,
    this.updatedAt,
  });

  factory AplicacaoModel.fromJson(Map<String, dynamic> json) {
    return AplicacaoModel(
      id: json['id'].toString(),
      talhaoId: json['talhao_id'].toString(),
      defensivoId: json['defensivo_id']?.toString() ?? '',
      doseporhectare: (json['doseporhectare'] ?? 0).toDouble(),
      data: json['dataaplicacao'] != null
          ? DateTime.parse(json['dataaplicacao'])
          : DateTime.now(),
      motivo: json['motivo'] ?? '',
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
      'defensivo_id': defensivoId,
      'doseporhectare': doseporhectare,
      'dataaplicacao': data.toIso8601String(),
      'motivo': motivo,
    };
  }

  String get formattedDate {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year.toString().substring(2)}';
  }
}