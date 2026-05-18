import 'package:flutter/material.dart';
import 'package:blockcode/services/proyecto_service.dart';
import 'package:blockcode/presentation/screens/transacciones_screen.dart';

class ProyectosScreen extends StatefulWidget {
  const ProyectosScreen({super.key});

  @override
  State<ProyectosScreen> createState() => _ProyectosScreenState();
}

class _ProyectosScreenState extends State<ProyectosScreen> {
  final ProyectoService _service = ProyectoService();

  void _mostrarFormulario({Map<String, dynamic>? proyecto}) {
    final nombreCtrl = TextEditingController(text: proyecto?['nombre']);
    final respCtrl = TextEditingController(text: proyecto?['responsable']);
    final presuCtrl =
        TextEditingController(text: proyecto?['presupuesto']?.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(proyecto == null ? 'Nuevo Proyecto' : 'Editar Proyecto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(
                controller: respCtrl,
                decoration: const InputDecoration(labelText: 'Responsable')),
            TextField(
                controller: presuCtrl,
                decoration: const InputDecoration(labelText: 'Presupuesto'),
              keyboardType:
                const TextInputType.numberWithOptions(decimal: true)),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              try {
                final presupuestoTexto = presuCtrl.text.trim().replaceAll(',', '.');
                final presupuesto = double.tryParse(presupuestoTexto);

                if (presupuesto == null) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ingresa un presupuesto valido.')),
                  );
                  return;
                }

                final data = {
                  "nombre": nombreCtrl.text,
                  "responsable": respCtrl.text,
                  "fecha_inicio": "2024-01-01",
                  "fecha_fin": "2024-12-31",
                  "presupuesto": presupuesto,
                };
                if (proyecto != null) {
                  data["id_proyecto"] = proyecto["id_proyecto"];
                }

                final ok = proyecto == null
                    ? await _service.saveProyecto(data)
                    : await _service.updateProyecto(data);

                if (ok) {
                  setState(() {});
                  if (!context.mounted) return;
                  Navigator.pop(context);
                }
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error al guardar proyecto: $e')),
                );
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
      appBar: AppBar(title: const Text('Proyectos')),
      body: FutureBuilder<List<dynamic>>(
        future: _service.getProyectos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final data = snapshot.data ?? [];
          if (data.isEmpty) {
            return const Center(child: Text('No hay proyectos.'));
          }
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, i) {
              final p = data[i];
              return ListTile(
                title: Text(p['nombre']),
                subtitle: Text("Responsable: ${p['responsable']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    
                    IconButton(
                      icon: const Icon(Icons.list_alt, color: Colors.green),
                      tooltip: 'Administrar Transacciones',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransaccionesScreen(proyecto: p),
                          ),
                        );
                      },
                    ),
                    
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _mostrarFormulario(proyecto: p),
                    ),
                    
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _service
                            .deleteProyecto(int.parse(p['id_proyecto'].toString()));
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
        onPressed: () => _mostrarFormulario(),
        child: const Icon(Icons.add),
      ),
    );
  }
}