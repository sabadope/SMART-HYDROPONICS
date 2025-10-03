import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../core/utils/preferences_helper.dart';
import '../core/utils/password_hash.dart';
import '../core/constants/app_constants.dart';
import '../shared/models/user_model.dart';
import 'admin_service.dart';

class AuthService {
  static final SupabaseClient _client = SupabaseConfig.client;

  // Development mode flag - set to true for testing without Supabase
  static const bool _isDevelopmentMode = false; // Production mode - data stored in Supabase

  // Sign up with email and password
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? confirmPassword,
    required String role, // Add role parameter
    bool isAdminRequest = false, // Flag for admin approval requests
  }) async {
    print('🔄 Starting registration for: $email');
    print('👤 Full Name: $fullName');
    print('👥 Role: $role');
    print('👑 Is Admin Request: $isAdminRequest');

    if (_isDevelopmentMode) {
      print('🧪 Development mode: Simulating registration...');
      await Future.delayed(const Duration(seconds: 2));
      await PreferencesHelper.setUserToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
      final hashedPassword = PasswordHash.hashPassword(password);
      final hashedConfirmPassword = PasswordHash.hashPassword(confirmPassword ?? password);
      await PreferencesHelper.setUserData('{"email": "$email", "user_metadata": {"full_name": "$fullName", "role": "$role", "password": "$hashedPassword", "confirm_password": "$hashedConfirmPassword"}}');

      print('✅ Development mode: Registration successful (mock)');
      return AuthResponse(
        user: User(
          id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          userMetadata: {
            'full_name': fullName,
            'role': role,
            'password': password,
            'confirm_password': confirmPassword ?? password
          },
          appMetadata: {},
          createdAt: DateTime.now().toIso8601String(),
          aud: 'authenticated',
          role: 'authenticated',
        ),
        session: null,
      );
    }

    try {
      print('🔐 Calling Supabase auth.signUp...');

      // Simple user metadata - just store role for now
      final userMetadata = {
        'full_name': fullName,
        'role': role,
      };

      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: userMetadata,
      );

      print('✅ Registration response: ${response.user != null ? 'SUCCESS' : 'FAILED'}');

      if (response.user != null) {
        print('🆔 User ID: ${response.user!.id}');
        await PreferencesHelper.setUserToken(response.session?.accessToken ?? '');
        await PreferencesHelper.setUserData(response.user!.toJson().toString());

        // Note: User profile creation skipped - using user metadata only
        // Admin approval system works with local storage

        // Handle admin requests with local storage
        if (isAdminRequest) {
          await AdminService.createAdminRequest(
            userId: response.user!.id,
            email: email,
            fullName: fullName,
          );
        }

        print('🎉 Registration completed successfully!');
      }

      return response;
    } catch (e) {
      print('❌ Registration error: $e');
      throw Exception('Registration failed: ${e.toString()}');
    }
  }



  // Sign in with email and password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    if (_isDevelopmentMode) {
      // Mock successful login for development
      print('🧪 Development mode: Simulating login...');
      await Future.delayed(const Duration(seconds: 2));
      await PreferencesHelper.setUserToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
      // Hash password for development mode consistency
      final hashedPassword = PasswordHash.hashPassword(password);
      await PreferencesHelper.setUserData('{"email": "$email", "user_metadata": {"full_name": "Test User", "password": "$hashedPassword"}}');

      print('✅ Development mode: Login successful (mock)');
      return AuthResponse(
        user: User(
          id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          userMetadata: {'full_name': 'Test User'},
          appMetadata: {},
          createdAt: DateTime.now().toIso8601String(),
          aud: 'authenticated',
          role: 'authenticated',
        ),
        session: null, // No session in mock mode
      );
    }

    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        await PreferencesHelper.setUserToken(response.session?.accessToken ?? '');
        await PreferencesHelper.setUserData(response.user!.toJson().toString());
      }

      return response;
    } catch (e) {
      // Provide more user-friendly error messages
      if (e.toString().contains('Failed host lookup') ||
          e.toString().contains('No address associated with hostname')) {
        throw Exception('Network connection failed. Please check your internet connection and try again.');
      } else if (e.toString().contains('Invalid login credentials')) {
        throw Exception('Invalid email or password. Please check your credentials and try again.');
      } else if (e.toString().contains('Email not confirmed')) {
        throw Exception('Please check your email and confirm your account before signing in.');
      } else {
        throw Exception('Sign in failed: ${e.toString().replaceAll('Exception:', '').trim()}');
      }
    }
  }

  // Sign out
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
      await PreferencesHelper.clearUserToken();
      await PreferencesHelper.clearUserData();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  // Get current user
  static User? getCurrentUser() {
    return SupabaseConfig.currentUser;
  }

  // Get current user as UserModel
  static UserModel? getCurrentUserModel() {
    final user = SupabaseConfig.currentUser;
    if (user != null) {
      return UserModel.fromJson(user.toJson());
    }
    return null;
  }

  // Check if user is authenticated
  static bool isAuthenticated() {
    return SupabaseConfig.currentUser != null;
  }

  // Get current user role from user metadata
  static Future<String?> getCurrentUserRole() async {
    final user = SupabaseConfig.currentUser;
    if (user == null) {
      print('No current user found');
      return null;
    }

    // Get role from user metadata (stored during registration)
    final role = user.userMetadata?['role'] as String?;
    print('User role from metadata: $role');

    return role ?? 'user'; // Default to user if no role found
  }

  // Get current user role synchronously (from cache/metadata)
  static String? getCurrentUserRoleSync() {
    final user = SupabaseConfig.currentUser;
    return user?.userMetadata?['role'] as String?;
  }

  // Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // Update user profile
  static Future<void> updateProfile({
    String? fullName,
    String? avatarUrl,
  }) async {
    try {
      final updates = <String, dynamic>{};
      if (fullName != null) updates['full_name'] = fullName;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      await _client.auth.updateUser(
        UserAttributes(data: updates),
      );
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  // Listen to auth state changes
  static Stream<AuthState> get authStateChanges =>
      SupabaseConfig.authStateChanges;
}