import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UsuarioProyectoService {
  static const String baseUrl = 'https://app.blockcode.site/api/v1/usuarios_proyectos';
  static const String _localStorageKey = 'local_usuario_proyectos';

  Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<List<dynamic>> getAssignments() async {
    try {
      final headers = await _getHeaders();
    final resp = await http.get(Uri.parse('$baseUrl/index.php'), headers: headers)
      .timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final data = json.decode(resp.body);
        if (data is List<dynamic>) return data;
      }
    } catch (_) {}
    return _loadLocalAssignments();
  }

  Future<bool> saveAssignment(Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final resp = await http.post(
        Uri.parse('$baseUrl/save.php'),
        headers: headers,
        body: json.encode(data),
      ).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) return true;
    } catch (_) {}
    return _saveLocalAssignment(data);
  }

  Future<bool> updateAssignment(Map<String, dynamic> data) async {
    try {
      final headers = await _getHeaders();
      final resp = await http.post(
        Uri.parse('$baseUrl/update.php'),
        headers: headers,
        body: json.encode(data),
      ).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) return true;
    } catch (_) {}
    return _updateLocalAssignment(data);
  }

  Future<bool> deleteAssignment(int id) async {
    try {
      final headers = await _getHeaders();
      final resp = await http.post(
        Uri.parse('$baseUrl/delete.php'),
        headers: headers,
        body: json.encode({'id_usuario_proyecto': id}),
      ).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) return true;
    } catch (_) {}
    return _deleteLocalAssignment(id);
  }

  Future<List<dynamic>> _loadLocalAssignments() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_localStorageKey);
    if (jsonString == null) return [];

    final data = json.decode(jsonString);
    if (data is List<dynamic>) return data;
    return [];
  }

  Future<bool> _saveLocalAssignment(Map<String, dynamic> data) async {
    final assignments = await _loadLocalAssignments();
    final newId = data['id_usuario_proyecto'] ?? DateTime.now().millisecondsSinceEpoch;
    final assignment = {
      'id_usuario_proyecto': newId,
      'id_usuario': data['id_usuario'],
      'id_proyecto': data['id_proyecto'],
      'usuario': data['usuario'] ?? data['nombre_usuario'] ?? '',
      'proyecto': data['proyecto'] ?? data['nombre_proyecto'] ?? '',
      'fecha_asignacion': data['fecha_asignacion'] ?? DateTime.now().toIso8601String(),
    };
    assignments.add(assignment);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localStorageKey, json.encode(assignments));
    return true;
  }

  Future<bool> _updateLocalAssignment(Map<String, dynamic> data) async {
    final assignments = await _loadLocalAssignments();
    final index = assignments.indexWhere((item) => item['id_usuario_proyecto'] == data['id_usuario_proyecto']);
    if (index < 0) return false;
    final updated = {
      ...assignments[index],
      'id_usuario': data['id_usuario'],
      'id_proyecto': data['id_proyecto'],
      'usuario': data['usuario'] ?? assignments[index]['usuario'] ?? '',
      'proyecto': data['proyecto'] ?? assignments[index]['proyecto'] ?? '',
    };
    assignments[index] = updated;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localStorageKey, json.encode(assignments));
    return true;
  }

  Future<bool> _deleteLocalAssignment(int id) async {
    final assignments = await _loadLocalAssignments();
    final remaining = assignments.where((item) => item['id_usuario_proyecto'] != id).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localStorageKey, json.encode(remaining));
    return true;
  }
}
