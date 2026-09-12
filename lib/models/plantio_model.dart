class PlantioModel {
  final String id;
  final String talhaoId;
  final String culturaId;
  final String? culturaNome;
  final String variedadeId;
  final String? variedadeNome;
  final String aduboId;
  final String? aduboNome;
  final String? inoculanteId;
  final String? inoculanteNome;
  final DateTime data;
  final double quantidadeSementesPorMetro;
  final double quantidadeAduboPorAlqueire;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PlantioModel({
    required this.id,
    required this.talhaoId,
    required this.culturaId,
    this.culturaNome,
    required this.variedadeId,
    this.variedadeNome,
    required this.aduboId,
    this.aduboNome,
    this.inoculanteId,
    this.inoculanteNome,
    required this.data,
    required this.quantidadeSementesPorMetro,
    required this.quantidadeAduboPorAlqueire,
    this.createdAt,
    this.updatedAt,
  });

  // Aliases de exibição usados nas telas
  String get cultura => culturaNome ?? 'Não informado';
  String get variedade => variedadeNome ?? 'Não informado';
  String get adubo => aduboNome ?? 'Não informado';
  String get inoculante => inoculanteNome ?? 'Nenhum';
  String get sementes => '${quantidadeSementesPorMetro.toStringAsFixed(1)} sementes/m';

  factory PlantioModel.fromJson(Map<String, dynamic> json) {
    return PlantioModel(
      id: json['id'].toString(),
      talhaoId: json['talhao_id'].toString(),
      culturaId: json['cultura_id']?.toString() ?? '',
      culturaNome: json['cultura'] is Map
          ? json['cultura']['plantacultivada']?.toString()
          : null,
      variedadeId: json['variedade_id']?.toString() ?? '',
      variedadeNome: json['variedade'] is Map
          ? json['variedade']['nomedavariedade']?.toString()
          : null,
      aduboId: json['adubo_id']?.toString() ?? '',
      aduboNome: json['adubo'] is Map
          ? json['adubo']['nomedoadubo']?.toString()
          : null,
      inoculanteId: json['inoculante_id']?.toString(),
      inoculanteNome: json['inoculante'] is Map
          ? json['inoculante']['nomedoinoculante']?.toString()
          : null,
      data: json['dataplantio'] != null
          ? DateTime.parse(json['dataplantio'])
          : DateTime.now(),
      quantidadeSementesPorMetro:
          (json['quantidadessementespormetro'] ?? 0).toDouble(),
      quantidadeAduboPorAlqueire:
          (json['quantidadeaduboporalqueire'] ?? 0).toDouble(),
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