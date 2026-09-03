class PrecipitacaoModel {
  final String id;
  final String talhaoId;
  final double quantidade;
  final DateTime data;
  final String descricao;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PrecipitacaoModel({
    required this.id,
    required this.talhaoId,
    required this.quantidade,
    required this.data,
    required this.descricao,
    this.createdAt,
    this.updatedAt,
  });

  factory PrecipitacaoModel.fromJson(Map<String, dynamic> json) {
    return PrecipitacaoModel(
      id: json['id'].toString(),
      talhaoId: json['talhao_id'].toString(),
      quantidade: (json['quantidade'] ?? 0).toDouble(),
      data: json['data'] != null ? DateTime.parse(json['data']) : DateTime.now(),
      descricao: json['descricao'] ?? '',
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
      'quantidade': quantidade,
      'data': data.toIso8601String().split('T').first,
      'descricao': descricao,
    };
  }

  String get formattedDate {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year.toString().substring(2)}';
  }

  String get formattedQuantidade {
    return '${quantidade.toStringAsFixed(1)} mm';
  }
}