class ManejoModel {
  final String id;
  final String talhaoId;
  final String? talhaoNome; // vem de um join com a tabela 'talhao'
  final String? fazendaNome; // vem de um join talhao -> fazenda
  final String tipoManejoId;
  final String? tipoManejoNome; // vem de um join com a tabela 'tipo_manejo'
  final DateTime data;
  final String descricao;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ManejoModel({
    required this.id,
    required this.talhaoId,
    this.talhaoNome,
    this.fazendaNome,
    required this.tipoManejoId,
    this.tipoManejoNome,
    required this.data,
    required this.descricao,
    this.createdAt,
    this.updatedAt,
  });

  // Aliases usados nas telas
  String get pratica => tipoManejoNome ?? 'Não informado';
  String get motivo => descricao;

  /// "Fazenda • Talhão" (ou só o talhão, se a fazenda não veio no join).
  /// Retorna null quando não há nenhuma informação de local.
  String? get localizacao {
    final talhao = talhaoNome?.trim() ?? '';
    final fazenda = fazendaNome?.trim() ?? '';
    if (talhao.isNotEmpty && fazenda.isNotEmpty) return '$fazenda • $talhao';
    if (talhao.isNotEmpty) return talhao;
    return null;
  }

  factory ManejoModel.fromJson(Map<String, dynamic> json) {
    final talhao = json['talhao'];
    final fazenda = talhao is Map ? talhao['fazenda'] : null;

    return ManejoModel(
      id: json['id'].toString(),
      talhaoId: json['talhao_id'].toString(),
      talhaoNome: talhao is Map ? talhao['nome']?.toString() : null,
      fazendaNome: fazenda is Map ? fazenda['nome']?.toString() : null,
      tipoManejoId: json['tipo_manejo_id']?.toString() ?? '',
      tipoManejoNome: json['tipo_manejo'] is Map
          ? json['tipo_manejo']['tipo_de_manejo']?.toString()
          : null,
      data: json['datadomanejo'] != null
          ? DateTime.parse(json['datadomanejo'])
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
      'datadomanejo': data.toIso8601String(),
      'descricao': descricao,
    };
  }

  String get formattedDate {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year.toString().substring(2)}';
  }
}