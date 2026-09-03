class TalhaoModel {
  final String id;
  final String fazendaId;
  final String nome;
  final String localizacao;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TalhaoModel({
    required this.id,
    required this.fazendaId,
    required this.nome,
    required this.localizacao,
    this.createdAt,
    this.updatedAt,
  });

  factory TalhaoModel.fromJson(Map<String, dynamic> json) {
    return TalhaoModel(
      id: json['id'].toString(),
      fazendaId: json['fazenda_id'].toString(),
      nome: json['nome'] ?? '',
      localizacao: json['localizacao'] ?? '',
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
      'fazenda_id': fazendaId,
      'nome': nome,
      'localizacao': localizacao,
    };
  }
}