// lib/models/fazenda_model.dart
class FazendaModel {
  final String id;
  final String nome;
  final String userId;
  final String estadoId;
  final String? estadoNome; // vem de um join com a tabela 'estados'
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FazendaModel({
    required this.id,
    required this.nome,
    required this.userId,
    required this.estadoId,
    this.estadoNome,
    this.createdAt,
    this.updatedAt,
  });

  String get estado => estadoNome ?? 'Não informado';

  // Converter JSON para objeto
  factory FazendaModel.fromJson(Map<String, dynamic> json) {
    return FazendaModel(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      userId: json['usuario_id']?.toString() ?? '',
      estadoId: json['estado_id']?.toString() ?? '',
      estadoNome: json['estados'] is Map
          ? json['estados']['nome']?.toString()
          : null,
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
      'usuario_id': userId,
      'estado_id': estadoId,
    };
  }

  // Validação
  bool get isValid {
    return nome.trim().isNotEmpty && estadoId.trim().isNotEmpty;
  }

  // Criar cópia com novos valores
  FazendaModel copyWith({
    String? id,
    String? nome,
    String? userId,
    String? estadoId,
    String? estadoNome,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FazendaModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      userId: userId ?? this.userId,
      estadoId: estadoId ?? this.estadoId,
      estadoNome: estadoNome ?? this.estadoNome,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'FazendaModel(id: $id, nome: $nome, userId: $userId, estadoId: $estadoId)';
  }
}