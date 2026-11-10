import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Cadastro
  Future<AuthResponse> signUp({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signUp(
      email: email,
      password: password,
    );
  }

  // Login
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Logout
  // (funciona offline: ver SupabaseService.signOut)
  Future<void> signOut() => SupabaseService().signOut();

  // Usuário atual
  User? get currentUser => _supabase.auth.currentUser;

  // Stream de mudanças de estado (logado/deslogado)
  Stream<AuthState> get authStateChanges =>
      _supabase.auth.onAuthStateChange;
}