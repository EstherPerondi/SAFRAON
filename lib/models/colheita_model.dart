class ColheitaModel {
  final String id;
  final String talhaoId;
  final String? talhaoNome; // vem de um join com a tabela 'talhao'
  final String? fazendaNome; // vem de um join talhao -> fazenda
  final String culturaId;
  final String? culturaNome; // vem de um join com a tabela 'cultura'
  final DateTime data;
  final double producao;
  final double umidade;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ColheitaModel({
    required this.id,
    required this.talhaoId,
    this.talhaoNome,
    this.fazendaNome,
    required this.culturaId,
    this.culturaNome,
    required this.data,
    required this.producao,
    required this.umidade,
    this.createdAt,
    this.updatedAt,
  });

  // Nome de exibição da cultura (usado nos cards da tela)
  String get cultura => culturaNome ?? 'Não informado';

  /// "Fazenda • Talhão" (ou só o talhão, se a fazenda não veio no join).
  /// Retorna null quando não há nenhuma informação de local.
  String? get localizacao {
    final talhao = talhaoNome?.trim() ?? '';
    final fazenda = fazendaNome?.trim() ?? '';
    if (talhao.isNotEmpty && fazenda.isNotEmpty) return '$fazenda • $talhao';
    if (talhao.isNotEmpty) return talhao;
    return null;
  }

  factory ColheitaModel.fromJson(Map<String, dynamic> json) {
    final talhao = json['talhao'];
    final fazenda = talhao is Map ? talhao['fazenda'] : null;

    return ColheitaModel(
      id: json['id'].toString(),
      talhaoId: json['talhao_id'].toString(),
      talhaoNome: talhao is Map ? talhao['nome']?.toString() : null,
      fazendaNome: fazenda is Map ? fazenda['nome']?.toString() : null,
      culturaId: json['cultura_id']?.toString() ?? '',
      culturaNome: json['cultura'] is Map
          ? json['cultura']['plantacultivada']?.toString()
          : null,
      data: json['datadacolheita'] != null
          ? DateTime.parse(json['datadacolheita'])
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
      'datadacolheita': data.toIso8601String(),
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