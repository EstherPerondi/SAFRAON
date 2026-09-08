// lib/models/talhao_model.dart
class TalhaoModel {
  final String id;
  final String nome;
  final String cidade;
  final String fazendaId;
  final String userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TalhaoModel({
    required this.id,
    required this.nome,
    required this.cidade,
    required this.fazendaId,
    required this.userId,
    this.createdAt,
    this.updatedAt,
  });

  // Converter JSON para objeto
  factory TalhaoModel.fromJson(Map<String, dynamic> json) {
    return TalhaoModel(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      cidade: json['cidade']?.toString() ?? '',
      fazendaId: json['fazenda_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
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
      'nome': nome.trim(),
      'cidade': cidade.trim(),
      'fazenda_id': fazendaId,
      'user_id': userId,
    };
  }

  // Validação
  bool get isValid {
    return nome.trim().isNotEmpty && 
           cidade.trim().isNotEmpty && 
           fazendaId.trim().isNotEmpty;
  }

  // Criar cópia com novos valores
  TalhaoModel copyWith({
    String? id,
    String? nome,
    String? cidade,
    String? fazendaId,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TalhaoModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cidade: cidade ?? this.cidade,
      fazendaId: fazendaId ?? this.fazendaId,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'TalhaoModel(id: $id, nome: $nome, cidade: $cidade, fazendaId: $fazendaId)';
  }
}