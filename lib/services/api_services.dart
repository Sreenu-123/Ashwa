import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiService {
  // ============================================================
  // BACKEND URL
  // ============================================================

  // iOS Simulator / Mac:
  static const String baseUrl = 'http://127.0.0.1:8000';

  // Android Emulator:
  // static const String baseUrl = 'http://10.0.2.2:8000';

  // Physical Android/iPhone:
  // Use your Mac's local IP address.
  // Example:
  // static const String baseUrl = 'http://192.168.1.10:8000';

  // ============================================================
  // REGISTER USER
  // ============================================================

  static Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String email,
    required String password,
    required int age,
    required String ridingExperience,
    required String ridingLevel,
    required String discipline,
    required String primaryGoal,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'full_name': fullName.trim(),
          'email': email.trim(),
          'password': password,
          'age': age,
          'riding_experience': ridingExperience,
          'riding_level': ridingLevel,
          'discipline': discipline,
          'primary_goal': primaryGoal,
        }),
      );

      // ========================================================
      // SUCCESS
      // ========================================================

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return Map<String, dynamic>.from(data);
      }

      // ========================================================
      // BACKEND ERROR
      // ========================================================

      final errorData = _decodeResponse(response.body);

      if (errorData != null && errorData['detail'] != null) {
        throw Exception(errorData['detail'].toString());
      }

      throw Exception(
        'Registration failed (${response.statusCode}): ${response.body}',
      );
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  // ============================================================
  // LOGIN USER
  // ============================================================

  static Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email.trim(), 'password': password}),
      );

      // ========================================================
      // SUCCESS
      // ========================================================

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return Map<String, dynamic>.from(data);
      }

      // ========================================================
      // BACKEND ERROR
      // ========================================================

      final errorData = _decodeResponse(response.body);

      if (errorData != null && errorData['detail'] != null) {
        throw Exception(errorData['detail'].toString());
      }

      throw Exception(
        'Login failed (${response.statusCode}): ${response.body}',
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // ============================================================
  // RESPONSE JSON DECODER
  // ============================================================

  static Map<String, dynamic>? _decodeResponse(String body) {
    try {
      final decoded = jsonDecode(body);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return null;
    } catch (_) {
      return null;
    }
  }
}
