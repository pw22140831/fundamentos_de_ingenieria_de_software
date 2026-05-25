import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioService {
  static const String baseUrl = 'https://app.blockcode.site/api/v1/users';

  
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<dynamic>> getUsuarios() async {
    try {
      final headers = await _getHeaders();
    final resp = await http.get(Uri.parse('$baseUrl/index.php'), headers: headers)
      .timeout(const Duration(seconds: 10));
      
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        if (data is List<dynamic>) return data;
        throw Exception('Formato inesperado en usuarios');
      }
      throw Exception('HTTP ${resp.statusCode} en usuarios: ${resp.body}');
    } catch (e) {
      throw Exception('Error al cargar usuarios: $e');
    }
  }

  Future<bool> saveUsuario(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final resp = await http.post(
      Uri.parse('$baseUrl/save.php'),
      headers: headers, 
      body: json.encode(data)
    ).timeout(const Duration(seconds: 10));
    return resp.statusCode == 200;
  }

  Future<bool> updateUsuario(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final resp = await http.post(
      Uri.parse('$baseUrl/update.php'),
      headers: headers, 
      body: json.encode(data)
    ).timeout(const Duration(seconds: 10));
    return resp.statusCode == 200;
  }

  Future<bool> deleteUsuario(int id) async {
    final headers = await _getHeaders();
    final resp = await http.post(
      Uri.parse('$baseUrl/delete.php'),
      headers: headers, 
      body: json.encode({"id_usuario": id})
    ).timeout(const Duration(seconds: 10));
    return resp.statusCode == 200;
  }
}