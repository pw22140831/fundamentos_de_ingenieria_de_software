import 'package:flutter/material.dart';
import 'package:blockcode/services/usuario_service.dart';
import 'package:blockcode/services/auth_service.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});
  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final UsuarioService _service = UsuarioService();
  final AuthService _authService = AuthService();
  bool _isCheckingRole = true;
  bool _canAccess = false;

  @override
  void initState() {
    super.initState();
    _checkAdminAccess();
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

  void _abrirFormulario({Map<String, dynamic>? usuario}) {
    final isEdit = usuario != null;
    final nomCtrl = TextEditingController(text: usuario?['nombre']);
    final patCtrl = TextEditingController(text: usuario?['apellido_paterno']);
    final matCtrl = TextEditingController(text: usuario?['apellido_materno']);
    final emailCtrl = TextEditingController(text: usuario?['correo']);
    
    final passCtrl = TextEditingController(); 

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Editar Usuario' : 'Nuevo Usuario'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nomCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
              TextField(controller: patCtrl, decoration: const InputDecoration(labelText: 'Ap. Paterno')),
              TextField(controller: matCtrl, decoration: const InputDecoration(labelText: 'Ap. Materno')),
              TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Correo')),
              TextField(controller: passCtrl, decoration: const InputDecoration(labelText: 'Password (dejar vacío para no cambiar)'), obscureText: true),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final data = {
                "nombre": nomCtrl.text,
                "apellido_paterno": patCtrl.text,
                "apellido_materno": matCtrl.text,
                "correo": emailCtrl.text,
                "id_rol": usuario?['id_rol'] ?? 2,
              };

              if (isEdit) {
                data["id_usuario"] = usuario["id_usuario"];
                data["activo"] = usuario["activo"] ?? 1;
                
                data["password_hash"] = passCtrl.text.isEmpty ? usuario["password"] : passCtrl.text;
              } else {
                data["password"] = passCtrl.text;
              }

              bool ok = isEdit ? await _service.updateUsuario(data) : await _service.saveUsuario(data);
              if (ok) {
                setState(() {});
                Navigator.pop(context);
              }
            },
            child: Text(isEdit ? 'Actualizar' : 'Crear'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingRole) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (!_canAccess) {
      return Scaffold(
        appBar: AppBar(title: const Text('Usuarios')),
        body: const Center(
          child: Text('Acceso denegado: solo administradores.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: FutureBuilder<List<dynamic>>(
        future: _service.getUsuarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No hay usuarios.'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final u = data[i];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text("${u['nombre']} ${u['apellido_paterno']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _abrirFormulario(usuario: u)),
                    IconButton(icon: const Icon(Icons.delete, color: Colors.red), 
                      onPressed: () async {
                        await _service.deleteUsuario(int.parse(u['id_usuario'].toString()));
                        setState(() {});
                      }
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _abrirFormulario(), child: const Icon(Icons.person_add)),
    );
  }
}