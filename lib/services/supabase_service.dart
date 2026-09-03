import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient get client => Supabase.instance.client;

  bool get isAuthenticated =>
      Supabase.instance.client.auth.currentUser != null;

  String get currentUserId {
    final user = Supabase.instance.client.auth.currentUser;
    print('👤 Usuário atual: ${user?.id ?? 'Nenhum'}');
    return user?.id ?? '';
  }

  String get currentUserEmail {
    return Supabase.instance.client.auth.currentUser?.email ?? '';
  }

  // Pegar dados do usuário atual
  Map<String, dynamic>? get currentUserData {
    return Supabase.instance.client.auth.currentUser?.userMetadata;
  }
}