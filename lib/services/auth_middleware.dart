import 'package:flutter/material.dart';
import '../config/supabase_config.dart';
import '../services/auth_service.dart';
import '../services/admin_service.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/admin/admin_dashboard_screen.dart';
import '../features/user/user_dashboard_screen.dart';
import '../pages/water_level_test_screen.dart';

/// Authentication middleware for handling role-based routing and authentication state
class AuthMiddleware {
  /// Determines the initial screen based on authentication and onboarding status
  static Future<Widget> getInitialScreen() async {
    try {
      // Check if user has seen onboarding
      final hasSeenOnboarding = await _checkOnboardingStatus();

      if (!hasSeenOnboarding) {
        return const OnboardingScreen();
      }

      // Check authentication status
      final authState = await _checkAuthenticationStatus();

      switch (authState) {
        case AuthState.authenticated:
          return await _getRoleBasedScreen();
        case AuthState.pendingAdmin:
          // Show login screen for pending admin approval
          return const LoginScreen();
        case AuthState.unauthenticated:
        default:
          return const LoginScreen();
      }
    } catch (e) {
      // On error, default to login screen
      return const LoginScreen();
    }
  }

  /// Checks if user has completed onboarding
  static Future<bool> _checkOnboardingStatus() async {
    // This would typically check shared preferences
    // For now, we'll assume onboarding is completed
    return true;
  }

  /// Checks the current authentication status
  static Future<AuthState> _checkAuthenticationStatus() async {
    try {
      final user = SupabaseConfig.currentUser;

      if (user == null) {
        return AuthState.unauthenticated;
      }

      // Check if this is a pending admin account
      final isPendingAdmin = await AdminService.isApprovedAdmin(user.id);
      if (!isPendingAdmin) {
        // Check if there's a pending request
        final pendingRequests = await AdminService.getPendingRequests();
        final hasPendingRequest = pendingRequests.any((req) => req['user_id'] == user.id);

        if (hasPendingRequest) {
          return AuthState.pendingAdmin;
        }
      }

      return AuthState.authenticated;
    } catch (e) {
      return AuthState.unauthenticated;
    }
  }

  /// Gets the appropriate screen based on user role
  static Future<Widget> _getRoleBasedScreen() async {
    try {
      final userRole = await AuthService.getCurrentUserRole();

      switch (userRole) {
        case 'admin':
          return const AdminDashboardScreen();
        case 'user':
        default:
          // Redirect user directly to water level test screen
          return const WaterLevelTestScreen();
      }
    } catch (e) {
      // Default to water level test screen on error
      return const WaterLevelTestScreen();
    }
  }

  /// Validates if a user can access a specific route based on their role
  static Future<bool> canAccessRoute(String routeName) async {
    try {
      final userRole = await AuthService.getCurrentUserRole();

      // Define role-based access control
      const adminRoutes = ['/admin-dashboard'];
      const userRoutes = ['/home', '/user-dashboard', '/plant-details'];
      const publicRoutes = ['/login', '/register', '/onboarding'];

      if (publicRoutes.contains(routeName)) {
        return true;
      }

      if (adminRoutes.contains(routeName)) {
        return userRole == 'admin';
      }

      if (userRoutes.contains(routeName)) {
        return userRole == 'user' || userRole == 'admin';
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  /// Gets the default route for a user role
  static Future<String> getDefaultRouteForRole() async {
    try {
      final userRole = await AuthService.getCurrentUserRole();

      switch (userRole) {
        case 'admin':
          return '/admin-dashboard';
        case 'user':
        default:
          return '/water-level-test';
      }
    } catch (e) {
      return '/login';
    }
  }
}

/// Authentication states
enum AuthState {
  authenticated,
  unauthenticated,
  pendingAdmin,
}

/// Extension for AuthState
extension AuthStateExtension on AuthState {
  String get description {
    switch (this) {
      case AuthState.authenticated:
        return 'User is authenticated';
      case AuthState.unauthenticated:
        return 'User is not authenticated';
      case AuthState.pendingAdmin:
        return 'Admin account pending approval';
    }
  }
}