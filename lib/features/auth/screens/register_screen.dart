import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/auth_service.dart';
import '../../../services/admin_service.dart';
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
  String _selectedRole = 'user'; // Default to user

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    print('🔍 DEBUG: Starting form validation...');
    if (!_formKey.currentState!.validate()) {
      print('❌ Form validation failed');
      return;
    }

    print('🚀 Starting registration process...');
    final email = _emailController.text.trim();
    final fullName = _fullNameController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final selectedRole = _selectedRole;

    print('📧 Email: $email');
    print('👤 Name: $fullName');
    print('🔒 Password length: ${password.length}');
    print('🔒 Confirm Password length: ${confirmPassword.length}');
    print('👥 Selected Role: $selectedRole');

    setState(() => _isLoading = true);

    try {
      // Check if this is an admin request - either by email domain or role selection
      final isAdminRequest = email.endsWith('@admin.com') || selectedRole == 'admin';

      // Check if this could be the first admin (no approved admins exist yet)
      final hasAnyAdmins = await AdminService.hasAnyApprovedAdmins();
      final isFirstAdmin = !hasAnyAdmins && isAdminRequest;

      // If first admin, auto-approve; otherwise follow normal approval process
      final finalRole = isFirstAdmin ? 'admin' : (isAdminRequest ? 'pending_admin' : selectedRole);

      print('🔍 DEBUG: isAdminRequest = $isAdminRequest');
      print('🔍 DEBUG: finalRole = $finalRole');
      print('🔍 DEBUG: isFirstAdmin = $isFirstAdmin');

      print('📡 Calling AuthService.signUp...');
      final response = await AuthService.signUp(
        email: email,
        password: password,
        fullName: fullName,
        confirmPassword: confirmPassword,
        role: finalRole,
        isAdminRequest: isAdminRequest && !isFirstAdmin, // Don't create request for first admin
      );

      // If this is the first admin, auto-approve them
      if (isFirstAdmin && response.user != null) {
        await AdminService.addApprovedAdmin(response.user!.id, email);
        print('👑 First admin auto-approved: ${response.user!.id}');
      }

      print('✅ Registration response received');
      print('📋 Response user: ${response.user != null ? 'EXISTS' : 'NULL'}');
      if (response.user != null) {
        print('🆔 User ID: ${response.user!.id}');
        print('📧 User Email: ${response.user!.email}');
        print('📋 User metadata: ${response.user!.userMetadata}');
      }

      if (response.user != null && mounted) {
        print('🎉 Registration successful! User ID: ${response.user!.id}');

        // Check if this is development mode
        final isDevelopmentMode = response.user!.id.startsWith('mock_user_');

        if (isDevelopmentMode) {
          print('🧪 Development mode detected');
          // Show development mode success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('🎉 Development Mode: Account created successfully!\nNote: Data stored locally for testing.'),
              backgroundColor: AppTheme.successColor,
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          print('🏭 Production mode - showing success message');
          // Show production mode success message
          final successMessage = isFirstAdmin
              ? '🎉 Welcome, First Administrator! You are now the system administrator.\nYour account has been automatically approved.'
              : '🎉 Account created successfully! Welcome to Hydro Monitor!\nYour data is stored securely in our database.';

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage),
              backgroundColor: isFirstAdmin ? Colors.purple : AppTheme.successColor,
              duration: const Duration(seconds: 6),
            ),
          );
        }

        // Navigate to login screen after successful registration
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            print('🧭 Navigating to login screen...');
            Navigator.of(context).pushReplacementNamed('/login', arguments: {'fromRegistration': true});
          }
        });
      } else {
        print('⚠️ Registration response received but no user object');
      }
    } catch (e) {
      print('💥 Registration failed with error: $e');
      print('🔍 Error type: ${e.runtimeType}');
      print('📝 Error stack trace: ${e.toString()}');

      // Try to extract more specific error information
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('network')) {
        print('🌐 Network-related error detected');
      } else if (errorString.contains('user already registered')) {
        print('👤 User already exists error');
      } else if (errorString.contains('password')) {
        print('🔒 Password-related error');
      } else if (errorString.contains('email')) {
        print('📧 Email-related error');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
            duration: const Duration(seconds: 8),
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

                  const SizedBox(height: 16),

                  // Role Selection - Dropdown (Admin requests @admin.com emails)
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: InputDecoration(
                      labelText: 'Account Type',
                      labelStyle: GoogleFonts.inter(
                        color: Colors.grey[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      hintText: 'Select account type',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.grey[400],
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      prefixIcon: Icon(
                        Icons.account_circle,
                        color: Colors.grey[600],
                        size: 24,
                      ),
                    ),
                    style: GoogleFonts.inter(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                    dropdownColor: Colors.white,
                    items: const [
                      DropdownMenuItem(
                        value: 'user',
                        child: Row(
                          children: [
                            Icon(Icons.person, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Text('User - Plant Care Access'),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'admin',
                        child: Row(
                          children: [
                            Icon(Icons.admin_panel_settings, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Admin - System Management'),
                                Text(
                                  'Requires admin approval to activate',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedRole = value!);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select an account type';
                      }
                      // Note: @admin.com emails are automatically treated as admin requests
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