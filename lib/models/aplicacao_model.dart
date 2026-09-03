class AplicacaoModel {
  final String id;
  final String talhaoId;
  final String tipo;
  final DateTime data;
  final String motivo;
  final String defensivos;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AplicacaoModel({
    required this.id,
    required this.talhaoId,
    required this.tipo,
    required this.data,
    required this.motivo,
    required this.defensivos,
    this.createdAt,
    this.updatedAt,
  });

  factory AplicacaoModel.fromJson(Map<String, dynamic> json) {
    return AplicacaoModel(
      id: json['id'].toString(),
      talhaoId: json['talhao_id'].toString(),
      tipo: json['tipo'] ?? '',
      data: json['data'] != null ? DateTime.parse(json['data']) : DateTime.now(),
      motivo: json['motivo'] ?? '',
      defensivos: json['defensivos'] ?? '',
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
      'tipo': tipo,
      'data': data.toIso8601String().split('T').first,
      'motivo': motivo,
      'defensivos': defensivos,
    };
  }

  String get formattedDate {
    return '${data.day.toString().padLeft(2, '0')}/'
        '${data.month.toString().padLeft(2, '0')}/'
        '${data.year.toString().substring(2)}';
  }
}