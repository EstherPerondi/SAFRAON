// lib/services/delete_helper.dart
import 'package:supabase_flutter/supabase_flutter.dart';

/// Deleta uma linha pelo id e CONFIRMA que algo foi realmente removido.
///
/// O Supabase não retorna erro quando o DELETE é bloqueado por RLS ou quando
/// nenhuma linha bate com o filtro: ele simplesmente apaga 0 linhas. Por isso
/// usamos `.select()` para receber as linhas apagadas e conferir.
///
/// Lança [Exception] com uma mensagem amigável em caso de falha.
Future<void> deletarPorId(
  SupabaseClient client,
  String table,
  String id, {
  String nomeItem = 'registro',
}) async {
  if (id.isEmpty) {
    throw Exception('ID do $nomeItem não informado');
  }

  try {
    final apagados = await client.from(table).delete().eq('id', id).select('id');

    if (apagados.isEmpty) {
      throw Exception(
        'Não foi possível excluir o $nomeItem. Ele pode não existir mais ou '
        'você não tem permissão (verifique a policy de DELETE no Supabase).',
      );
    }
  } on PostgrestException catch (e) {
    if (e.code == '23503') {
      throw Exception(
        'Não foi possível excluir o $nomeItem porque existem registros '
        'vinculados a ele.',
      );
    }
    throw Exception('Erro ao excluir $nomeItem: ${e.message}');
  }
}

/// Tabelas que referenciam `talhao_id`.
const tabelasFilhasDoTalhao = <String>[
  'aplicacao',
  'colheita',
  'manejo',
  'plantio',
  'metricas_dia',
  'clima_dia',
  'previsao_clima',
];

/// Remove os registros filhos de um ou mais talhões (cascata feita no app,
/// para funcionar mesmo que o banco não tenha ON DELETE CASCADE).
Future<void> deletarFilhosDosTalhoes(
  SupabaseClient client,
  List<String> talhaoIds,
) async {
  if (talhaoIds.isEmpty) return;
  for (final tabela in tabelasFilhasDoTalhao) {
    await client.from(tabela).delete().inFilter('talhao_id', talhaoIds);
  }
}
