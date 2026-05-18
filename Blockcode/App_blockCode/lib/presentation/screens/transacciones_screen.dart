import 'package:flutter/material.dart';
import 'package:blockcode/services/transaccion_service.dart';
import 'package:blockcode/services/auth_service.dart';

class TransaccionesScreen extends StatefulWidget {
  final Map<String, dynamic> proyecto;

  const TransaccionesScreen({super.key, required this.proyecto});

  @override
  State<TransaccionesScreen> createState() => _TransaccionesScreenState();
}

class _TransaccionesScreenState extends State<TransaccionesScreen> {
  final TransaccionService _service = TransaccionService();

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _abrirFormulario({Map<String, dynamic>? transaccion}) {
    final isEdit = transaccion != null;
    
    
    final tipoCtrl = TextEditingController(text: transaccion?['tipo'] ?? 'Ingreso');
    final montoCtrl = TextEditingController(text: transaccion?['monto']?.toString() ?? '');
    final descCtrl = TextEditingController(text: transaccion?['descripcion'] ?? '');
    
    final provCtrl = TextEditingController(text: transaccion?['id_proveedor']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Editar Transacción' : 'Nueva Transacción'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tipoCtrl,
                decoration: const InputDecoration(labelText: 'Tipo (Ingreso / Egreso)'),
              ),
              TextField(
                controller: montoCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Monto'),
              ),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                controller: provCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID Proveedor (Opcional)'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final tipo = tipoCtrl.text.trim();
              final descripcion = descCtrl.text.trim();
              final monto = double.tryParse(montoCtrl.text.trim());
              final proveedorText = provCtrl.text.trim();

              if (tipo.isEmpty || descripcion.isEmpty || monto == null || monto < 0) {
                _showError('Revisa los datos: tipo y descripcion obligatorios, monto valido >= 0.');
                return;
              }

              if (proveedorText.isNotEmpty && int.tryParse(proveedorText) == null) {
                _showError('ID Proveedor invalido. Debe ser numero entero.');
                return;
              }
              
              final auth = AuthService();
              final user = await auth.getUser();
              final idUsuario = user?['id_usuario'] ?? 1; 

              final data = {
                "id_proyecto": widget.proyecto['id_proyecto'],
                "id_usuario": idUsuario,
                "id_proveedor": proveedorText.isEmpty ? null : int.parse(proveedorText),
                "tipo": tipo,
                "monto": monto,
                "fecha": DateTime.now().toIso8601String().split('T')[0], 
                "descripcion": descripcion,
              };

              if (isEdit) {
                data["id_transaccion"] = transaccion["id_transaccion"];
              }

              try {
                if (isEdit) {
                  await _service.updateTransaccion(data);
                } else {
                  await _service.saveTransaccion(data);
                }

                setState(() {});
                if (!context.mounted) return;
                Navigator.pop(context);
              } catch (e) {
                final msg = 'Error al guardar transaccion: $e';
                debugPrint(msg);
                _showError(msg);
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
    final idProyecto = int.parse(widget.proyecto['id_proyecto'].toString());
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Transacciones: ${widget.proyecto['nombre']}'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _service.getTransaccionesPorProyecto(idProyecto),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No hay transacciones registradas.'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final t = data[i];
              final isIngreso = t['tipo'].toString().toLowerCase() == 'ingreso';

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: isIngreso ? Colors.green : Colors.red,
                  child: Icon(
                    isIngreso ? Icons.arrow_downward : Icons.arrow_upward, 
                    color: Colors.white
                  ),
                ),
                title: Text(t['descripcion'] ?? 'Sin descripción'),
                subtitle: Text('Monto: \$${t['monto']} | Fecha: ${t['fecha']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _abrirFormulario(transaccion: t),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        try {
                          await _service.deleteTransaccion(int.parse(t['id_transaccion'].toString()));
                          setState(() {});
                        } catch (e) {
                          final msg = 'Error al eliminar transaccion: $e';
                          debugPrint(msg);
                          _showError(msg);
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}