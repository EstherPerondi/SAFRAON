class PlantioModel {
  final String id;
  final String talhaoId;
  final String cultura;
  final DateTime data;
  final String variedade;
  final String adubo;
  final String inoculante;
  final String sementes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlantioModel({
    required this.id,
    required this.talhaoId,
    required this.cultura,
    required this.data,
    required this.variedade,
    required this.adubo,
    required this.inoculante,
    required this.sementes,
    this.createdAt,
    this.updatedAt,
  });

  factory PlantioModel.fromJson(Map<String, dynamic> json) {
    return PlantioModel(
      id: json['id'].toString(),
      talhaoId: json['talhao_id'].toString(),
      cultura: json['cultura'] ?? '',
      data: json['data'] != null ? DateTime.parse(json['data']) : DateTime.now(),
      variedade: json['variedade'] ?? '',
      adubo: json['adubo'] ?? '',
      inoculante: json['inoculante'] ?? '',
      sementes: json['sementes'] ?? '',
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
      'cultura': cultura,
      'data': data.toIso8601String().split('T').first,
      'variedade': variedade,
      'adubo': adubo,
      'inoculante': inoculante,
      'sementes': sementes,
    };
  }

  String get formattedDate {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year.toString().substring(2)}';
  }
}