import 'package:flutter/material.dart';
import 'package:blockcode/services/proveedor_service.dart';
import 'package:blockcode/services/auth_service.dart';
import 'package:blockcode/services/usuario_proyecto_service.dart';

class ProveedoresScreen extends StatefulWidget {
  const ProveedoresScreen({super.key});

  @override
  State<ProveedoresScreen> createState() => _ProveedoresScreenState();
}

class _ProveedoresScreenState extends State<ProveedoresScreen> {
  final ProveedorService _service = ProveedorService();
  final AuthService _authService = AuthService();
  final UsuarioProyectoService _assignmentService = UsuarioProyectoService();
  Map<String, dynamic>? _currentUser;
  Set<String> _userProjectIds = {};

  bool _isAdmin(Map<String, dynamic>? user) {
    final rol = user?['rol']?.toString().toLowerCase() ?? '';
    final idRol = int.tryParse(user?['id_rol']?.toString() ?? '');
    return rol.contains('admin') || idRol == 1;
  }

  Future<List<dynamic>> _loadProveedoresForUser() async {
    final proveedores = await _service.getProveedores();
    final user = await _authService.getUser();
    _currentUser = user;
    if (_isAdmin(user)) return proveedores;

    // operators see only providers for their projects
    final assignments = await _assignmentService.getAssignments();
    final userId = user?['id_usuario']?.toString();
    if (userId == null) return [];
    final projectIds = assignments
        .where((a) => a['id_usuario']?.toString() == userId)
        .map((a) => a['id_proyecto']?.toString())
        .whereType<String>()
        .toSet();
    _userProjectIds = projectIds;

    return proveedores.where((p) => projectIds.contains(p['id_proyecto']?.toString())).toList();
  }

  void _showForm({Map<String, dynamic>? proveedor}) {
    final nombreCtrl = TextEditingController(text: proveedor?['nombre']);
    final contactoCtrl = TextEditingController(text: proveedor?['contacto']);
    final telefonoCtrl = TextEditingController(text: proveedor?['telefono']?.toString());
    final proyectoCtrl = TextEditingController(text: proveedor?['id_proyecto']?.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(proveedor == null ? 'Nuevo Proveedor' : 'Editar Proveedor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: contactoCtrl, decoration: const InputDecoration(labelText: 'Contacto')),
            TextField(controller: telefonoCtrl, decoration: const InputDecoration(labelText: 'Telefono')),
            TextField(controller: proyectoCtrl, decoration: const InputDecoration(labelText: 'ID Proyecto')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final data = {
                'nombre': nombreCtrl.text,
                'contacto': contactoCtrl.text,
                'telefono': telefonoCtrl.text,
                'id_proyecto': proyectoCtrl.text,
              };
              bool ok;
              if (proveedor == null) {
                ok = await _service.saveProveedor(data);
              } else {
                data['id_proveedor'] = proveedor['id_proveedor'];
                ok = await _service.updateProveedor(data);
              }
              if (ok) {
                setState(() {});
                Navigator.pop(context);
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al guardar proveedor')));
              }
            },
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      body: FutureBuilder<List<dynamic>>(
        future: _loadProveedoresForUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
          if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
          final data = snapshot.data ?? [];
          if (data.isEmpty) return const Center(child: Text('No hay proveedores.'));
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final p = data[i];
              final canModify = _isAdmin(_currentUser) || _userProjectIds.contains(p['id_proyecto']?.toString());

              return ListTile(
                title: Text(p['nombre'] ?? 'Proveedor'),
                subtitle: Text('Contacto: ${p['contacto'] ?? ''}\nTel: ${p['telefono'] ?? ''}'),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (canModify) ...[
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showForm(proveedor: p),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final ok = await _service.deleteProveedor(int.parse(p['id_proveedor'].toString()));
                          if (ok) setState(() {});
                        },
                      ),
                    ] else ...[
                      const SizedBox.shrink(),
                    ],
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FutureBuilder<Map<String, dynamic>?>(
        future: _authService.getUser(),
        builder: (context, snap) {
          if (!snap.hasData) return const SizedBox.shrink();
          final user = snap.data;
          final allowed = _isAdmin(user) || _userProjectIds.isNotEmpty; // operator with projects can add for their projects
          if (!allowed) return const SizedBox.shrink();
          return FloatingActionButton(
            onPressed: () => _showForm(),
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
