class FazendaModel {
  final String id;
  final String nome;
  final String area;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FazendaModel({
    required this.id,
    required this.nome,
    required this.area,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  // Converter JSON para objeto
  factory FazendaModel.fromJson(Map<String, dynamic> json) {
    return FazendaModel(
      id: json['id'].toString(),
      nome: json['nome'] ?? '',
      area: json['area'] ?? '',
      userId: json['user_id'].toString(),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  // Converter objeto para JSON
  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'area': area,
      'user_id': userId,
    };
  }

  // Criar cópia com novos valores
  FazendaModel copyWith({
    String? id,
    String? nome,
    String? area,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FazendaModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      area: area ?? this.area,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}