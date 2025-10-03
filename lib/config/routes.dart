import 'package:flutter/material.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/plants/plant_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/admin/admin_dashboard_screen.dart';
import '../features/user/user_dashboard_screen.dart';
import '../pages/water_level_test_screen.dart';
import '../main.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String plantDetails = '/plant-details';
  static const String login = '/login';
  static const String register = '/register';
  static const String adminDashboard = '/admin-dashboard';
  static const String userDashboard = '/user-dashboard';
  static const String waterLevelTest = '/water-level-test';

  static Map<String, WidgetBuilder> get routes => {
        onboarding: (context) => const OnboardingScreen(),
        home: (context) => const UserDashboardScreen(),
        plantDetails: (context) => const PlantScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
        adminDashboard: (context) => const AdminDashboardScreen(),
        userDashboard: (context) => const UserDashboardScreen(),
        waterLevelTest: (context) => const WaterLevelTestScreen(),
      };

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: routes[onboarding]!);
      case home:
        return MaterialPageRoute(builder: routes[home]!);
      case plantDetails:
        return MaterialPageRoute(builder: routes[plantDetails]!);
      case login:
        return MaterialPageRoute(builder: routes[login]!);
      case register:
        return MaterialPageRoute(builder: routes[register]!);
      case adminDashboard:
        return MaterialPageRoute(builder: routes[adminDashboard]!);
      case userDashboard:
        return MaterialPageRoute(builder: routes[userDashboard]!);
      case waterLevelTest:
        return MaterialPageRoute(builder: routes[waterLevelTest]!);
      default:
        return null;
    }
  }
}