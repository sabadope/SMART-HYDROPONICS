import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Utility class for password hashing using SHA-256
class PasswordHash {
  /// Hash a password using SHA-256
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify a password against its hash
  static bool verifyPassword(String password, String hash) {
    final hashedPassword = hashPassword(password);
    return hashedPassword == hash;
  }

  /// Generate a salted hash (for future enhancement)
  static String hashPasswordWithSalt(String password, String salt) {
    final saltedPassword = password + salt;
    return hashPassword(saltedPassword);
  }

  /// Verify a password against a salted hash
  static bool verifyPasswordWithSalt(String password, String salt, String hash) {
    final hashedPassword = hashPasswordWithSalt(password, salt);
    return hashedPassword == hash;
  }
}