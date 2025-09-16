import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/auth_service.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      print('❌ Form validation failed');
      return;
    }

    print('🚀 Starting registration process...');
    print('📧 Email: ${_emailController.text.trim()}');
    print('👤 Name: ${_fullNameController.text.trim()}');
    print('🔒 Password: [PROTECTED]');
    print('🔒 Confirm Password: [PROTECTED]');

    setState(() => _isLoading = true);

    try {
      final response = await AuthService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _fullNameController.text.trim(),
        confirmPassword: _confirmPasswordController.text, // Pass confirm password
      );

      print('✅ Registration response: ${response.user != null ? 'User created' : 'No user'}');
      print('📋 User metadata: ${response.user?.userMetadata}');

      if (response.user != null && mounted) {
        print('🎉 Registration successful! User ID: ${response.user!.id}');

        // Check if this is development mode
        final isDevelopmentMode = response.user!.id.startsWith('mock_user_');

        if (isDevelopmentMode) {
          // Show development mode success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('🎉 Development Mode: Account created successfully!\nNote: Data stored locally for testing.'),
              backgroundColor: AppTheme.successColor,
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          // Show production mode success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('🎉 Account created successfully! Welcome to Hydro Monitor!\nYour data is stored securely in our database.'),
              backgroundColor: AppTheme.successColor,
              duration: const Duration(seconds: 5),
            ),
          );
        }

        // Navigate to login screen after successful registration
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/login', arguments: {'fromRegistration': true});
          }
        });
      } else {
        print('⚠️ Registration response received but no user object');
      }
    } catch (e) {
      print('💥 Registration failed with error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.backgroundGradient,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),

                          // Logo/Icon
                          Center(
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                                border: Border.all(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.eco,
                                size: 50,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Title
                          Text(
                            'Create Account',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Join us in growing healthier plants',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),

                          const SizedBox(height: 24),

                  // Full Name Field
                  AuthTextField(
                    controller: _fullNameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    prefixIcon: Icons.person,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Email Field
                  AuthTextField(
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Icons.email,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      // Email validation that accepts ALL custom emails including Gmail
                      // Accepts: user@gmail.com, test@customdomain.com, john+tag@company.org, etc.
                      // Rejects only: test (no @), test@ (no domain), @domain.com (no username), test.domain.com (no @)
                      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Email must contain @ symbol and domain (e.g., user@domain.com)';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Password Field
                  AuthTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Create a password',
                    obscureText: _obscurePassword,
                    prefixIcon: Icons.lock,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // Confirm Password Field
                  AuthTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    hint: 'Confirm your password',
                    obscureText: _obscureConfirmPassword,
                    prefixIcon: Icons.lock_outline,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey[600],
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  // Register Button
                  SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        shadowColor: AppTheme.primaryColor.withValues(alpha: 0.3),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Create Account',
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Terms and Conditions
                  Text(
                    'By creating an account, you agree to our Terms of Service and Privacy Policy',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Divider
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: GoogleFonts.inter(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Sign In Link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: GoogleFonts.inter(
                            color: Colors.grey[600],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Sign In',
                            style: GoogleFonts.inter(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      );
    },
  ),
),
),
);
  }
}