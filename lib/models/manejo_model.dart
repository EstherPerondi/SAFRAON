class ManejoModel {
  final String id;
  final String talhaoId;
  final String tipoManejoId;
  final DateTime data;
  final String descricao;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ManejoModel({
    required this.id,
    required this.talhaoId,
    required this.tipoManejoId,
    required this.data,
    required this.descricao,
    this.createdAt,
    this.updatedAt,
  });

  factory ManejoModel.fromJson(Map<String, dynamic> json) {
    return ManejoModel(
      id: json['id'].toString(),
      talhaoId: json['talhao_id'].toString(),
      tipoManejoId: json['tipo_manejo_id']?.toString() ?? '',
      data: json['datamanejo'] != null
          ? DateTime.parse(json['datamanejo'])
          : DateTime.now(),
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
      'tipo_manejo_id': tipoManejoId,
      'datamanejo': data.toIso8601String(),
      'descricao': descricao,
    };
  }

  String get formattedDate {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year.toString().substring(2)}';
  }
}