class AplicacaoModel {
  final String id;
  final String talhaoId;
  final String? talhaoNome; // vem de um join com a tabela 'talhao'
  final String? fazendaNome; // vem de um join talhao -> fazenda
  final String defensivoId;
  final String? defensivoNome; // vem de um join com a tabela 'defensivo'
  final String? defensivoPrincipioAtivo;
  final String? defensivoFabricante;
  final String? defensivoUtilidade;
  final double doseporhectare;
  final DateTime data;
  final String motivo;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AplicacaoModel({
    required this.id,
    required this.talhaoId,
    this.talhaoNome,
    this.fazendaNome,
    required this.defensivoId,
    this.defensivoNome,
    this.defensivoPrincipioAtivo,
    this.defensivoFabricante,
    this.defensivoUtilidade,
    required this.doseporhectare,
    required this.data,
    required this.motivo,
    this.createdAt,
    this.updatedAt,
  });

  // Aliases de exibição usados nas telas
  String get defensivos => defensivoNome ?? 'Não informado';
  String get dose => '${doseporhectare.toStringAsFixed(2)} por ha';

  /// "Fazenda • Talhão" (ou só o talhão, se a fazenda não veio no join).
  /// Retorna null quando não há nenhuma informação de local.
  String? get localizacao {
    final talhao = talhaoNome?.trim() ?? '';
    final fazenda = fazendaNome?.trim() ?? '';
    if (talhao.isNotEmpty && fazenda.isNotEmpty) return '$fazenda • $talhao';
    if (talhao.isNotEmpty) return talhao;
    return null;
  }

  factory AplicacaoModel.fromJson(Map<String, dynamic> json) {
    final talhao = json['talhao'];
    final fazenda = talhao is Map ? talhao['fazenda'] : null;
    final defensivo = json['defensivo'];

    return AplicacaoModel(
      id: json['id'].toString(),
      talhaoId: json['talhao_id'].toString(),
      talhaoNome: talhao is Map ? talhao['nome']?.toString() : null,
      fazendaNome: fazenda is Map ? fazenda['nome']?.toString() : null,
      defensivoId: json['defensivo_id']?.toString() ?? '',
      defensivoNome: defensivo is Map ? defensivo['nome']?.toString() : null,
      defensivoPrincipioAtivo:
          defensivo is Map ? defensivo['principioativo']?.toString() : null,
      defensivoFabricante:
          defensivo is Map ? defensivo['fabricante']?.toString() : null,
      defensivoUtilidade:
          defensivo is Map ? defensivo['utilidade']?.toString() : null,
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