import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../services/admin_service.dart';
import '../../config/routes.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  void _showAdminRequestsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AdminRequestsDialog();
      },
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    try {
      await AuthService.signOut();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.login);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logout failed: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                color: Colors.red,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'ADMIN DASHBOARD',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 18,
                color: Colors.red[800],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red.withValues(alpha: 0.1),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.verified_user, color: Colors.red[700], size: 16),
                const SizedBox(width: 4),
                Text(
                  'ADMIN',
                  style: GoogleFonts.inter(
                    color: Colors.red[800],
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => _handleLogout(context),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF5F5), // Light red background
              Color(0xFFFFE8E8),
              Color(0xFFFFD1D1),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Admin Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.security, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'ADMINISTRATOR ACCESS',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.red[800],
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'System Administration',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.red[900],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage users, system settings, and monitor application performance',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.red[700],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _AdminCard(
                        title: 'User Management',
                        subtitle: 'Manage user accounts & roles',
                        icon: Icons.people,
                        color: const Color(0xFFDC2626), // Red
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User Management - Admin Feature'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        },
                      ),
                      _AdminCard(
                        title: 'System Settings',
                        subtitle: 'Configure app parameters',
                        icon: Icons.settings,
                        color: const Color(0xFFEA580C), // Orange
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('System Settings - Admin Feature'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        },
                      ),
                      _AdminCard(
                        title: 'Analytics Dashboard',
                        subtitle: 'View system analytics',
                        icon: Icons.analytics,
                        color: const Color(0xFFD97706), // Amber
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Analytics - Admin Feature'),
                              backgroundColor: Colors.amber,
                            ),
                          );
                        },
                      ),
                      _AdminCard(
                        title: 'Admin Requests',
                        subtitle: 'Review admin approval requests',
                        icon: Icons.pending_actions,
                        color: const Color(0xFF7C2D12), // Brown/Orange
                        onTap: () {
                          _showAdminRequestsDialog(context);
                        },
                      ),
                      _AdminCard(
                        title: 'Reports & Logs',
                        subtitle: 'Generate system reports',
                        icon: Icons.description,
                        color: const Color(0xFFB91C1C), // Dark red
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Reports - Admin Feature'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                        },
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
  }
}

class _AdminCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AdminCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color, color.withValues(alpha: 0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.9),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AdminRequestsDialog extends StatefulWidget {
  const AdminRequestsDialog({super.key});

  @override
  State<AdminRequestsDialog> createState() => _AdminRequestsDialogState();
}

class _AdminRequestsDialogState extends State<AdminRequestsDialog> {
  List<Map<String, dynamic>> _pendingRequests = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingRequests();
  }

  Future<void> _loadPendingRequests() async {
    try {
      print('📝 Loading pending admin requests...');
      final requests = await AdminService.getPendingRequests();

      print('✅ Loaded ${requests.length} pending requests');
      setState(() {
        _pendingRequests = requests;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading admin requests: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleRequestAction(String requestId, String userId, String action) async {
    // Show password confirmation dialog
    final confirmed = await _showPasswordConfirmationDialog(action);
    if (!confirmed) return;

    try {
      final currentUser = Supabase.instance.client.auth.currentUser;
      final adminEmail = currentUser?.email ?? 'unknown';

      if (action == 'approve') {
        // Approve the admin request
        await AdminService.approveAdminRequest(requestId, adminEmail);

        // Note: In a real implementation, you'd update the user's role in the database
        // For now, we'll just mark them as approved in local storage
        print('✅ Admin request approved for user: $userId');
      } else {
        // Reject the admin request
        await AdminService.rejectAdminRequest(requestId, adminEmail);
        print('❌ Admin request rejected for user: $userId');
      }

      // Reload requests
      await _loadPendingRequests();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Request ${action}d successfully'),
          backgroundColor: action == 'approve' ? Colors.green : Colors.red,
        ),
      );
    } catch (e) {
      print('❌ Error processing request: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error processing request'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<bool> _showPasswordConfirmationDialog(String action) async {
    final passwordController = TextEditingController();
    bool confirmed = false;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm ${action.capitalize()}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Enter your admin password to ${action} this request:'),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Admin Password',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Verify admin password
                try {
                  final currentUser = Supabase.instance.client.auth.currentUser;
                  if (currentUser != null) {
                    await Supabase.instance.client.auth.signInWithPassword(
                      email: currentUser.email!,
                      password: passwordController.text,
                    );
                    confirmed = true;
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid password'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: action == 'approve' ? Colors.green : Colors.red,
              ),
              child: Text(action.capitalize()),
            ),
          ],
        );
      },
    );

    return confirmed;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.6,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.pending_actions, color: Colors.orange, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Admin Approval Requests',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.orange[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _pendingRequests.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.check_circle, color: Colors.green, size: 48),
                              const SizedBox(height: 16),
                              Text(
                                'No pending requests',
                                style: GoogleFonts.inter(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: _pendingRequests.length,
                          itemBuilder: (context, index) {
                            final request = _pendingRequests[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.person, color: Colors.blue),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                request['full_name'] ?? 'Unknown',
                                                style: GoogleFonts.inter(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                              Text(
                                                request['email'] ?? '',
                                                style: GoogleFonts.inter(
                                                  color: Colors.grey[600],
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () => _handleRequestAction(
                                            request['id'],
                                            request['user_id'],
                                            'reject',
                                          ),
                                          icon: const Icon(Icons.close, color: Colors.red),
                                          label: const Text('Reject'),
                                          style: TextButton.styleFrom(foregroundColor: Colors.red),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton.icon(
                                          onPressed: () => _handleRequestAction(
                                            request['id'],
                                            request['user_id'],
                                            'approve',
                                          ),
                                          icon: const Icon(Icons.check, color: Colors.white),
                                          label: const Text('Approve'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}