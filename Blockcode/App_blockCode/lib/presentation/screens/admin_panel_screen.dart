import 'package:flutter/material.dart';
import 'package:blockcode/services/auth_service.dart';
import 'package:blockcode/services/usuario_proyecto_service.dart';
import 'package:blockcode/services/usuario_service.dart';
import 'package:blockcode/services/proyecto_service.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final AuthService _authService = AuthService();
  final UsuarioService _usuarioService = UsuarioService();
  final ProyectoService _proyectoService = ProyectoService();
  final UsuarioProyectoService _assignmentService = UsuarioProyectoService();

  bool _isCheckingRole = true;
  bool _canAccess = false;
  bool _isLoading = true;

  List<dynamic> _users = [];
  List<dynamic> _projects = [];
  List<dynamic> _assignments = [];

  int? _selectedUserId;
  int? _selectedProjectId;
  int? _editingAssignmentId;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    await _checkAdminAccess();
    if (_canAccess) {
      await _loadData();
    }
  }

  bool _isAdmin(Map<String, dynamic>? user) {
    final rol = user?['rol']?.toString().toLowerCase() ?? '';
    final idRol = int.tryParse(user?['id_rol']?.toString() ?? '');
    return rol.contains('admin') || idRol == 1;
  }

  Future<void> _checkAdminAccess() async {
    final user = await _authService.getUser();
    if (!mounted) return;
    setState(() {
      _canAccess = _isAdmin(user);
      _isCheckingRole = false;
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await _usuarioService.getUsuarios();
      final projects = await _proyectoService.getProyectos();
      final assignments = await _assignmentService.getAssignments();

      setState(() {
        _users = users;
        _projects = projects;
        _assignments = assignments;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo cargar el panel: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startEditing(Map<String, dynamic> assignment) {
    setState(() {
      _editingAssignmentId = int.tryParse(assignment['id_usuario_proyecto'].toString());
      _selectedUserId = int.tryParse(assignment['id_usuario'].toString());
      _selectedProjectId = int.tryParse(assignment['id_proyecto'].toString());
    });
  }

  Future<void> _saveAssignment() async {
    if (_selectedUserId == null || _selectedProjectId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un usuario y un proyecto.')),
      );
      return;
    }

    final user = _users.firstWhere((u) => u['id_usuario'].toString() == _selectedUserId.toString());
    final project = _projects.firstWhere((p) => p['id_proyecto'].toString() == _selectedProjectId.toString());

    final assignmentData = {
      'id_usuario': _selectedUserId,
      'id_proyecto': _selectedProjectId,
      'usuario': '${user['nombre']} ${user['apellido_paterno'] ?? ''} ${user['apellido_materno'] ?? ''}'.trim(),
      'proyecto': project['nombre'],
      'fecha_asignacion': DateTime.now().toIso8601String(),
    };

    bool success;
    if (_editingAssignmentId != null) {
      assignmentData['id_usuario_proyecto'] = _editingAssignmentId;
      success = await _assignmentService.updateAssignment(assignmentData);
    } else {
      success = await _assignmentService.saveAssignment(assignmentData);
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_editingAssignmentId != null ? 'Asignación actualizada' : 'Asignación creada')),
      );
      _resetForm();
      await _loadData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar la asignación.')),
      );
    }
  }

  void _resetForm() {
    setState(() {
      _selectedUserId = null;
      _selectedProjectId = null;
      _editingAssignmentId = null;
    });
  }

  Future<void> _deleteAssignment(int id) async {
    final success = await _assignmentService.deleteAssignment(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Asignación eliminada')));
      await _loadData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No se pudo eliminar la asignación.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingRole) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (!_canAccess) {
      return Scaffold(
        appBar: AppBar(title: const Text('Panel administrador')),
        body: const Center(child: Text('Acceso denegado: solo administradores.')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Panel administrador')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text('Asignar usuario a proyecto', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            value: _selectedUserId,
                            decoration: const InputDecoration(labelText: 'Usuario'),
                            items: _users
                                .map((u) => DropdownMenuItem<int>(
                                      value: int.tryParse(u['id_usuario'].toString()),
                                      child: Text('${u['nombre']} ${u['apellido_paterno'] ?? ''} ${u['apellido_materno'] ?? ''}'.trim()),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() => _selectedUserId = value),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<int>(
                            value: _selectedProjectId,
                            decoration: const InputDecoration(labelText: 'Proyecto'),
                            items: _projects
                                .map((p) => DropdownMenuItem<int>(
                                      value: int.tryParse(p['id_proyecto'].toString()),
                                      child: Text(p['nombre'].toString()),
                                    ))
                                .toList(),
                            onChanged: (value) => setState(() => _selectedProjectId = value),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _saveAssignment,
                                  child: Text(_editingAssignmentId != null ? 'Actualizar asignación' : 'Crear asignación'),
                                ),
                              ),
                              if (_editingAssignmentId != null) ...[
                                const SizedBox(width: 12),
                                TextButton(onPressed: _resetForm, child: const Text('Cancelar')),
                              ]
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Asignaciones', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.refresh),
                                  onPressed: _loadData,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: _assignments.isEmpty
                                  ? const Center(child: Text('No hay asignaciones.'))
                                  : ListView.separated(
                                      itemCount: _assignments.length,
                                      separatorBuilder: (_, __) => const Divider(height: 1),
                                      itemBuilder: (context, index) {
                                        final assignment = _assignments[index];
                                        return ListTile(
                                          title: Text(assignment['usuario']?.toString() ?? 'Usuario desconocido'),
                                          subtitle: Text('Proyecto: ${assignment['proyecto'] ?? 'Desconocido'}'),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit, color: Colors.blue),
                                                onPressed: () => _startEditing(assignment),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete, color: Colors.red),
                                                onPressed: () => _deleteAssignment(int.tryParse(assignment['id_usuario_proyecto'].toString()) ?? 0),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
