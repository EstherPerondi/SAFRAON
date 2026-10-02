// lib/powersync/supabase_connector.dart
//
// Liga o PowerSync ao Supabase:
//  - fetchCredentials: entrega o JWT do Supabase Auth ao PowerSync
//  - uploadData: envia ao Postgres as escritas feitas offline
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';

/// URL da instância PowerSync. Passe na build, sem commitar:
/// flutter run --dart-define=POWERSYNC_URL=https://SEU-ID.powersync.journeyapps.com
const powersyncUrl = String.fromEnvironment('https://6abe720a3b1803753bce10f9.powersync.journeyapps.com');

/// Erros do Postgres que NÃO adianta tentar de novo (dado inválido,
/// violação de constraint, sem permissão). Se não descartássemos,
/// a fila travaria para sempre nesse item.
final _codigosFatais = <RegExp>[
  RegExp(r'^22...$'), // dados inválidos
  RegExp(r'^23...$'), // violação de integridade (FK, unique, not null)
  RegExp(r'^42501$'), // sem permissão (RLS)
];

bool _ehFatal(PostgrestException e) =>
    e.code != null && _codigosFatais.any((r) => r.hasMatch(e.code!));

class SupabaseConnector extends PowerSyncBackendConnector {
  SupabaseConnector(this.db) {
    _authSub = SupabaseService().client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.tokenRefreshed) {
        prefetchCredentials();
      }
    });
  }

  final PowerSyncDatabase db;
  StreamSubscription<AuthState>? _authSub;

  void dispose() => _authSub?.cancel();

  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    final client = SupabaseService().client;

    // Se o token expirou, tenta renovar (só funciona online).
    var session = client.auth.currentSession;
    if (session == null) return null;
    if (session.isExpired) {
      session = (await client.auth.refreshSession()).session;
      if (session == null) return null;
    }

    return PowerSyncCredentials(
      endpoint: powersyncUrl,
      token: session.accessToken,
      userId: session.user.id,
      expiresAt: session.expiresAt == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000),
    );
  }

  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) return;

    final rest = SupabaseService().client.rest;
    final talhoesParaGeocodificar = <String>{};

    for (final op in transaction.crud) {
      try {
        final tabela = rest.from(op.table);
        switch (op.op) {
          case UpdateType.put:
            final dados = Map<String, dynamic>.of(op.opData ?? {});
            dados['id'] = op.id;
            await tabela.upsert(dados);
          case UpdateType.patch:
            await tabela.update(op.opData!).eq('id', op.id);
          case UpdateType.delete:
            await tabela.delete().eq('id', op.id);
        }

        if (op.table == 'talhao' && op.op != UpdateType.delete) {
          talhoesParaGeocodificar.add(op.id);
        }
      } on PostgrestException catch (e) {
        if (_ehFatal(e)) {
          // Descarta só ESTE item e segue com os demais da transação.
          debugPrint('⚠️ PowerSync: descartando ${op.op.name} em '
              '${op.table}/${op.id} (código ${e.code}): ${e.message}');
        } else {
          // Erro temporário (rede, 5xx): mantém a fila e tenta depois.
          rethrow;
        }
      }
    }

    await transaction.complete();

    // Pós-upload: o talhão agora EXISTE no Postgres, então a Edge Function
    // consegue geocodificá-lo. Ela grava latitude/longitude no servidor e
    // o PowerSync traz de volta para o aparelho sozinho.
    await _posUploadTalhoes(talhoesParaGeocodificar);
  }

  Future<void> _posUploadTalhoes(Set<String> ids) async {
    if (ids.isEmpty) return;
    final fn = SupabaseService().client.functions;

    for (final id in ids) {
      try {
        await fn.invoke('geocodificar-talhao', body: {'talhao_id': id});
      } catch (e) {
        debugPrint('⚠️ Geocodificação do talhão $id falhou (segue sem): $e');
      }
    }

    // Já traz clima/previsão do talhão novo sem esperar o cron das 06:00.
    unawaited(_chamarSemFalhar('atualizar-clima'));
    unawaited(_chamarSemFalhar('atualizar-previsao'));
  }

  Future<void> _chamarSemFalhar(String funcao) async {
    try {
      await SupabaseService().client.functions.invoke(funcao);
    } catch (e) {
      debugPrint('⚠️ $funcao: $e');
    }
  }
}