// lib/services/supabase_service.dart
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// true enquanto o usuário está no fluxo "esqueci minha senha"
/// (código validado ou link do email aberto). O AuthGate usa isso para
/// mostrar a tela de nova senha em vez da tela principal.
final ValueNotifier<bool> recuperandoSenha = ValueNotifier<bool>(false);

/// true se o erro foi de rede (sem internet / servidor inalcançável).
/// Usado por login e cadastro para explicar o que acontece offline.
bool ehErroDeRede(Object e) {
  if (e is AuthRetryableFetchException) return true;
  if (e is http.ClientException) return true;
  final s = e.toString();
  return s.contains('SocketException') ||
      s.contains('Failed host lookup') ||
      s.contains('XMLHttpRequest') ||
      s.contains('TimeoutException');
}

/// Converte qualquer erro em uma mensagem em português para mostrar ao
/// usuário. Use sempre que for exibir um erro na tela, em vez de e.message
/// ou e.toString() (que vêm em inglês das bibliotecas).
/// Mensagens que o próprio app lança com Exception('...') já estão em
/// português e passam direto.
String mensagemDeErro(Object e) {
  if (ehErroDeRede(e)) {
    return 'Sem conexão com a internet. Verifique e tente novamente.';
  }
  if (e is AuthException) return _traduzirErroAuth(e);

  // Códigos de erro do Postgres (vindos do servidor)
  if (e is PostgrestException) {
    final code = e.code ?? '';
    if (code == '23505') return 'Já existe um registro com esses dados.';
    if (code == '23503') {
      return 'Este registro está ligado a outros dados e não pode ser '
          'alterado ou excluído.';
    }
    if (code == '23502') return 'Preencha todos os campos obrigatórios.';
    if (code == '42501') return 'Você não tem permissão para fazer isso.';
    if (code == 'PGRST116') return 'Registro não encontrado.';
    if (code == 'PGRST301' || code == 'PGRST303') {
      return 'Sua sessão expirou. Entre novamente.';
    }
    if (code.startsWith('22')) return 'Dados inválidos. Confira os campos.';
  }

  final s = e.toString();
  // Exception('texto') criada pelo próprio app: já está em português.
  if (s.startsWith('Exception: ')) return s.substring('Exception: '.length);

  // Erros do banco local (SQLite) e do servidor, que chegam em inglês
  final baixo = s.toLowerCase();
  if (baixo.contains('row-level security')) {
    return 'Você não tem permissão para fazer isso.';
  }
  if (baixo.contains('unique constraint') || baixo.contains('duplicate key')) {
    return 'Já existe um registro com esses dados.';
  }
  if (baixo.contains('foreign key')) {
    return 'Este registro está ligado a outros dados e não pode ser '
        'alterado ou excluído.';
  }
  if (baixo.contains('not null') || baixo.contains('null value')) {
    return 'Preencha todos os campos obrigatórios.';
  }
  return 'Ocorreu um erro inesperado. Tente novamente.';
}

