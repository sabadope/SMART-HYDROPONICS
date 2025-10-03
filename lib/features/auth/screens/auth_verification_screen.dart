import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../../services/auth_service.dart';
import '../../../services/admin_service.dart';
import '../../../config/routes.dart';

class AuthVerificationScreen extends StatefulWidget {
  const AuthVerificationScreen({
    super.key,
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  State<AuthVerificationScreen> createState() => _AuthVerificationScreenState();
}

class _AuthVerificationScreenState extends State<AuthVerificationScreen>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  VerificationStep _currentStep = VerificationStep.initializing;
  String _userRole = '';
  String _userName = '';
  bool _isVerificationComplete = false;

  final List<VerificationStep> _verificationSteps = [
    VerificationStep.initializing,
    VerificationStep.connecting,
    VerificationStep.verifyingCredentials,
    VerificationStep.checkingProfile,
    VerificationStep.confirmingIdentity,
    VerificationStep.finalizing,
  ];

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startVerificationProcess();
  }

  void _setupAnimations() {
    _mainController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Curves.elasticOut,
    ));

    _mainController.forward();
  }

  Future<void> _startVerificationProcess() async {
    try {
      // Step 1: Initializing
      setState(() => _currentStep = VerificationStep.initializing);
      await Future.delayed(const Duration(seconds: 1));

      // Step 2: Connecting to server
      setState(() => _currentStep = VerificationStep.connecting);
      await Future.delayed(const Duration(seconds: 1));

      // Step 3: Verifying credentials
      setState(() => _currentStep = VerificationStep.verifyingCredentials);
      final response = await AuthService.signIn(
        email: widget.email,
        password: widget.password,
      );

      if (response.user == null) {
        throw Exception('Authentication failed');
      }

      // Step 4: Checking user profile
      setState(() => _currentStep = VerificationStep.checkingProfile);
      await Future.delayed(const Duration(seconds: 1));

      // Get user role from profile
      final userRole = await AuthService.getCurrentUserRole();
      final userName = response.user!.userMetadata?['full_name'] ?? 'User';

      setState(() {
        _userRole = userRole ?? 'user';
        _userName = userName;
      });

      // Step 5: Confirming identity
      setState(() => _currentStep = VerificationStep.confirmingIdentity);
      await Future.delayed(const Duration(seconds: 1));

      // Check for pending admin status
      if (_userRole == 'pending_admin') {
        final isPendingAdmin = await AdminService.isApprovedAdmin(response.user!.id);
        if (!isPendingAdmin) {
          final pendingRequests = await AdminService.getPendingRequests();
          final hasPendingRequest = pendingRequests.any((req) => req['user_id'] == response.user!.id);

          if (hasPendingRequest) {
            _showPendingApprovalDialog();
            return;
          }
        }
      }

      // Step 6: Finalizing
      setState(() => _currentStep = VerificationStep.finalizing);
      await Future.delayed(const Duration(seconds: 1));

      // Mark verification as complete
      setState(() => _isVerificationComplete = true);

      // Navigate to appropriate dashboard after a brief delay
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        _navigateToDashboard();
      }

    } catch (e) {
      if (mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showPendingApprovalDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Admin Approval Pending',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.orange[800],
          ),
        ),
        content: Text(
          'Your admin account request is pending approval from an administrator. You will be notified once your request is reviewed.',
          style: GoogleFonts.inter(
            color: Colors.grey[700],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to login
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Back to Login',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Authentication Failed',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colors.red[800],
          ),
        ),
        content: Text(
          _getErrorMessage(error),
          style: GoogleFonts.inter(
            color: Colors.grey[700],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to login
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Back to Login',
              style: GoogleFonts.inter(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  String _getErrorMessage(String error) {
    final errorString = error.toLowerCase();
    if (errorString.contains('invalid login credentials')) {
      return 'Invalid email or password. Please check your credentials.';
    } else if (errorString.contains('email not confirmed')) {
      return 'Please check your email and confirm your account.';
    } else if (errorString.contains('network') || errorString.contains('connection')) {
      return 'Network error. Please check your connection and try again.';
    }
    return 'Authentication failed. Please try again.';
  }

  void _navigateToDashboard() {
    final routeName = _userRole == 'admin' ? AppRoutes.adminDashboard : AppRoutes.home;
    Navigator.of(context).pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
    );
  }

  @override
  void dispose() {
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF1e3a8a), // Dark blue
              const Color(0xFF3b82f6), // Blue
              const Color(0xFF60a5fa), // Light blue
            ],
          ),
        ),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _mainController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: _isVerificationComplete
                        ? _buildCompleteLayout()
                        : _buildVerificationLayout(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 48, // Account for padding
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                _buildHeader(),

                const SizedBox(height: 48),

                // Security Gate Icon
                _buildSecurityGateIcon(),

                const SizedBox(height: 32),

                // Verification Steps
                _buildVerificationSteps(),

                const SizedBox(height: 32),

                // Current Step Display
                _buildCurrentStepDisplay(),

                // Add bottom padding to ensure content doesn't get cut off
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompleteLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 48, // Account for padding
            ),
            child: Column(
              children: [
                // Header
                _buildHeader(),

                const SizedBox(height: 48),

                // Security Gate Icon
                _buildSecurityGateIcon(),

                const SizedBox(height: 32),

                // Verification Steps
                _buildVerificationSteps(),

                const SizedBox(height: 32),

                // Current Step Display
                _buildCurrentStepDisplay(),

                const SizedBox(height: 32),

                // User Info (when verification complete)
                _buildUserConfirmation(),

                // Add bottom padding to ensure content doesn't get cut off
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: const Icon(
            Icons.security,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Security Gate',
                style: GoogleFonts.inter(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                'Verifying your access...',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityGateIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.9),
            Colors.white.withValues(alpha: 0.7),
          ],
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.5),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.3),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _mainController.value * 2 * 3.14159,
            child: const Icon(
              Icons.eco,
              color: Color(0xFF16A34A),
              size: 60,
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerificationSteps() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: _verificationSteps.map((step) {
          final isCompleted = _verificationSteps.indexOf(step) < _verificationSteps.indexOf(_currentStep);
          final isCurrent = step == _currentStep;
          final isPending = _verificationSteps.indexOf(step) > _verificationSteps.indexOf(_currentStep);

          return _buildStepItem(step, isCompleted, isCurrent, isPending);
        }).toList(),
      ),
    );
  }

  Widget _buildStepItem(VerificationStep step, bool isCompleted, bool isCurrent, bool isPending) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCurrent ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isCurrent ? Border.all(
          color: Colors.white.withValues(alpha: 0.4),
          width: 1,
        ) : null,
      ),
      child: Row(
        children: [
          // Status Icon
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? Colors.green
                  : isCurrent
                      ? Colors.blue
                      : Colors.grey.withValues(alpha: 0.3),
            ),
            child: Icon(
              isCompleted
                  ? Icons.check
                  : isCurrent
                      ? Icons.hourglass_empty
                      : Icons.radio_button_unchecked,
              color: Colors.white,
              size: 16,
            ),
          ),

          const SizedBox(width: 12),

          // Step Text
          Expanded(
            child: Text(
              _getStepText(step),
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                color: isCompleted
                    ? Colors.white
                    : isCurrent
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.6),
              ),
            ),
          ),

          // Progress Indicator
          if (isCurrent)
            const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepDisplay() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            _getCurrentStepTitle(),
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getCurrentStepDescription(),
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildUserConfirmation() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Success Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.green,
                  Colors.green.withValues(alpha: 0.8),
                ],
              ),
            ),
            child: const Icon(
              Icons.verified_user,
              color: Colors.white,
              size: 32,
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Access Confirmed',
            style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.green[800],
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Welcome, $_userName',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _userRole == 'admin' ? Colors.red.withValues(alpha: 0.1) : Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _userRole == 'admin' ? Colors.red.withValues(alpha: 0.3) : Colors.green.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _userRole == 'admin' ? Icons.admin_panel_settings : Icons.person,
                  color: _userRole == 'admin' ? Colors.red : Colors.green,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  _userRole == 'admin' ? 'Administrator' : 'User',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: _userRole == 'admin' ? Colors.red[800] : Colors.green[800],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text(
            'Redirecting to your dashboard...',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getStepText(VerificationStep step) {
    switch (step) {
      case VerificationStep.initializing:
        return 'Initializing security protocols';
      case VerificationStep.connecting:
        return 'Connecting to secure server';
      case VerificationStep.verifyingCredentials:
        return 'Verifying login credentials';
      case VerificationStep.checkingProfile:
        return 'Checking user profile';
      case VerificationStep.confirmingIdentity:
        return 'Confirming user identity';
      case VerificationStep.finalizing:
        return 'Finalizing authentication';
    }
  }

  String _getCurrentStepTitle() {
    switch (_currentStep) {
      case VerificationStep.initializing:
        return 'Initializing...';
      case VerificationStep.connecting:
        return 'Connecting...';
      case VerificationStep.verifyingCredentials:
        return 'Verifying Credentials';
      case VerificationStep.checkingProfile:
        return 'Checking Profile';
      case VerificationStep.confirmingIdentity:
        return 'Confirming Identity';
      case VerificationStep.finalizing:
        return 'Finalizing...';
    }
  }

  String _getCurrentStepDescription() {
    switch (_currentStep) {
      case VerificationStep.initializing:
        return 'Setting up secure connection protocols';
      case VerificationStep.connecting:
        return 'Establishing secure connection to server';
      case VerificationStep.verifyingCredentials:
        return 'Validating your email and password';
      case VerificationStep.checkingProfile:
        return 'Retrieving your user profile information';
      case VerificationStep.confirmingIdentity:
        return 'Confirming your identity and access level';
      case VerificationStep.finalizing:
        return 'Completing authentication process';
    }
  }
}

enum VerificationStep {
  initializing,
  connecting,
  verifyingCredentials,
  checkingProfile,
  confirmingIdentity,
  finalizing,
}