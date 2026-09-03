class ManejoModel {
  final String id;
  final String talhaoId;
  final String pratica;
  final DateTime data;
  final String motivo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ManejoModel({
    required this.id,
    required this.talhaoId,
    required this.pratica,
    required this.data,
    required this.motivo,
    this.createdAt,
    this.updatedAt,
  });

  factory ManejoModel.fromJson(Map<String, dynamic> json) {
    return ManejoModel(
      id: json['id'].toString(),
      talhaoId: json['talhao_id'].toString(),
      pratica: json['pratica'] ?? '',
      data: json['data'] != null ? DateTime.parse(json['data']) : DateTime.now(),
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
      'pratica': pratica,
      'data': data.toIso8601String().split('T').first,
      'motivo': motivo,
    };
  }

  String get formattedDate {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year.toString().substring(2)}';
  }
}