String _traduzirErroAuth(AuthException e) {
  final msg = e.message.toLowerCase();
  final code = (e.code ?? '').toLowerCase();
  final status = e.statusCode?.toString();

  bool tem(String t) => msg.contains(t) || code.contains(t);

  if (status == '429' ||
      tem('rate limit') ||
      tem('rate_limit') ||
      tem('too many') ||
      tem('security purposes')) {
    return 'Muitas tentativas. Aguarde alguns minutos e tente novamente.';
  }
  if (tem('invalid login credentials') || tem('invalid_credentials')) {
    return 'Email ou senha incorretos.';
  }
  if (tem('email not confirmed') || tem('email_not_confirmed')) {
    return 'Email ainda não confirmado. Verifique sua caixa de entrada.';
  }
  if (tem('already registered') ||
      tem('already been registered') ||
      tem('user_already_exists') ||
      tem('email_exists')) {
    return 'Este email já está cadastrado.';
  }
  if (tem('same_password') || tem('different from the old password')) {
    return 'A nova senha deve ser diferente da senha atual.';
  }
  if (tem('weak_password') || tem('password should be')) {
    return 'Senha muito fraca. Use uma senha mais forte.';
  }
  if (tem('otp_expired') ||
      tem('token has expired') ||
      tem('invalid token') ||
      tem('otp')) {
    return 'Código inválido ou expirado. Peça um novo código.';
  }
  if (tem('email_address_invalid') ||
      tem('unable to validate email') ||
      tem('invalid format') ||
      tem('is invalid')) {
    return 'Email inválido.';
  }
  if (tem('signup_disabled') || tem('signups not allowed')) {
    return 'Novos cadastros estão desativados no momento.';
  }
  if (tem('user not found') || tem('user_not_found')) {
    return 'Usuário não encontrado.';
  }
  if (tem('session') || tem('jwt') || tem('refresh_token')) {
    return 'Sua sessão expirou. Entre novamente.';
  }
  return 'Não foi possível concluir. Tente novamente.';
}

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late final SupabaseClient _client;

  // Último usuário logado, guardado no aparelho. Com internet o Supabase
  // renova o token sozinho; sem internet (token vencido) ele não consegue
  // restaurar a sessão e o app cairia na tela de login. Este registro deixa
  // o usuário continuar usando o app offline (os dados locais do PowerSync
  // já estão no aparelho). Só é apagado no logout.
  static const _kUid = 'safraon_login_usuario_id';
  static const _kEmail = 'safraon_login_email';
  String? _uidLocal;
  String? _emailLocal;

  /// true se há sessão ativa OU um login anterior neste aparelho.
  bool get temLoginLocal =>
      _client.auth.currentSession != null || _uidLocal != null;

  void _guardarLoginLocal(String id, String? email) {
    _uidLocal = id;
    _emailLocal = email;
    SharedPreferences.getInstance().then((p) {
      p.setString(_kUid, id);
      if (email != null) p.setString(_kEmail, email);
    });
  }

  void _limparLoginLocal() {
    _uidLocal = null;
    _emailLocal = null;
    SharedPreferences.getInstance().then((p) {
      p.remove(_kUid);
      p.remove(_kEmail);
    });
  }

  SupabaseClient get client => _client;

  // Inicialização
  Future<void> init() async {
    await Supabase.initialize(
      url: 'https://lqrelxniitrfhdcpbvwu.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxxcmVseG5paXRyZmhkY3Bidnd1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU3MDYyNjksImV4cCI6MjEwMTI4MjI2OX0.ZNltZGSP_OZtjH7EE3cJqKXqoh9p7A5PP8sN5dM9hyc',
    );
    _client = Supabase.instance.client;

    final prefs = await SharedPreferences.getInstance();
    _uidLocal = prefs.getString(_kUid);
    _emailLocal = prefs.getString(_kEmail);
    final atual = _client.auth.currentUser;
    if (atual != null) _guardarLoginLocal(atual.id, atual.email);

    // Link de recuperação aberto no navegador (fluxo implícito)
    if (kIsWeb && Uri.base.fragment.contains('type=recovery')) {
      recuperandoSenha.value = true;
    }
    // Link de recuperação (PKCE) ou código validado: evento passwordRecovery
    _client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.passwordRecovery) {
        recuperandoSenha.value = true;
      }
      // Mantém o registro do login local em dia
      final user = data.session?.user;
      if (data.event == AuthChangeEvent.signedOut) {
        _limparLoginLocal();
      } else if (user != null) {
        _guardarLoginLocal(user.id, user.email);
      }
    });
    debugPrint('✅ Supabase inicializado');
  }

  // Verificar autenticação
  bool get isAuthenticated {
    final user = _client.auth.currentUser;
    debugPrint('🔐 Verificando autenticação: ${user != null}');
    if (user != null) {
      debugPrint('👤 Usuário: ${user.email} (${user.id})');
    }
    return user != null || _uidLocal != null;
  }

  // Obter usuário atual
  User? get currentUser {
    return _client.auth.currentUser;
  }

  // Obter ID do usuário atual
  String get currentUserId {
    try {
      final user = _client.auth.currentUser;
      if (user == null) {
        // Offline com token vencido: usa o último usuário logado no aparelho
        if (_uidLocal != null) return _uidLocal!;
        debugPrint('⚠️ Nenhum usuário autenticado');
        return '';
      }
      debugPrint('✅ User ID obtido: ${user.id}');
      return user.id;
    } catch (e) {
      debugPrint('❌ Erro ao obter user ID: $e');
      return '';
    }
  }

  // Obter email do usuário
  String get currentUserEmail {
    final user = _client.auth.currentUser;
    return user?.email ?? _emailLocal ?? '';
  }

  // Login
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      debugPrint('✅ Login realizado: ${response.user?.email}');
      return response;
    } catch (e) {
      debugPrint('❌ Erro no login: $e');
      rethrow;
    }
  }

  // Registro
  Future<AuthResponse> signUp(String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      debugPrint('✅ Usuário registrado: ${response.user?.email}');
      return response;
    } catch (e) {
      debugPrint('❌ Erro no registro: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      try {
        await _client.auth.signOut();
      } catch (e) {
        // Sem internet não dá para avisar o servidor, mas dá para sair
        // deste aparelho (escopo local).
        if (!ehErroDeRede(e)) rethrow;
        try {
          await _client.auth.signOut(scope: SignOutScope.local);
        } catch (_) {}
      }
      _limparLoginLocal();
      debugPrint('✅ Logout realizado');
    } catch (e) {
      debugPrint('❌ Erro no logout: $e');
      rethrow;
    }
  }
}