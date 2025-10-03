import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AdminService {
  static const String _adminRequestsKey = 'admin_requests';
  static const String _adminUsersKey = 'admin_users';

  // Store admin approval request locally
  static Future<void> createAdminRequest({
    required String userId,
    required String email,
    required String fullName,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final requests = await _getAdminRequests();

    requests.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'user_id': userId,
      'email': email,
      'full_name': fullName,
      'status': 'pending',
      'requested_at': DateTime.now().toIso8601String(),
    });

    await prefs.setString(_adminRequestsKey, jsonEncode(requests));
    print('✅ Admin request stored locally for: $email');
  }

  // Get all pending admin requests
  static Future<List<Map<String, dynamic>>> getPendingRequests() async {
    final requests = await _getAdminRequests();
    return requests.where((req) => req['status'] == 'pending').toList();
  }

  // Approve admin request
  static Future<void> approveAdminRequest(String requestId, String approvedBy) async {
    final requests = await _getAdminRequests();
    final index = requests.indexWhere((req) => req['id'] == requestId);

    if (index != -1) {
      requests[index]['status'] = 'approved';
      requests[index]['approved_at'] = DateTime.now().toIso8601String();
      requests[index]['approved_by'] = approvedBy;

      // Add to approved admins list
      await addApprovedAdmin(requests[index]['user_id'], requests[index]['email']);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_adminRequestsKey, jsonEncode(requests));
      print('✅ Admin request approved for: ${requests[index]['email']}');
    }
  }

  // Reject admin request
  static Future<void> rejectAdminRequest(String requestId, String rejectedBy) async {
    final requests = await _getAdminRequests();
    final index = requests.indexWhere((req) => req['id'] == requestId);

    if (index != -1) {
      requests[index]['status'] = 'rejected';
      requests[index]['rejected_at'] = DateTime.now().toIso8601String();
      requests[index]['rejected_by'] = rejectedBy;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_adminRequestsKey, jsonEncode(requests));
      print('❌ Admin request rejected for: ${requests[index]['email']}');
    }
  }

  // Check if user is approved admin
  static Future<bool> isApprovedAdmin(String userId) async {
    final admins = await _getApprovedAdmins();
    return admins.any((admin) => admin['user_id'] == userId);
  }

  // Check if any approved admins exist in the system
  static Future<bool> hasAnyApprovedAdmins() async {
    final admins = await _getApprovedAdmins();
    return admins.isNotEmpty;
  }

  // Internal helper methods
  static Future<List<Map<String, dynamic>>> _getAdminRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final requestsJson = prefs.getString(_adminRequestsKey);
    if (requestsJson != null) {
      final List<dynamic> decoded = jsonDecode(requestsJson);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  static Future<List<Map<String, dynamic>>> _getApprovedAdmins() async {
    final prefs = await SharedPreferences.getInstance();
    final adminsJson = prefs.getString(_adminUsersKey);
    if (adminsJson != null) {
      final List<dynamic> decoded = jsonDecode(adminsJson);
      return decoded.map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  static Future<void> addApprovedAdmin(String userId, String email) async {
    final admins = await _getApprovedAdmins();
    admins.add({
      'user_id': userId,
      'email': email,
      'approved_at': DateTime.now().toIso8601String(),
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_adminUsersKey, jsonEncode(admins));
  }

  // Clear all data (for testing)
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_adminRequestsKey);
    await prefs.remove(_adminUsersKey);
    print('🧹 All admin data cleared');
  }
}