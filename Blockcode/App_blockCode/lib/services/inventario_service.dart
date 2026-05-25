import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class InventarioService {
  static const String baseUrl = 'https://app.blockcode.site/api/v1/inventario';

  
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<dynamic>> getInventarios() async {
    try {
      final headers = await _getHeaders();
    final resp = await http.get(Uri.parse('$baseUrl/index.php'), headers: headers)
      .timeout(const Duration(seconds: 10));
      
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        if (data is List<dynamic>) return data;
        throw Exception('Formato inesperado en inventario');
      }
      throw Exception('HTTP ${resp.statusCode} en inventario: ${resp.body}');
    } catch (e) {
      throw Exception('Error al cargar inventario: $e');
    }
  }

  Future<bool> saveInventario(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final resp = await http.post(
      Uri.parse('$baseUrl/save.php'),
      headers: headers,
      body: json.encode(data),
    ).timeout(const Duration(seconds: 10));
    return resp.statusCode == 200;
  }

  Future<bool> updateInventario(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final resp = await http.post(
      Uri.parse('$baseUrl/update.php'),
      headers: headers,
      body: json.encode(data),
    ).timeout(const Duration(seconds: 10));
    return resp.statusCode == 200;
  }

  Future<bool> deleteInventario(int id) async {
    final headers = await _getHeaders();
    final resp = await http.post(
      Uri.parse('$baseUrl/delete.php'),
      headers: headers,
      body: json.encode({"id_inventario": id}), 
    ).timeout(const Duration(seconds: 10));
    return resp.statusCode == 200;
  }
}