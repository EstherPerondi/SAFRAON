class PlantioModel {
  final String id;
  final String talhaoId;
  final String culturaId;
  final String variedadeId;
  final String aduboId;
  final String? inoculanteId;
  final DateTime data;
  final double quantidadeSementesPorMetro;
  final double quantidadeAduboPorAlqueire;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlantioModel({
    required this.id,
    required this.talhaoId,
    required this.culturaId,
    required this.variedadeId,
    required this.aduboId,
    this.inoculanteId,
    required this.data,
    required this.quantidadeSementesPorMetro,
    required this.quantidadeAduboPorAlqueire,
    this.createdAt,
    this.updatedAt,
  });

  factory PlantioModel.fromJson(Map<String, dynamic> json) {
    return PlantioModel(
      id: json['id'].toString(),
      talhaoId: json['talhao_id'].toString(),
      culturaId: json['cultura_id']?.toString() ?? '',
      variedadeId: json['variedade_id']?.toString() ?? '',
      aduboId: json['adubo_id']?.toString() ?? '',
      inoculanteId: json['inoculante_id']?.toString(),
      data: json['dataplantio'] != null
          ? DateTime.parse(json['dataplantio'])
          : DateTime.now(),
      quantidadeSementesPorMetro: (json['quantidadessementespormetro'] ?? 0).toDouble(),
      quantidadeAduboPorAlqueire: (json['quantidadeaduboporalqueire'] ?? 0).toDouble(),
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
      'variedade_id': variedadeId,
      'adubo_id': aduboId,
      'inoculante_id': inoculanteId,
      'dataplantio': data.toIso8601String(),
      'quantidadessementespormetro': quantidadeSementesPorMetro,
      'quantidadeaduboporalqueire': quantidadeAduboPorAlqueire,
    };
  }

  String get formattedDate {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year.toString().substring(2)}';
  }
}