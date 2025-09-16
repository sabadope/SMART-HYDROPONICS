import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import '../core/utils/preferences_helper.dart';
import '../core/utils/password_hash.dart';
import '../core/constants/app_constants.dart';
import '../shared/models/user_model.dart';

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
  }) async {
    print('🔄 Starting registration for: $email');
    print('🌐 Supabase URL: https://ihscuhuksaixfjmmttqa.supabase.co');
    print('🔑 Using anon key: ${AppConstants.supabaseAnonKey.substring(0, 20)}...');

    if (_isDevelopmentMode) {
      // Mock successful registration for development
      print('🧪 Development mode: Simulating registration...');
      await Future.delayed(const Duration(seconds: 2));
      await PreferencesHelper.setUserToken('mock_token_${DateTime.now().millisecondsSinceEpoch}');
      // Hash passwords for development mode too
      final hashedPassword = PasswordHash.hashPassword(password);
      final hashedConfirmPassword = PasswordHash.hashPassword(confirmPassword ?? password);
      await PreferencesHelper.setUserData('{"email": "$email", "user_metadata": {"full_name": "$fullName", "password": "$hashedPassword", "confirm_password": "$hashedConfirmPassword"}}');

      // Return a mock response - simplified for development
      print('✅ Development mode: Registration successful (mock)');
      return AuthResponse(
        user: User(
          id: 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
          email: email,
          userMetadata: {
            'full_name': fullName,
            'password': password,
            'confirm_password': confirmPassword ?? password
          },
          appMetadata: {},
          createdAt: DateTime.now().toIso8601String(),
          aud: 'authenticated',
          role: 'authenticated',
        ),
        session: null, // No session in mock mode
      );
    }

    try {
      print('📡 Testing Supabase connection...');

      // First, let's test if we can reach Supabase at all
      try {
        final testResponse = await _client.from('user_profiles').select('count').limit(1);
        print('✅ Supabase connection test successful');
      } catch (connectionError) {
        print('⚠️ Supabase connection test failed: $connectionError');
        // Continue with signup attempt anyway
      }

      print('📡 Sending registration request to Supabase...');
      print('📋 Registration data:');
      print('   - Email: $email');
      print('   - Full Name: $fullName');
      print('   - Password: [PROTECTED]');
      print('   - Confirm Password: [PROTECTED]');

      // Hash passwords for security before storing in user metadata
      final hashedPassword = PasswordHash.hashPassword(password);
      final hashedConfirmPassword = PasswordHash.hashPassword(confirmPassword ?? password);

      // Include ALL registration form data in user metadata (with hashed passwords)
      final userMetadata = {
        'full_name': fullName,
        'password': hashedPassword, // SHA-256 hashed password
        'confirm_password': hashedConfirmPassword, // SHA-256 hashed confirm password
        'original_password': password, // Keep original for Supabase auth (will be removed after successful registration)
        'original_confirm_password': confirmPassword ?? password, // Keep original for validation
      };

      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: userMetadata, // Pass ALL form data to Supabase
      );

      print('✅ Registration response received: ${response.user != null ? 'Success' : 'Failed'}');
      print('📋 Response details: User ID: ${response.user?.id}, Email: ${response.user?.email}');
      print('📋 User metadata: ${response.user?.userMetadata}');

      if (response.user != null) {
        print('💾 Saving user data...');
        await PreferencesHelper.setUserToken(response.session?.accessToken ?? '');
        await PreferencesHelper.setUserData(response.user!.toJson().toString());
        print('✅ User data saved successfully');
      }

      return response;
    } catch (e) {
      print('❌ Registration error: $e');
      print('🔍 Error type: ${e.runtimeType}');
      print('📝 Error toString: ${e.toString()}');
      print('📋 Error details: ${e}');

      // Provide more user-friendly error messages
      final errorString = e.toString().toLowerCase();

      if (errorString.contains('failed host lookup') ||
          errorString.contains('no address associated with hostname') ||
          errorString.contains('network') ||
          errorString.contains('connection') ||
          errorString.contains('socket') ||
          errorString.contains('timeout')) {
        print('🌐 Network-related error detected');
        print('💡 This usually means Flutter cannot connect to Supabase');
        print('🔧 Check: 1) Internet connection 2) Network permissions 3) Supabase project status');
        throw Exception('Network connection failed. Please check your internet connection and try again.');
      } else if (errorString.contains('invalid login credentials')) {
        throw Exception('Invalid email or password. Please try again.');
      } else if (errorString.contains('user already registered') ||
                  errorString.contains('already exists')) {
        throw Exception('An account with this email already exists. Please try logging in instead.');
      } else if (errorString.contains('weak password') ||
                  errorString.contains('password')) {
        throw Exception('Password is too weak. Please use at least 6 characters with letters and numbers.');
      } else if (errorString.contains('invalid email') ||
                  errorString.contains('email')) {
        throw Exception('Please enter a valid email address.');
      } else if (errorString.contains('ssl') ||
                  errorString.contains('certificate') ||
                  errorString.contains('handshake')) {
        print('🔒 SSL/Certificate error detected');
        print('💡 This means Flutter cannot establish secure connection to Supabase');
        print('🔧 Check: 1) Network security config 2) SSL settings 3) Platform permissions');
        throw Exception('Connection security error. Please try again or contact support.');
      } else {
        print('❓ Unknown error type, showing generic message');
        print('🔍 Full error analysis:');
        print('   - Contains "failed": ${errorString.contains('failed')}');
        print('   - Contains "error": ${errorString.contains('error')}');
        print('   - Contains "exception": ${errorString.contains('exception')}');
        throw Exception('Registration failed. Please try again or contact support if the problem persists.');
      }
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