// lib/services/supabase_service.dart
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late final SupabaseClient _client;
  
  SupabaseClient get client => _client;

  // Inicialização
  Future<void> init() async {
    await Supabase.initialize(
      url: 'https://lqrelxniitrfhdcpbvwu.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxxcmVseG5paXRyZmhkY3Bidnd1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU3MDYyNjksImV4cCI6MjEwMTI4MjI2OX0.ZNltZGSP_OZtjH7EE3cJqKXqoh9p7A5PP8sN5dM9hyc',
    );
    _client = Supabase.instance.client;
    debugPrint('✅ Supabase inicializado');
  }

  // Verificar autenticação
  bool get isAuthenticated {
    final user = _client.auth.currentUser;
    debugPrint('🔐 Verificando autenticação: ${user != null}');
    if (user != null) {
      debugPrint('👤 Usuário: ${user.email} (${user.id})');
    }
    return user != null;
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
    return user?.email ?? '';
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
      await _client.auth.signOut();
      debugPrint('✅ Logout realizado');
    } catch (e) {
      debugPrint('❌ Erro no logout: $e');
      rethrow;
    }
  }
}