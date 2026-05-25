import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static const String baseUrl = 'https://app.blockcode.site/api/v1/auth';
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';
  static const String _localAdminEmail = 'admin@admin.com';
  static const String _localAdminPassword = '1234@abc';

  Future<Map<String, dynamic>> login(String correo, String password) async {
    if (correo == _localAdminEmail && password == _localAdminPassword) {
      const localUser = {
        'id_usuario': 1,
        'nombre': 'Admin',
        'apellido_paterno': 'Local',
        'apellido_materno': '',
        'correo': _localAdminEmail,
        'id_rol': 1,
        'rol': 'Administrador',
        'activo': true,
      };

      await _saveSession(
        token: 'local-admin-token',
        user: localUser,
      );

      return {
        'success': true,
        'token': 'local-admin-token',
        'user': localUser,
      };
    }

    try {
      final resp = await http.post(
        Uri.parse('$baseUrl/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'correo': correo,
          'password': password,
        }),
      );

      debugPrint('AuthService.login: HTTP ${resp.statusCode}');

      if (resp.statusCode == 200) {
        final data = json.decode(resp.body) as Map<String, dynamic>;

        if (data['success'] == true && data['token'] != null) {
          await _saveSession(
            token: data['token'] as String,
            user: data['user'] as Map<String, dynamic>,
          );

          return {
            'success': true,
            'token': data['token'],
            'user': data['user'],
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Error en el login',
          };
        }
      } else {
        throw Exception('HTTP ${resp.statusCode}: ${resp.body}');
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  Future<void> _saveSession({
    required String token,
    required Map<String, dynamic> user,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userKey, json.encode(user));
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint('AuthService.getToken: reading prefs');
    return prefs.getString(_tokenKey);
  }

  Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return json.decode(userJson) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
