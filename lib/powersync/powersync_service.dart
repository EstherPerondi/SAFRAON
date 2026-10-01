// lib/powersync/powersync_service.dart
//
// Abre o banco local (SQLite) e liga/desliga a sincronização de acordo
// com o login do Supabase. Chame `await PowerSyncService().init()` no
// main(), logo depois de `SupabaseService().init()`.
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../services/supabase_service.dart';
import 'schema.dart';
import 'supabase_connector.dart';

class PowerSyncService {
  static final PowerSyncService _instance = PowerSyncService._internal();
  factory PowerSyncService() => _instance;
  PowerSyncService._internal();

  late final PowerSyncDatabase db;
  SupabaseConnector? _connector;
  StreamSubscription<AuthState>? _authSub;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final dir = await getApplicationSupportDirectory();
    db = PowerSyncDatabase(
      schema: schema,
      path: p.join(dir.path, 'safraon.db'),
    );
    await db.initialize();

    final auth = SupabaseService().client.auth;

    // Já havia sessão salva? Conecta (funciona offline: só lê o banco local
    // e sincroniza quando a rede voltar).
    if (auth.currentSession != null) _conectar();

    _authSub = auth.onAuthStateChange.listen((data) async {
      switch (data.event) {
        case AuthChangeEvent.signedIn:
          if (_connector == null) _conectar();
        case AuthChangeEvent.signedOut:
          await _desconectarELimpar();
        default:
          break;
      }
    });

    debugPrint('✅ PowerSync inicializado');
  }

  void _conectar() {
    _connector = SupabaseConnector(db);
    // Não usar await: connect() mantém a conexão de sync viva.
    unawaited(db.connect(connector: _connector!));
  }

  Future<void> _desconectarELimpar() async {
    _connector?.dispose();
    _connector = null;
    // Apaga os dados locais do usuário que saiu (privacidade em aparelho
    // compartilhado). ATENÇÃO: isso também descarta escritas ainda não
    // enviadas — por isso a tela de logout deve checar hasPendingUploads().
    await db.disconnectAndClear();
  }

  /// true se há alterações feitas offline que ainda não subiram.
  Future<bool> hasPendingUploads() async {
    final stats = await db.getUploadQueueStats();
    return stats.count > 0;
  }

  /// Espera o primeiro download completo (útil logo após o primeiro login).
  Future<void> waitForFirstSync() => db.waitForFirstSync();

  /// Status (conectado, enviando, baixando, último sync) para mostrar na UI.
  Stream<SyncStatus> get statusStream => db.statusStream;

  void dispose() => _authSub?.cancel();
}