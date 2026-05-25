import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TransaccionService {
  static const String baseUrl = 'https://app.blockcode.site/api/v1/transacciones';

  String _extractErrorMessage(http.Response resp) {
    try {
      final decoded = json.decode(resp.body);
      if (decoded is Map<String, dynamic>) {
        final backendError = decoded['error']?.toString();
        final backendMessage = decoded['message']?.toString();
        if (backendError != null && backendError.isNotEmpty) {
          return backendError;
        }
        if (backendMessage != null && backendMessage.isNotEmpty) {
          return backendMessage;
        }
      }
    } catch (_) {
      // If response is not JSON, fall through to generic message below.
    }
    return 'HTTP ${resp.statusCode}: ${resp.body}';
  }

  
  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<dynamic>> getTransaccionesPorProyecto(int idProyecto) async {
    try {
      final headers = await _getHeaders();
    final resp = await http.get(Uri.parse('$baseUrl/index.php'), headers: headers)
      .timeout(const Duration(seconds: 10));
      
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        if (data is List) {
          
          return data.where((t) => t['id_proyecto'].toString() == idProyecto.toString()).toList();
        }
        throw Exception('Formato inesperado');
      }
      throw Exception('HTTP ${resp.statusCode}');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> saveTransaccion(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final resp = await http.post(
      Uri.parse('$baseUrl/save.php'),
      headers: headers,
      body: json.encode(data),
    ).timeout(const Duration(seconds: 10));
    if (resp.statusCode != 200) {
      throw Exception(_extractErrorMessage(resp));
    }
  }

  Future<void> updateTransaccion(Map<String, dynamic> data) async {
    final headers = await _getHeaders();
    final resp = await http.post(
      Uri.parse('$baseUrl/update.php'),
      headers: headers,
      body: json.encode(data),
    ).timeout(const Duration(seconds: 10));
    if (resp.statusCode != 200) {
      throw Exception(_extractErrorMessage(resp));
    }
  }

  Future<void> deleteTransaccion(int id) async {
    final headers = await _getHeaders();
    final resp = await http.post(
      Uri.parse('$baseUrl/delete.php'),
      headers: headers,
      body: json.encode({"id_transaccion": id}),
    ).timeout(const Duration(seconds: 10));
    if (resp.statusCode != 200) {
      throw Exception(_extractErrorMessage(resp));
    }
  }
}