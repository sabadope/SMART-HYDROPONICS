class AppConstants {
  // App Information
  static const String appName = 'Hydro Monitor';
  static const String appVersion = '1.0.0';

  // Supabase Configuration
  // TODO: Replace with your actual Supabase project URL and anon key
  static const String supabaseUrl = 'https://ihscuhuksaixfjmmttqa.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imloc2N1aHVrc2FpeGZqbW10dHFhIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc1MTU0NTAsImV4cCI6MjA3MzA5MTQ1MH0.6eKAuH33Rn4c4RsIy-5XXYrArhdy4f0suJ6S82Q7cW8';

  // Shared Preferences Keys
  static const String hasSeenOnboardingKey = 'hasSeenOnboarding';
  static const String userTokenKey = 'userToken';
  static const String userDataKey = 'userData';
  static const String isLoggedInKey = 'isLoggedIn';

  // Plant Growth Stages
  static const int maxPlantLevel = 4;
  static const double achievementThreshold = 0.95;

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 4.0;

  // Asset Paths
  static const String imagesPath = 'assets/images/';
  static const String plantImagesPath = '${imagesPath}lvl_';
  static const String lettuceImagePath = '${imagesPath}lettuce_';
}