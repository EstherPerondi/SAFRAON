// lib/services/fazenda_service.dart  (versão offline-first com PowerSync)
//
// Mesma API pública da versão anterior (getAll, getById, create, update,
// delete, existsWithName), então FazendaProvider e as telas não mudam.
// Leitura e escrita agora acontecem no SQLite local; o PowerSync cuida de
// enviar/receber do Supabase quando houver rede.
import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';

import '../models/fazenda_model.dart';
import '../powersync/powersync_service.dart';
import 'supabase_service.dart';
import 'delete_helper.dart';

class FazendaService {
  PowerSyncDatabase get _db => PowerSyncService().db;

  // O join com "estados" agora é um LEFT JOIN local. O resultado é
  // remontado no formato aninhado que FazendaModel.fromJson já espera.
  static const _selectComEstado = '''
    SELECT f.*, e.nome AS estado_nome
    FROM fazenda f
    LEFT JOIN estados e ON e.id = f.estado_id
  ''';

  FazendaModel _fromRow(Map<String, dynamic> row) {
    return FazendaModel.fromJson({
      ...row,
      'estados': {'nome': row['estado_nome']},
    });
  }

  Future<List<FazendaModel>> getAll() async {
    try {
      // Linhas recém-criadas offline ainda não têm created_at (o servidor
      // preenche depois); COALESCE mantém elas no topo da lista.
      final rows = await _db.getAll('''
        $_selectComEstado
        ORDER BY COALESCE(f.created_at, '9999') DESC
      ''');
      return rows.map<FazendaModel>(_fromRow).toList();
    } catch (e) {
      debugPrint('❌ Erro ao buscar fazendas: $e');
      return [];
    }
  }

  Future<FazendaModel?> getById(String id) async {
    try {
      final rows = await _db.getAll('$_selectComEstado WHERE f.id = ?', [id]);
      return rows.isEmpty ? null : _fromRow(rows.first);
    } catch (e) {
      debugPrint('❌ Erro ao buscar fazenda: $e');
      return null;
    }
  }

  Future<FazendaModel?> create(FazendaModel fazenda) async {
    try {
      final userId = SupabaseService().currentUserId;
      if (userId.isEmpty) {
        throw Exception('Usuário não autenticado. Faça login primeiro.');
      }
      if (fazenda.nome.trim().isEmpty) {
        throw Exception('Nome da fazenda não pode estar vazio');
      }
      if (fazenda.estadoId.trim().isEmpty) {
        throw Exception('Estado da fazenda não pode estar vazio');
      }

      // O id é gerado AQUI (uuid()), não pelo banco — é o que permite
      // criar registros sem internet.
      final res = await _db.execute(
        'INSERT INTO fazenda(id, nome, usuario_id, estado_id) '
        'VALUES(uuid(), ?, ?, ?) RETURNING id',
        [fazenda.nome.trim(), userId, fazenda.estadoId],
      );
      return getById(res.first['id'] as String);
    } catch (e) {
      debugPrint('❌ Erro ao criar fazenda: $e');
      return null;
    }
  }

  Future<FazendaModel?> update(FazendaModel fazenda) async {
    try {
      if (fazenda.id.isEmpty) throw Exception('ID da fazenda não informado');

      await _db.execute(
        'UPDATE fazenda SET nome = ?, estado_id = ? WHERE id = ?',
        [fazenda.nome.trim(), fazenda.estadoId, fazenda.id],
      );
      return getById(fazenda.id);
    } catch (e) {
      debugPrint('❌ Erro ao atualizar fazenda: $e');
      return null;
    }
  }

  Future<bool> delete(String id) async {
    try {
      if (id.isEmpty) throw Exception('ID da fazenda não informado');

      // Localmente não existe ON DELETE CASCADE, então removemos os filhos
      // na mesma transação para a UI não mostrar registros órfãos.
      await _db.writeTransaction((tx) async {
        const filhos = [
          'plantio',
          'aplicacao',
          'manejo',
          'colheita',
          'clima_dia',
          'metricas_dia',
          'previsao_clima',
        ];
        for (final tabela in filhos) {
          await tx.execute(
            'DELETE FROM $tabela WHERE talhao_id IN '
            '(SELECT id FROM talhao WHERE fazenda_id = ?)',
            [id],
          );
        }
        await tx.execute('DELETE FROM talhao WHERE fazenda_id = ?', [id]);
        await tx.execute('DELETE FROM fazenda WHERE id = ?', [id]);
      });
      return true;
    } catch (e) {
      debugPrint('❌ Erro ao deletar fazenda: $e');
      return false;
    }
    }

    print('🗑️ Deletando fazenda: $id');

    // Cascata feita no app: talhões da fazenda e seus registros vinculados
    final talhoes = await _client.from('talhao').select('id').eq('fazenda_id', id);
    final talhaoIds = talhoes.map((t) => t['id'].toString()).toList();

    if (talhaoIds.isNotEmpty) {
      await deletarFilhosDosTalhoes(_client, talhaoIds);
      await _client.from('talhao').delete().eq('fazenda_id', id);
    }

    await deletarPorId(_client, _table, id, nomeItem: 'fazenda');

    print('✅ Fazenda deletada com sucesso!');
    return true;
  }

  Future<bool> existsWithName(String nome) async {
    try {
      final userId = SupabaseService().currentUserId;
      final rows = await _db.getAll(
        'SELECT id FROM fazenda WHERE nome = ? AND usuario_id = ? LIMIT 1',
        [nome.trim(), userId],
      );
      return rows.isNotEmpty;
    } catch (e) {
      debugPrint('❌ Erro ao verificar nome: $e');
      return false;
    }
  }
}