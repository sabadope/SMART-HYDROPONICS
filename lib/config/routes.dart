import 'package:flutter/material.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/plants/plant_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../main.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String plantDetails = '/plant-details';
  static const String login = '/login';
  static const String register = '/register';

  static Map<String, WidgetBuilder> get routes => {
        onboarding: (context) => const OnboardingScreen(),
        home: (context) => const RootScaffold(),
        plantDetails: (context) => const PlantScreen(),
        login: (context) => const LoginScreen(),
        register: (context) => const RegisterScreen(),
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
      default:
        return null;
    }
  }
}