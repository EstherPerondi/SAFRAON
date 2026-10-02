// lib/powersync/db_helpers.dart
//
// Funções de apoio usadas pelos services offline-first.
// Nomes de tabela/coluna vêm sempre do código (nunca do usuário), e os
// VALORES sempre vão como parâmetros "?", então não há risco de SQL injection.
import 'package:powersync/powersync.dart';

/// Subconsulta: ids dos talhões das fazendas do usuário logado.
/// Use com um parâmetro: [userId].
const talhoesDoUsuarioSql = '''
  SELECT t.id FROM talhao t
  JOIN fazenda f ON f.id = t.fazenda_id
  WHERE f.usuario_id = ?
''';

/// INSERT genérico. O id é gerado AQUI no aparelho (uuid()), o que
/// permite criar registros sem internet. Retorna o id criado.
Future<String> insertRow(
  PowerSyncDatabase db,
  String table,
  Map<String, dynamic> values,
) async {
  final cols = values.keys.toList();
  final marks = List.filled(cols.length, '?').join(', ');
  final res = await db.execute(
    'INSERT INTO $table(id, ${cols.join(', ')}) '
    'VALUES(uuid(), $marks) RETURNING id',
    cols.map<Object?>((c) => values[c]).toList(),
  );
  return res.first['id'] as String;
}

/// UPDATE genérico por id.
Future<void> updateRow(
  PowerSyncDatabase db,
  String table,
  String id,
  Map<String, dynamic> values,
) async {
  final cols = values.keys.toList();
  final sets = cols.map((c) => '$c = ?').join(', ');
  await db.execute(
    'UPDATE $table SET $sets WHERE id = ?',
    [...cols.map<Object?>((c) => values[c]), id],
  );
}