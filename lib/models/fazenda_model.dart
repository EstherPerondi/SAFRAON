// lib/models/fazenda_model.dart
class FazendaModel {
  final String id;
  final String nome;
  final String estadoId;
  final String usuarioId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  FazendaModel({
    required this.id,
    required this.nome,
    required this.estadoId,
    required this.usuarioId,
    this.createdAt,
    this.updatedAt,
  });

  // Converter JSON para objeto
  factory FazendaModel.fromJson(Map<String, dynamic> json) {
    return FazendaModel(
      id: json['id']?.toString() ?? '',
      nome: json['nome']?.toString() ?? '',
      estadoId: json['estado_id']?.toString() ?? '',
      usuarioId: json['usuario_id']?.toString() ?? '',
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
      'estado_id': estadoId,
      'usuario_id': usuarioId,
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
    String? estadoId,
    String? usuarioId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FazendaModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      estadoId: estadoId ?? this.estadoId,
      usuarioId: usuarioId ?? this.usuarioId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'FazendaModel(id: $id, nome: $nome, estadoId: $estadoId, usuarioId: $usuarioId)';
  }
}