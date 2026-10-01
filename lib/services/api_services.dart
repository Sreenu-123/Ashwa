import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  // ============================================================
  // BACKEND URL
  // ============================================================

  // iOS Simulator / Mac
  static const String baseUrl = 'http://127.0.0.1:8000';

  // Android Emulator
  // static const String baseUrl = 'http://10.0.2.2:8000';

  // Physical Android / iPhone
  // Use your Mac's local IP address.
  // Example:
  // static const String baseUrl = 'http://192.168.1.10:8000';

  // ============================================================
  // SECURE STORAGE
  // ============================================================

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // ============================================================
  // REGISTER USER
  // ============================================================

  static Future<Map<String, dynamic>> registerUser({
    required String fullName,
    required String horseName,
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
          'horse_name': horseName.trim(),
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
        'Registration failed '
        '(${response.statusCode})',
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

        // ======================================================
        // SAVE JWT TOKEN
        // ======================================================

        final accessToken = data['access_token'];

        if (accessToken != null) {
          await _storage.write(
            key: 'access_token',
            value: accessToken.toString(),
          );
        }

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
        'Login failed '
        '(${response.statusCode})',
      );
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  // ============================================================
  // GET STORED ACCESS TOKEN
  // ============================================================

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }

  // ============================================================
  // GET CURRENT USER
  // ============================================================

  static Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      // ========================================================
      // GET JWT TOKEN
      // ========================================================

      final token = await getAccessToken();

      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      // ========================================================
      // CALL /ME
      // ========================================================

      final response = await http.get(
        Uri.parse('$baseUrl/me'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
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
        'Failed to get current user '
        '(${response.statusCode})',
      );
    } catch (e) {
      throw Exception('Failed to get current user: $e');
    }
  }

  // ============================================================
  // UPDATE CURRENT USER
  // ============================================================

  static Future<Map<String, dynamic>> updateCurrentUser({
    required String fullName,
    required String email,
    required int age,
    required String ridingExperience,
    required String ridingLevel,
    required String discipline,
    required String primaryGoal,
    required String horseName,
  }) async {
    try {
      // ========================================================
      // GET STORED JWT TOKEN
      // ========================================================

      final token = await getAccessToken();

      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      // ========================================================
      // CALL PUT /ME
      // ========================================================

      final response = await http.put(
        Uri.parse('$baseUrl/me'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'full_name': fullName.trim(),
          'email': email.trim(),
          'age': age,
          'riding_experience': ridingExperience,
          'riding_level': ridingLevel,
          'discipline': discipline,
          'primary_goal': primaryGoal,
          'horse_name': horseName.trim(),
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
        'Profile update failed '
        '(${response.statusCode})',
      );
    } catch (e) {
      throw Exception('Profile update failed: $e');
    }
  }

  // ============================================================
  // CREATE RIDE SESSION
  // ============================================================

  static Future<Map<String, dynamic>> createRideSession({
    required String horseName,
    required String discipline,
    required int durationSeconds,
  }) async {
    try {
      // ========================================================
      // GET STORED JWT TOKEN
      // ========================================================

      final token = await getAccessToken();

      if (token == null || token.isEmpty) {
        throw Exception('No access token found');
      }

      // ========================================================
      // CALL POST /RIDES
      // ========================================================

      final response = await http.post(
        Uri.parse('$baseUrl/rides'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'horse_name': horseName.trim(),
          'discipline': discipline,
          'duration_seconds': durationSeconds,
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
        'Ride session creation failed '
        '(${response.statusCode})',
      );
    } catch (e) {
      throw Exception('Ride session creation failed: $e');
    }
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  static Future<void> logout() async {
    await _storage.delete(key: 'access_token');
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
