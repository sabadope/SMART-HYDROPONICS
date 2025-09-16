import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/constants/app_constants.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: AppConstants.supabaseUrl,
      anonKey: AppConstants.supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;

  // Auth helpers
  static User? get currentUser => client.auth.currentUser;
  static Session? get currentSession => client.auth.currentSession;
  static Stream<AuthState> get authStateChanges => client.auth.onAuthStateChange;

  // Database helpers
  static SupabaseQueryBuilder from(String table) => client.from(table);
}