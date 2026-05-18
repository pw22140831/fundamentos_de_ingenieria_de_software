import 'package:flutter/material.dart';
import 'package:blockcode/services/inventario_service.dart';

class InventarioScreen extends StatefulWidget {
  const InventarioScreen({super.key});

  @override
  State<InventarioScreen> createState() => _InventarioScreenState();
}

class _InventarioScreenState extends State<InventarioScreen> {
  final InventarioService _service = InventarioService();

  void _abrirFormulario({Map<String, dynamic>? item}) {
    final isEdit = item != null;
    final proyectoCtrl = TextEditingController(
      text: item?['id_proyecto']?.toString() ?? '',
    );
    final recursoCtrl = TextEditingController(text: item?['nombre_recurso'] ?? '');
    final cantidadCtrl = TextEditingController(
      text: item?['cantidad']?.toString() ?? '',
    );
    final estadoCtrl = TextEditingController(text: item?['estado'] ?? 'Activo');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Editar Inventario' : 'Nuevo Inventario'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: proyectoCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'ID Proyecto'),
              ),
              TextField(
                controller: recursoCtrl,
                decoration: const InputDecoration(labelText: 'Nombre Recurso'),
              ),
              TextField(
                controller: cantidadCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
              TextField(
                controller: estadoCtrl,
                decoration: const InputDecoration(labelText: 'Estado'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () async {
              final idProyecto = int.tryParse(proyectoCtrl.text.trim());
              final cantidad = int.tryParse(cantidadCtrl.text.trim());

              if (idProyecto == null || cantidad == null || recursoCtrl.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Completa los campos correctamente.')),
                );
                return;
              }

              final data = <String, dynamic>{
                'id_proyecto': idProyecto,
                'nombre_recurso': recursoCtrl.text.trim(),
                'cantidad': cantidad,
                'estado': estadoCtrl.text.trim().isEmpty ? 'Activo' : estadoCtrl.text.trim(),
              };

              if (isEdit) {
                data['id_inventario'] = item['id_inventario'];
              }

              final ok = isEdit
                  ? await _service.updateInventario(data)
                  : await _service.saveInventario(data);

              if (!context.mounted) return;

              if (ok) {
                setState(() {});
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No se pudo guardar el registro.')),
                );
              }
            },
            child: Text(isEdit ? 'Actualizar' : 'Crear'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventario')),
      body: FutureBuilder<List<dynamic>>(
        future: _service.getInventarios(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No hay inventario.'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final inv = data[i] as Map<String, dynamic>;
              return ListTile(
                title: Text(inv['nombre_recurso']?.toString() ?? 'Sin nombre'),
                subtitle: Text(
                  'Proyecto: ${inv['proyecto']} | Cantidad: ${inv['cantidad']} | Estado: ${inv['estado']}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _abrirFormulario(item: inv),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final id = int.tryParse(inv['id_inventario'].toString());
                        if (id == null) return;
                        await _service.deleteInventario(id);
                        setState(() {});
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
