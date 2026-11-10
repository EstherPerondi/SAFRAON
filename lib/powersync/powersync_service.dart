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
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _conectando = false;

  // Id do usuário dono dos dados que estão no banco local. Se outra conta
  // entrar neste aparelho, o banco local é limpo antes de sincronizar.
  static const _kDono = 'safraon_powersync_dono';

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // No navegador (Netlify) não existe pasta de arquivos: o PowerSync usa
    // IndexedDB/OPFS e o "path" é só o nome do banco. path_provider não
    // funciona na web e derrubava o app antes do runApp.
    final String dbPath;
    if (kIsWeb) {
      dbPath = 'safraon.db';
    } else {
      final dir = await getApplicationSupportDirectory();
      dbPath = p.join(dir.path, 'safraon.db');
    }
    db = PowerSyncDatabase(schema: schema, path: dbPath);
    await db.initialize();

    final auth = SupabaseService().client.auth;

    // Já havia sessão salva? Conecta (funciona offline: só lê o banco local
    // e sincroniza quando a rede voltar).
    final atual = auth.currentUser;
    if (auth.currentSession != null && atual != null) {
      await _conectarComo(atual.id);
    }

    // Sem internet com token vencido, a sessão só volta depois (initialSession
    // / tokenRefreshed), então esses eventos também precisam conectar.
    _authSub = auth.onAuthStateChange.listen((data) async {
      switch (data.event) {
        case AuthChangeEvent.signedIn:
        case AuthChangeEvent.initialSession:
        case AuthChangeEvent.tokenRefreshed:
          final user = data.session?.user;
          if (user != null && _connector == null) await _conectarComo(user.id);
        case AuthChangeEvent.signedOut:
          await _desconectarELimpar();
        default:
          break;
      }
    });

    debugPrint('✅ PowerSync inicializado');
  }

  /// Conecta o sync para [userId]. Se o banco local pertencia a OUTRO
  /// usuário, limpa antes (nunca mistura dados de contas diferentes).
  Future<void> _conectarComo(String userId) async {
    if (_conectando || _connector != null) return;
    _conectando = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final dono = prefs.getString(_kDono);
      if (dono != null && dono != userId) {
        await db.disconnectAndClear();
      }
      await prefs.setString(_kDono, userId);
      _conectar();
    } finally {
      _conectando = false;
    }
  }

  void _conectar() {
    _connector = SupabaseConnector(db);
    // Não usar await: connect() mantém a conexão de sync viva.
    unawaited(db.connect(connector: _connector!));
  }

  Future<void> _desconectarELimpar() async {
    _connector?.dispose();
    _connector = null;
    // Se há escritas feitas offline que ainda não subiram, NÃO apaga o banco
    // local (senão o trabalho seria perdido): só desconecta. Elas sobem no
    // próximo login da mesma conta; se outra conta entrar, _conectarComo
    // limpa o banco.
    var pendentes = false;
    try {
      pendentes = await hasPendingUploads();
    } catch (_) {}
    if (pendentes) {
      await db.disconnect();
      return;
    }
    // Sem pendências: apaga os dados locais do usuário que saiu (privacidade
    // em aparelho compartilhado).
    await db.disconnectAndClear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kDono);
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