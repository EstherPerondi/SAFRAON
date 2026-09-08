// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  late final SupabaseClient _client;
  
  SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase não inicializado!');
    }
    return _client;
  }

  // Inicialização
  Future<void> init() async {
    await Supabase.initialize(
      url: 'https://lqrelxniitrfhdcpbvwu.supabase.co',
      anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxxcmVseG5paXRyZmhkY3Bidnd1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU3MDYyNjksImV4cCI6MjEwMTI4MjI2OX0.ZNltZGSP_OZtjH7EE3cJqKXqoh9p7A5PP8sN5dM9hyc',
    );
    _client = Supabase.instance.client;
    print('✅ Supabase inicializado');
  }

  // Verificar autenticação
  bool get isAuthenticated {
    final user = _client.auth.currentUser;
    print('🔐 Verificando autenticação: ${user != null}');
    if (user != null) {
      print('👤 Usuário: ${user.email} (${user.id})');
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
        print('⚠️ Nenhum usuário autenticado');
        return '';
      }
      print('✅ User ID obtido: ${user.id}');
      return user.id;
    } catch (e) {
      print('❌ Erro ao obter user ID: $e');
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
      print('✅ Login realizado: ${response.user?.email}');
      return response;
    } catch (e) {
      print('❌ Erro no login: $e');
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
      print('✅ Usuário registrado: ${response.user?.email}');
      return response;
    } catch (e) {
      print('❌ Erro no registro: $e');
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      print('✅ Logout realizado');
    } catch (e) {
      print('❌ Erro no logout: $e');
      rethrow;
    }
  }
}